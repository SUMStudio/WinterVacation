## 从与非门到俄罗斯方块 Nand2tetris 《计算机系统要素》

We were losing the forest for trees.

随着计算机硬件与软件体系的高速发展，我们的计算机性能愈加强大，变得越来越复杂，然而，进入大学的一年多以来，我却一直在高级语言层面与计算机打交道。高级语言是怎样编译成二进制指令的？计算机又怎样能执行二进制指令？字符串是怎样输出到屏幕上的，计算机又怎样通过输入设备与人交互？

我们接触的计算机，操作系统，都被层层的商业专利所包裹， 在提供强大的计算能力，便利的调用接口的同时，也使得我们更难窥察到计算机的整个工作原理。

如何才能对计算机有更深刻的了解？最快速的方法是——自己动手做一台计算机！

 Shimon Schocken 是自组织式课程学习的发起者，Shimon Schocken 和Noam Nisan 为学生开发了一套从与非门开始，逐步构造计算机的的课程，他们把课程放到网络上，同时放出了工具，模拟器，內建芯片和课件以及教程，在接下来的几天里，我们从学习最基本的原理开始，构建现代化的计算机系统。

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180208/ahi2f6Cg88.png)

上图蓝色的部分是计算机指令集结构，这个课程第一部分学习的是蓝色区域以下的部分，从逻辑门以及时序电路开始，构造出 hdl 语言描述的 ，名叫 Hack 的计算机硬件平台，并设计完整的汇编指令集，并用这套计算机系统，运行一个弹球游戏。该课程由六个动手项目组成，带你从搭造最基本的逻辑门电路开始，直到构建一台功能齐全的通用计算机。在这个过程中，你将以最直接、最贴近的方式学到计算机是如何工作的，以及如何设计计算机。

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/I387D5jajh.png)

**在接下来的几天里，我将会按照学习进度，将我学习过程中的笔记进行整理和发布，将给出每个任务我自己的实现过程以及项目源码。笔记仅供参考，每个项目独立完成才会有更大的收获。 **

本项目使用教材：《计算机系统要素》

> [![计算机系统要素](https://img3.doubanio.com/lpic/s2207295.jpg)](https://img3.doubanio.com/lpic/s2207295.jpg)作者: [Noam Nisan](https://book.douban.com/search/Noam%20Nisan) / [Shimon Schocken](https://book.douban.com/search/Shimon%20Schocken) 
>
> 出版社: 电子工业出版社
>
> 副标题: 从零开始构建现代计算机
>
> 原作名: The Elements of Computer Systems: Building a Modern Computer from First Principles

网上资源地址：http://www.nand2tetris.org/ 包括本书的内容，PPT，软件等

推荐先修课程：数字电路（逻辑门、时序电路的基本知识）、Java 或 Python 等具有较完善库函数的高级语言（用于最后的汇编编译器的设计）



上帝创造与非门

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180208/J77IEihKlm.png)

**Happy Coding！**



TECS Software Suite 2.5 软件和资料打包下载（约32MB）：
（包括配套软件、配套软件源代码、实践项目源文件、软件使用教程、演讲材料、原版图书样章等内容）
<http://bv.csdn.net/down/TECS-Software-Suite-2_5.rar>

\-----------------------------------------------------------

TECS Software Suite 2.5 软件及源代码下载（约1.8MB）：
<http://bv.csdn.net/down/EOCS_Software.rar>

实践项目源文件打包下载（约725KB）：
<http://bv.csdn.net/down/EOCS_Projects.rar>

软件使用教程打包下载（约6MB）：
<http://bv.csdn.net/down/EOCS_Tutorial.rar>

演讲材料打包下载（约21MB）：
<http://bv.csdn.net/down/EOCS_Lecture.rar>

原版图书样章打包下载（约1.9MB）：
<http://bv.csdn.net/down/EOCS_Book.rar>

配套软件源代码下载：
<http://www1.idc.ac.il/tecs/software/tecs-open-source-2.5.zip>

附加软件（Jack语言IDE）：
<http://www1.idc.ac.il/tecs/software/JACK_IDE_SETUP.msi>

Hardware Simulator（硬件仿真器）教程下载：
<http://www1.idc.ac.il/tecs/tutorials/hardware-simulator.pps>
<http://www1.idc.ac.il/tecs/tutorials/hardware-simulator.pdf>

Assembler（汇编编译器）教程下载：
<http://www1.idc.ac.il/tecs/tutorials/assembler.pps>
<http://www1.idc.ac.il/tecs/tutorials/assembler.pdf>

CPU Emulator（CPU模拟器）教程下载：
<http://www1.idc.ac.il/tecs/tutorials/cpu-emulator.pps>
<http://www1.idc.ac.il/tecs/tutorials/cpu-emulator.pdf>

VM Emulator（VM模拟器）教程下载：
<http://www1.idc.ac.il/tecs/tutorials/vm-emulator.pps>
<http://www1.idc.ac.il/tecs/tutorials/vm-emulator.pdf>

Jack IDE 教程下载：
<http://www1.idc.ac.il/tecs/tutorials/jack-ide.pps>
<http://www1.idc.ac.il/tecs/tutorials/jack-ide.pdf>

