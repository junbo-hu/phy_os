# Linux0.11 第七章 初始化程序

## 序言    
&emsp; 在内核源代码init/目录中只有一个main.c文件。当head.s程序执行完后会将执行权交给main.c。    
&emsp; 学习前提：熟悉C语言指针，了解gcc的扩展特性，如内联函数、内嵌汇编语句等。

## 一、main.c 程序    
#### 1. 功能描述