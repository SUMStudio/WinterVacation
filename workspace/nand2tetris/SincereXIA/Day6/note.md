# Day6 机器语言 中

今天，我们先来完成第四章第一个汇编程序：

## 乘法程序

乘法程序 Mult.asm ：

>该程序的输入值存储在 R0 和 R1 中，程序计算 R0*R1 并将结果存入 R2
>
>Multiplies R0 and R1 and stores the result in R2.
>(R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

看起来好像很简单，如果用高级语言来写的话。但问题是，我们的 ALU 并没有乘法执行单元，我们只能变乘法为加法，通过循环相加得到最后的结果。

思路：

* 首先我们得完成输入，输入值储存在 R0 和 R1 中，而 JACK 汇编读取输入的唯一方法就是 A 指令：

  ```
  @R0
  ```

  这样我们就把 R0 读取了出来，接着，我们得把 A 中数据保存到 D 中。`D=A`

* 接下来我执行加法操作，我们的思路是 每次加法，把 R1 的数值减一，然后把 M 中的数值减一，减到 0 就停止，否则从头再次执行

* 最终汇编程序如图：

  ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/e1Ck4if1ld.png)

* 接下来我们用汇编编译器翻译成机器代码：

  *注意：汇编编译器名为：Assembler.bat*

  ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/f5d285F855.png)

* 不知道效果如何，我们上模拟器跑一下：![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/8jHiiBlHCc.png)

  FUCK居然炸了，仔细看一下测试脚本 ：

  ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/IHlbKa839m.png)

  套路深啊套路深！

  *他会检测有没有给R2初始化为0！*

  好吧好吧，果然程序员需要严谨。。。

* 重测试，好吧又没过，我看看哪里有问题，emmm ，发现自己手残，吧第17行写错了，应该是D=M我们修改一下

* 好吧这次又没过，好像这个汇编程序问题有点大。。。。我们得重构一下

  ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/hfdcDkJ1jF.png)

  好了好了过了：

  ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180126/5GJjI5L79G.png)

  写得心累。。。。

  ​

