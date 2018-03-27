# 操作系统的引导

## 实验目的
+ 建立对操作系统引导过程的深入认识；
+ 掌握操作系统的基本开发过程；
+ 能对操作系统代码进行简单的控制，揭开操作系统的神秘面纱。

## 实验内容
#### 实验基本内容：
1. 本实验参考《Linux内核完全注释》的第六章，了解Linux 0.11的引导过程；
2. 按照要求改写引导程序bootsect.s；
3. 改写进入保护模式前的设置程序setup.s。   

#### 改写bootsect.s主要完成如下功能：
1. bootsect.s能在屏幕上打印一段提示信息“XXX is booting...”,其中XXX自己定义。

#### 改写setup.s主要完成如下功能：
1. bootsect.s能完成setup.s的载入，并跳转到setup.s开始地址执行。setup.s向屏幕输出一行“Now we are in setup”；
2. setup.s能获取至少一个基本的硬件参数（如内存参数、显卡参数、硬盘参数等），将其存放在内存的特定地址，并输出到屏幕上；

## 实验步骤
#### 完成bootsect.s的屏幕输出功能
  关键代码：

    ! 首先读入光标位置
    mov    ah,#0x03        
    xor    bh,bh
    int    0x10

    ! 显示字符串“LZJos is running...”
    mov    cx,#25            ! 要显示的字符串长度
    mov    bx,#0x0007        ! page 0, attribute 7 (normal)
    mov    bp,#msg1
    mov    ax,#0x1301        ! write string, move cursor
    int    0x10

    inf_loop:
    jmp    inf_loop        ! 后面都不是正经代码了，得往回跳呀
    ! msg1处放置字符串

    msg1:
    .byte 13,10            ! 换行+回车
    .ascii "phyos is running..."
    .byte 13,10,13,10            ! 两对换行+回车
    !设置引导扇区标记0xAA55
    .org 510
    boot_flag:
    .word 0xAA55            ! 必须有它，才能引导

#### bootsect.s读入setup.s
  关键代码：

    load_setup:
    mov    dx,#0x0000        !设置驱动器和磁头(drive 0, head 0): 软盘0磁头
    mov    cx,#0x0002        !设置扇区号和磁道(sector 2, track 0):0磁头、0磁道、2扇区
    mov    bx,#0x0200        !设置读入的内存地址：BOOTSEG+address = 512，偏移512字节
    mov    ax,#0x0200+SETUPLEN    !设置读入的扇区个数(service 2, nr of sectors)，
                        !SETUPLEN是读入的扇区个数，Linux 0.11设置的是4，
                        !我们不需要那么多，我们设置为2
    int    0x13            !应用0x13号BIOS中断读入2个setup.s扇区
    jnc    ok_load_setup        !读入成功，跳转到ok_load_setup: ok - continue
    mov    dx,#0x0000         !软驱、软盘有问题才会执行到这里。我们的镜像文件比它们可靠多了
    mov    ax,#0x0000        !否则复位软驱 reset the diskette
    int    0x13
    jmp    load_setup    !重新循环，再次尝试读取
    ok_load_setup:
    ！接下来要干什么？当然是跳到setup执行。

#### setup.s获取基本硬件参数
  关键代码：

    mov    ax,#INITSEG    
    mov    ds,ax !设置ds=0x9000
    mov    ah,#0x03    !读入光标位置
    xor    bh,bh
    int    0x10        !调用0x10中断
    mov    [0],dx        !将光标位置写入0x90000.

    !读入内存大小位置
    mov    ah,#0x88
    int    0x15
    mov    [2],ax

    !从0x41处拷贝16个字节（磁盘参数表）
    mov    ax,#0x0000
    mov    ds,ax
    lds    si,[4*0x41]
    mov    ax,#INITSEG
    mov    es,ax
    mov    di,#0x0004
    mov    cx,#0x10
    rep            !重复16次
    movsb

    !以16进制方式打印栈顶的16位数
    print_hex:
    mov    cx,#4         ! 4个十六进制数字
    mov    dx,(bp)     ! 将(bp)所指的值放入dx中，如果bp是指向栈顶的话
    print_digit:
    rol    dx,#4        ! 循环以使低4比特用上 !! 取dx的高4比特移到低4比特处。
    mov    ax,#0xe0f     ! ah = 请求的功能值，al = 半字节(4个比特)掩码。
    and    al,dl        ! 取dl的低4比特值。
    add    al,#0x30     ! 给al数字加上十六进制0x30
    cmp    al,#0x3a
    jl    outp        !是一个不大于十的数字
        add    al,#0x07      !是a～f，要多加7
    outp:
    int    0x10
        loop    print_digit
        ret
    这里用到了一个loop指令，每次执行loop指令，cx减1，然后判断cx是否等于0。如果不为0则转移到loop指令后的标号处，实现循环；如果为0顺序执行。   
    另外还有一个非常相似的指令：rep指令，每次执行rep指令，cx减1，然后判断cx是否等于0，如果不为0则继续执行rep指令后的串操作指令，直到cx为0，实现重复。
    !打印回车换行
    print_nl:
    mov    ax,#0xe0d     ! CR
    int    0x10
    mov    al,#0xa     ! LF
    int    0x10
        ret

运行结果：  
![图1 用Bochs启动Linux 0.11以后的样子](https://github.com/junbo-hu/phy_os/blob/master/2-exper02-boot/images/bootsect.PNG)
