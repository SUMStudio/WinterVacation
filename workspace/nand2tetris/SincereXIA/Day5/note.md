# 机器语言

*Make everything as simple as possible, but not simpler.*

本章对机器语言做简要的介绍，然后对 Hack 机器语言进行学习，然后练习写一些机器语言程序

1. 背景知识

   * 机器语言，是指哪些机器的语言？

     **内存 处理器 寄存器**

     > 我们为什么需要寄存器？
     >
     > 因为内存访问较慢（指令格式很长），寄存器能使得处理器快速地操作数据和指令。

   * 语言？是什么样的语言？

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/fkC9AB67F7.png)

     机器语言实际上是一系列的二进制数，但通常我们会同时使用二进制码和助记符

     ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/k766DgHIi4.png)

     符号表示也称为**汇编语言**

     将汇编语言翻译成二进制代码的程序是**汇编编译器**

   * 机器语言中的指令

     1. **算术操作、基本逻辑操作（布尔操作）**

     2. **内存访问**

        > 直接寻址：数字表示指定内存单元的地址
        >
        > 立即寻址：（准确地讲，这应该叫做立即赋值）数字表示需要加载到寄存器中的常数

     3. **控制流程**

        反复、条件执行、子程序调用、无条件跳转

2. **Hack机器语言**

   Hack是一个16位计算机

   1. Hack的寄存器：

      Hack共有3个寄存器：

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/72igKKD7cj.png)

      其中：D仅用来储存数据值，A既是数据寄存器，又是地址寄存器，A寄存器中，保存了M寄存器中需要进行操作的那一位内存地址，另外，A中也可以保存需要的指令存储器的行号，比如执行 `goto 35`（跳转到第35行）前，需要将35赋给A寄存器

      > 助记：
      >
      > 两个单值寄存器：
      >
      > ​	D：数值寄存器
      >
      > ​	A：效应寄存器
      >
      > 两个海量寄存器：
      >
      > ​	ROM：指令寄存器
      >
      > ​	M：内存寄存器

      其中，D，A，为1位16位宽寄存器；ROM 和 M 为15位16位宽寄存器，最大寻址能力是32K

   2. A 指令 `@value`

      ```
      @value          //这里的 value 是一个非负的十进制数，或一个代表非负十进制数的符号
      0vvv vvvv vvvv vvvv //v= 0 or 1
      ```

      A 指令有三个效应：

      * 直接把数值放入 A 寄存器中
      * 选定对应的 M 中那一位寄存单元
      * 确定需要跳转的指令地址

   3. **C 指令** *控制指令*

      C 指令明确以下三个问题：

      * 计算啥
      * 放到哪
      * 然后干啥

      汇编格式：

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/kl8Jf4dC1a.png)

      其中，dest 和 jump 可以为空，若dest为空，= 省略，若 jump 为空， ； 省略

      其二进制代码为16位二进制数

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/G8AKb6e041.png)

      其中，前三位均为一，代表 C 指令。紧接着的七位为comp指令

      comp 指令有 7 位，第一位是 a-bit，当 a-bit = 0 时，可以近似看做A寄存器和D寄存器以及常数计算。当a-bit=1 时，可以近似看做 D 寄存器和 M 寄存器参与运算。其对应的 comp 助记符在第67页。

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/hA0C978Ii7.png)

      再往后三位为 dest 位，这三位用来确定 ”放到哪“ 这个问题。d1 d2 d3 分别代表 A D M 三个寄存器。哪位取了1，就把计算出来的值存放在哪一寄存器中（可以同时存放到多个寄存器中）

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/L1k6582GgA.png)

      再往后三位为 Jump 位，取名为 j1 j2 j3 他们一同确定了8种跳转情况，跳转到 A 寄存器储存的行号去，当这三位均为 0 时，不跳转，程序继续执行下一行。

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/H9kKd7aa2C.png)

      **注意** ：由于 A 寄存器即使要跳转的行号，又是要取数据的 RAM（M） 地址，因此，若一条机器指令中有Jump行为，则这条指令不能引用 M 寄存器！（A 不能同时做内存地址和跳转地址）

   4. 符号 Symbols

      * 预定义符号
        * 虚拟寄存器：*R0 到 R15 代表 0 到 15 号的 RAM（M寄存器） 地址*
        * 预定义指针：SP LCL ARG THIS THAT 表示 0 到 4 号 RAM 地址
        * I/O 指针：SCREEN 和 KBD 表示 RAM 地址 16384 和 24576
      * 标签符号 `(XXX)` 是跳转操作的锚点，使用`@xxx` 之后，便可通过下一次JUMP指令跳转到该位置
      * 变量符号：直接被视作变量，从 RAM 地址 16 开始分配内存

      有了这些知识之后，我们就能写出我们自己的 HACK 程序了！

      ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180125/875F39c2EF.png)

      HAPPY CODING!!

      ​