# day11 虚拟机 1

虚拟机 Virtual Machine 将实体的计算机进行进一步封装，运行一种介于高级语言和汇编语言之间的 *VM指令*

VM语言包括四种类型的命令：

* 算术命令
* 内存访问
* 程序流程控制
* 子程序调用

本章我们要构建的**VM翻译器**能将前两种VM指令翻译成 Hack 机器命令。

在编写VM翻译器前，我们需要对 VM 指令进行学习

1. VM 指令概述：

   VM 语言运行在 VM 虚拟机上，VM 虚拟机是一个堆栈机，堆栈机根据指令，将需要操作的数据在堆栈上进行操作，并将计算结果从堆栈中弹出到内存单元，或是从内存单元中读取数据到堆栈，神奇的是，任何数学或逻辑表达式，都能转化为对堆栈的简单操作。
