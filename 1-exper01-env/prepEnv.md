# OS实验环境准备

**致谢**：[DeathKing/hit-oslab项目](https://github.com/DeathKing/hit-oslab)，我的修改脚本及原材料均来自于大大[DeathKing](https://github.com/DeathKing)的[hit-oslab](https://github.com/DeathKing/hit-oslab)项目，特此声明原创出>处，深表感谢！
**参考博客**：[操作系统实验报告-熟悉实验环境](http://www.cnblogs.com/tradoff/p/5693710.html)
**适用系统**：ubuntu 16.04 amd64

## 主要平台和工具简介
### x86模拟器Bochs
  x86是工业界和学术界对Intel IA-32架构CPU的统称   
  Bochs是一个免费且开源的IA-32架构PC机模拟器。在它模拟出的环境中可以运行Linux、DOS和各种版本的Windows等多种操作系统。而Bochs本身具有很高的移植性，可以运行在多种软硬件平台之上。   
  因为Bochs是模拟器，其原理决定了它的运行效率会低于虚拟机。

### GCC编译器
  GCC是和Linux一起成长起来的编译器。Linux最初的版本就是由GCC编译的。现在GCC也是在自由软件领域应用最广泛的编译器。

### Ubuntu(GNU/Linux)
  Ubuntu是现在流行的Linux发行版之一，主要特点是易用。

## 实验环境的工作模式   
  实验所需文件是在[DeathKing/hit-oslab项目](https://github.com/DeathKing/hit-oslab)下载的,在宿主机上对Linux0.11进行修改、编译之后，在linux-0.11目录下会产生一个名为Image的文件，它就是编译之后的目标文件。该文件内已经包含引导和所有内核的二进制代码。如果拿一张软盘，从它的0扇区开始，逐字节写入Image文件的内容，就可以用这张软盘启动一台真正的计算机，并进入Linux0.11内核。
  我们使用Bochs来加载这个Image文件，模拟执行Linux0.11.bochs目录下是与bochs相关的执行文件、数据文件和配置文件。run是运行bochs的脚本命令。运行后bochs会自动在它的虚拟软驱A和虚拟硬盘上各挂载一个镜像文件，分别是linux-0.11/Image和hdc-0.11.img。bochs配置从软驱A启动，当linux0.11被加载后会驱动硬盘，并mount硬盘上的文件系统，也就是hdc-0.11.img内镜像的文件系统挂载到0.11系统内的根目录。   
  hdc-0.11.img文件的格式是Minix文件系统的镜像，宿主机也可以挂载此文件系统映像实现宿主Linux和linux0.11之间的文件交换。   
  hdc-0.11.img中包含以下内容：   
+ Bash shell
+ 一些基本的Linux命令、工具，比如cp、rm、mv、tar。
+ vi编辑器
+ gcc1.4编译器，可用来编译标准C程序
+ as86和ld86
+ Linux 0.11的源代码，可在0.11下编译，然后覆盖现有的二进制内核

## 使用方法
    1. 执行脚本完成环境配置   
```bash
./setup.sh
```
    2. 编译内核   
	进入linux-0.11目录，然后执行：
```bash
make all
```
    3. 运行
	在phyoslab目录下执行：
```bash
./run
```
	如果出现Bochs的窗口，里面显示linux的引导过程，最后停止在“[/usr/root/]#”，表示运行成功，如下图所示。
![图1 用Bochs启动Linux 0.11以后的样子](https://github.com/junbo-hu/phy_os/blob/master/1-exper01-env/images/bochs_run_linux0.11_first.PNG)    

    4. 调试
	汇编级调试需执行命令：
```bash
./dgb-asm
```
	C语言级调试先执行：
```bash
./dbg-c
```
	再打开一个终端窗口执行
```bash
./rungdb
```
    5. Ubuntu和Linux 0.11之间的文件交换
	首先在Ubuntu下mount hdc：
```bash
sudo ./mount-hdc
```
	修改完文件后记得卸载文件系统
```bash
sudo umount hdc
```
