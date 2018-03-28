# phy_os

## 1. [操作系统实验环境搭建](https://github.com/junbo-hu/phy_os/blob/master/1-exper01-env/prepEnv.md)
 内容大部分是借鉴[DeathKing/hit-oslab项目](https://github.com/DeathKing/hit-oslab) 完成。

## 2. [操作系统的引导](https://github.com/junbo-hu/phy_os/blob/master/2-exper02-boot/boot.md)
 本实验需要对操作系统实模式和保护模式有一定了解，详情请参阅《Linux内核完全注释》

## 3. [系统调用](https://github.com/junbo-hu/phy_os/blob/master/3-exper03-syscall/systemcall.md)
开始试验之前请先了解操作系统的中断处理和系统调用过程，可以参考我的[学习笔记](https://github.com/junbo-hu/phy_os/tree/master/3-exper03-syscall/chapter05_note.md)

## 4.[知识补充—80x86保护模式](./4-protect-mode/protect_mode_part1.md)    
+ 后续实验难度会加大，先补充些知识，前面第二讲里介绍了系统引导模块，但只是讲了bootsect.s和setup.s，因为它们都是运行在相对简单的实模式下。内核引导模块核心还是在head.s，在head.s中完成实模式到保护模式的跳转，并且对保护模式内容初始化。    

+ 由于本节内容比较多，比较难，我将它分成几个小结，希望读者有耐心将其学习下去，想当年我也是花了一周时间才勉强将这章内容学懂。
