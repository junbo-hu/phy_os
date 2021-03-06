# Linux 0.11 第6章学习笔记

## 序言
+ 本章主要描述boot/目录中的三个汇编代码文件：bootsect.s、setup.s、head.s。

+ bootsect.s和setup.s是实模式下运行的16位代码程序，采用近似Intel的汇编语言语法并且需要使用Intel8086汇编编译器和连接器as86和ld86，而head.s则是使用GNU的汇编程序格式，相应汇编器为gas。

+ 直到2.4.X版本起，bootsect.s和setup.s程序才完全使用统一的as来编写。

## 6.1 总体功能
### Linux启动部分的主要执行流程
![图1 用Bochs启动Linux 0.11以后的样子](https://github.com/junbo-hu/phy_os/blob/master/2-exper02-boot/images/boot.JPG)

如上图：PC加电进入实模式--->从地址0xFFFF0开始自动执行代码--->BIOS自检并在0地址初始化中断向量--->载入磁盘第一个扇区到0x7C00（31KB处）并跳转到此处执行--->bootsect将自己移动到0x90000（576KB处）处--->将2KB代码setup.s读入到0x90200处--->将system模块读入0x10000（64KB处）--->setup程序将system模块移动到0地址处进入保护模式。

+ 问题一：为什么bootsect不把系统模块直接加载到0x00000开始处而是在setup中将system模块移动？

  答：因为在随后的setup代码开始部分还需要利用ROM BIOS中的中断调用来获取机器的一些参数（如显卡模式、硬盘参数表等）。

## 6.2 bootsect.s程序
1. 功能描述：   
 bootsect.s代码是磁盘引导块程序，驻留在磁盘的第一个扇区（引导扇区），主要作用是把磁盘第2个扇区开始的4个扇区大小的setup模块加载到内存放到0x90200处，接着显示“Loading system...”。再讲磁盘上setup模块后面的system模块加载到内存0x10000开始的地方。然后确定跟文件系统的设备号，最后长跳转到setup程序的开始处（0x90200)执行setup程序。
2. 代码注释（自己查阅赵炯的书籍）

## 6.3 setup.s 程序
1. 功能描述   
  setup.s是一个操作系统加载程序，主要作用是利用ROM BIOS中断读取机器系统数据，并将这些数据保存到0x90000开始的位置。然后将system模块从0x10000移动到0x00000处。接下来：加载idtr和gdtr--->开启A20地址线--->重新设置两个中断控制芯片8259A--->设置CPU的控制寄存器CR0，从而进入32位保护模式运行--->跳转到system模块中最前面的head.s程序继续运行。

 注：A20并不是进入保护模式的关键，只是需要打开A20才能访问到1M以上的内存空间。  另外为了让head.s能在32位保护模式下运行，这里临时设置了IDT和GDT，并在GDT中设置了当前内核代码段的描述符和数据段的描述符。到head.s中又会重新设置这些表。
