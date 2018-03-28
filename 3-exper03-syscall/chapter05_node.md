# Linux 0.11第5章学习笔记
## 一、Linux系统的中断机制
### 1、中断操作原理
+ 处理器使用轮询方式为输入输出设备提供服务，这种软件编程优点是比较简单，但缺点是太耗处理器资源，影响性能。

+ 另一种为设备提供服务的方式：当设备需要服务时自己向处理器提出请求，处理器会在执行完当前的一条指令后立刻应答设备的请求并转而执行该设备的相关服务程序。这便是中断。

+ 设备箱处理器发出的服务请求称为中断请求IRQ，处理器响应请求而执行的设备相关程序被称为中断服务程序ISR。

+ 可编程中断控制器（PIC）是微机系统中管理设备中断请求的管理者。

+ 中断过程：设备发出IRQ--->PIC对接收到的IRQ和正在执行的IRQ进行优先级比较--->PIC向CPU的INT引脚发出中断信号，处理器停下当前任务询问PIC要执行哪个IRQ--->CPU根据中断号查询中断向量表（或保护模式下的中断描述符表）--->取得中断向量（ISQ的地址）并执行ISQ--->当中断服务程序执行结束，CPU继续执行被中断信号打断的程序。

注：以上只是介绍的硬件中断，其实还有很多软件中断以及异常。

## 二、Linux的系统调用
### 1、系统调用接口
+ 应用程序一般使用具有标准接口定义的C库函数间接地使用内核的系统调用。

+ syscalls使用函数形式进行调用，因此可以带一个或多个参数。

+ 返回值为负数表示出错，0表示成功。出错时，错误码被存放在全局变量errno中，通过调用库函数perror()可以打印出该错误码对应的出错字符串信息。

+ 代码实现：在include/unistd.h中定义syscall功能号--->功能号对应include/linux/sys.h中的系统调用处理程序指针数组表sys_call_table[]中项的索引值。

### 2、系统调用处理过程
+ int 0x80向内核发出一个中断，eax中存放系统调用号，ebx、ecx、edx中依次存放其参数。所以linux0.11内核中用户程序能够像内核最多直接传递三个参数。

+ 内核中include/unistd.h定义了宏函数_syscalln()（n代表传入的参数个数，0到3个），所以我们就可以直接用这个宏定义来调用系统调用而不用通过库函数。

+ 当进入内核中的系统调用处理程序kernel/system_call.s后，system_call的代码会首先检查eax中的系统调用功能号是否在有效系统调用号范围内，然后根据sys_call_table[]函数指针表调用执行相应的系统调用处理程序。

### 3、Linux系统调用的参数传递方式
+ 一是通过寄存器ebx、ecx、edx传递，其优点：当进入系统终端服务程序而保存寄存器值时，这些传递参数的寄存器也被自动地放在了内核态堆栈上，不用再专门对传递参数的寄存器进行特殊处理。另外还可以通过系统调用门的参数传递方法，它通过在进程用户态堆栈和内核态堆栈自动复制传递的参数，但此方法比较复杂。