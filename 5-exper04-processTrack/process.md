# 进程运行轨迹的跟踪与统计
## 实验目的
+ 掌握Linux下的多进程编程技术；
+ 通过对进程运行轨迹的跟踪来形象化进程的概念；
+ 在进程运行轨迹跟踪的基础上进行相应的数据统计，从而能对进程调度算法进行实际的量化评价，更进一步加深对调度和调度算法的理解，获得能在实际操作系统上对调度算法进行数据对比的直接经验。

## 实验内容    
进程从创建（Linux下调用fork()）到结束的整个过程就是进程的生命期，进程在其生命期中的运行轨迹实际上就表现为进程状态的多次切换，如进程创建以后会成为就绪态；当该进程被调度以后会切换到运行态；在运行的过程中如果启动了一个文件读写操作，操作系统会将该进程切换到阻塞态（等待态）从而让出CPU；当文件读写完毕以后，操作系统会在将其切换成就绪态，等待进程调度算法来调度该进程执行......

本次实验包括如下内容：   
+ 基于模板"process.c"编写多进程的样本程序，实现如下功能：
  + 所有子进程都并行运行，每个子进程的实际运行时间一般不超过30秒；
  + 父进程向标准输出打印所有子进程的id，并在多有子进程都退出后才退出；

+ 在Linux0.11上实现进程运行轨迹的跟踪。基本任务是在内核中维护一个日志文件/var/process.log，把从操作系统启动到关机过程中所有进程的运行轨迹都记录在这一个log文件中；

+ 在修改过的0.11上运行样本程序，通过分析log文件，统计该程序建立的所有进程的等待时间、完成时间（周转时间）和运行时间，然后计算平均等待时间，平均完成时间和吞吐量。

+ 修改0.11进程调度的时间片，然后再运行同样的样本程序，统计同样的时间数据，和原有的情况对比，体会不同时间片带来的差异。

/var/procecess.log文件的格式为：   
```log
pid    X   time    
```    
其中：    
+ pid是进程的ID；
+ X可以使N、J、R、W和E中的任意一个，分别表示进程新建、进入就绪状态、进入运行状态、进入阻塞态、退出；
+ time表示X发生的时间。这个时间不是物理时间，而是系统的滴答时间（tick，此处不清楚可以先查看[系统时间和定时](./system_time.md)）。

+ 任务0的内存布局    
&emsp;&emsp;进程控制块PCB是一个task_struct类型的结构体，里面存放系统用于描述进程的所有信息：进程的pid,进程的状态，进程已打开的文件描述符，TSS(Task State Segment，**存放硬件上下文**)和LDT(**存放进程数据段和代码段信息的**)    
  + 操作系统内核堆栈与任务0的内核态堆栈
