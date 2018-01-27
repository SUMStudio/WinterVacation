# DAY 7 机器语言 下

今天，我们用 HACK 语言编写一个 I/O 处理程序：

I/O 即 输入输出，我们通过 I/O 处理程序，依照外部输入，修改特定区域的数据，CPU 再从该区域读取输入的数据，输出 在内存中也有特定区域的地址，输出程序通过修改指定区域的数据，外设读取该区域的数据，转换成人类能观测到的信号，实现输出。

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/8C51dfBAci.png)

1. 显示器输出

   HACK 的显示设备：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/LF4ecFa0H3.png)

2. 输入设备：

   HACK 的键盘输入：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/JhGK6gE3LD.png)

   键盘二进制码速查表：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/Hf6b3I498H.png)

3. 自己编写一个简单的 I/O 程序：

   Fill.asm:

   按下任意按键时，屏幕将变全黑，当没有按键按下时，屏幕将清屏。

   需要处理的逻辑有点多，写出来的第一个版本：

   ```
   // This file is part of www.nand2tetris.org
   // and the book "The Elements of Computing Systems"
   // by Nisan and Schocken, MIT Press.
   // File name: projects/04/Fill.asm

   // Runs an infinite loop that listens to the keyboard input.
   // When a key is pressed (any key), the program blackens the screen,
   // i.e. writes "black" in every pixel;
   // the screen should remain fully black as long as the key is pressed. 
   // When no key is pressed, the program clears the screen, i.e. writes
   // "white" in every pixel;
   // the screen should remain fully clear as long as no key is pressed.

   // Put your code here.
   @SCREEN
   D=A
   @R0
   M=D //初始化该处理的像素位
   (FOREVER)
   @KBD
   D=M //从键盘读取输入
   @FILL
   D;JNE //若有输入，跳过清零，点亮像素
   @SCREEN
   D=A
   @R0
   D=M-D
   @FOREVER
   D;JLT //清零出界则取消清零
   @R0
   A=M
   M=0 //对应像素点清屏
   @R0
   M=M-1
   @FOREVER
   0;JMP //单次清屏结束，跳转检测输入
   (FILL)
   @24576
   D=A
   @R0
   D=D-M
   @FOREVER
   D;JLT //点亮出界则取消点亮
   @R0
   A=M
   M=-1 //对应像素点亮
   @R0
   M=M+1
   @FOREVER
   0;JMP
   ```

   我靠居然能跑！太感动了！（只要注释写的好，多复杂的逻辑都能跑）看看效果：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/7b9li8mgLa.png)

   仔细看！屏幕开始渲染了，就是渲染的有点太慢了。。。。

   **注意：为了加快程序运行，需在 View 选项卡中，将 No Animation 勾选** 

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/abD2Cl957e.png)

   我们上自动脚本测试一下：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/ffCji6BI4j.png)

   可以，内存溢出了，我们稍微修改一下：

   第43行改为 `D;JLE`

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/727cf0C0k3.png)

   完美！

# Day 7 计算机体系结构

本节的背景知识只是之前内容的总结，在此便不再赘述。本章的重点是构建完整的 HACK 平台，最后得到一个 Cumputer

1. **内存** RAM

   HACK RAM 芯片由三组内存区域构成，分别是：

   * 16K 数据内存
   * 8K 屏幕映像
   * 1Bit 键盘映像

   其中，数据内存的起始位置在0，屏幕映像的起始位置在 0x4000 （二进制：0100000000000000）；键盘位于 0x6000（二进制：0110000000000000）

   因此，设计内存，就要通过 in[14] 和 in[13] 进行数据区域的选择，然后用剩余输入位，在对应的数据区域内部进行定位。

   我们首先构建寄存器区域选定逻辑，通过   in[14] 和 in[13]  输入位的状态来决定三个寄存器组的 load 位情况：

   ```
       Not(in=address[14], out=selRAM16);
       And(a=address[14], b=address[13], out=selKBD);
       Not(in=selKBD, out=notselKBD);
       And(a=address[14], b=notselKBD, out=selSCREEN);    
       And(a=selRAM16, b=load, out=loadRAM16);
       And(a=selKBD, b=load, out=loadKBD);
       And(a=selSCREEN, b=load, out=loadSCREEN);
   ```

   屏幕映射由两块 RAM 4k 构成，同样需要进行 load 选择：

   ```
       And(a=loadSCREEN, b=in[13], out=loadSC1);
       Not(in=loadSC1, out=notloadSC1);
       And(a=loadSCREEN, b=notloadSC1, out=loadSC0);
   ```

   然后堆砌寄存器：

   ```
       RAM16K(in=in, load=loadRAM16, address=address[0..13], out=outRAM16);
       RAM4K(in=in, load=loadSC0, address=address[0..11], out=outSC0);
       RAM4K(in=in, load=loadSC1, address=address[0..11], out=outSC1);
       Register(in=in, load=loadKBD, out=outKBD);
   ```

   最后选择输出：

   ```
       Mux16(a=outSC0, b=outSC1, sel=in[13], out=outSCREEN);
       Mux16(a=outSCREEN, b=outKBD, sel=selKBD, out=outIO);
       Mux16(a=outIO, b=outRAM16, sel=selRAM16, out=out);
   ```

   测试时，我看到这句话的时候是懵逼的：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/8cILEHb0Ik.png)

   Keyboard icon 在哪里。。。。。

   后来我意识到一个严重的错误，我应该直接用他现成提供的 Screen 和 keyboard 芯片。。。

   我们先把 keyboard 芯片换上，看似很顺利，然而：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/Kk545CAjJ9.png)

   还是有问题，定位问题发现是 load 两块4k的时候有问题，稍微修改一下

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/h5dHFgEDB2.png)

   靠 还是有问题，不管了，自己做的屏幕可能比较垃圾，我们换上原装屏幕：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/C7BIKg9b6c.png)

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180127/dIGC5aecG2.png)

   当当当当！最后屏幕上面会出现两条横线，Memory 芯片 OK！





