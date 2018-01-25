# day4 做一块内存！

今天我们通过DFF（钟控D触发器）开始，构建1位寄存器、寄存器、n寄存器、计数器

最终构建出我们自己的一块内存

1. Bit 1位寄存器

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/Hh651G90iK.png?imageslim)

   1位寄存器如图所示，两个输入端：in、load

   其中，in代表数据输入，Load为写入锁，load为1时，寄存器存入in的数据，从下一个时钟周期开始，out端输出存入的数据。

   Bit实现的核心思想是，将输出数据作为输入，重新输入到DFF中，实现数据锁存的目的，但直接把out端接入in会导致外部数据无法输入，DFF状态无法更新

   Bit寄存器使用一个DFF和一个MUX实现，MUX选择DFF的输入到底是外部数据，还是自身输出，实现了状态的保存和更新功能。DFF为內建芯片，无需实现，MUX在DAY1中已经实现过。

   Bit的逻辑电路图如图所示：![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/FDJBlA1Edb.png)

   按照电路图直接写出的HDL代码应该是这样的：![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/i8b9LGGeGD.png)

   然而坑爹的HDL不能直接把out当做输入管脚！我们不得不多引入一个内部管脚Final，然后用一个Mux门进行输出：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/cKFEJcLaJl.png)

2. 寄存器 

   通过一组1位寄存器可以构建出n位寄存器，然后将load中的每一位数据分别交给一个寄存器保存。

   本书要求实现一个16位寄存器。可以想象，又是一大堆重复代码。

   同样，再写段python偷懒![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/j6Egem8Aka.png)

   结果：![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/EdA7CfAIIa.png)

3. 8-寄存器：

   8寄存器需要8个寄存器排列起来，其核心是构建一个逻辑，能通过address选出需要取值或者赋值的寄存器

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/e56lmFa9Ac.png)

   我们先堆起来8个寄存器：

   ```
   Register(in=in, load=load0, out=out0);
   Register(in=in, load=load1, out=out1);
   Register(in=in, load=load2, out=out2);
   Register(in=in, load=load3, out=out3);
   Register(in=in, load=load4, out=out4);
   Register(in=in, load=load5, out=out5);
   Register(in=in, load=load6, out=out6);
   Register(in=in, load=load7, out=out7);
   ```

   如何实现对指定的寄存器输入呢？ **8路译码器**

   ```
   DMux8Way(in=true, sel=address, a=load0, b=load1, c=load2, d=load3, e=load4, f=load5, g=load6, h=load7);
   ```

   如何实现提取指定地址的寄存器数据呢? **8选一数据选择器**

   ```
   Mux8Way16(a=out0, b=out1, c=out2, d=out3, e=out4, f=out5, g=out6, h=out7, sel=address, out=out);
   ```

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/2hJJhblBIA.png)

   啊哈好像出错了

   仔细看一下，8路译码器的in输入不应该是true，应该是load，修正之后，重上模拟器测试：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/IhdBg75i91.png)

   很稳

4. 64-寄存器

   我们试试用八个8-寄存器拼成一个64-寄存器，其核心思路是将地址前三位8-寄存器的选择信号，思路与之前无差。

   写完之后是这样：![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/ge7ch4lfjb.png)

   注意address的局部总线取哪几位

   **好啦，今天我们的内存(RAM)就做好了** 下面我们来实现另一个重要的时序部件：计数器

5. 计数器 Counter

   计数器用来操作CPU去执行制定行数的代码，因此，它需要以下功能：

   1. 增一运算——执行下一行代码
   2. 重置运算——跳转到制定行
   3. 清零运算——回到程序头

   所以，他有三个操控端：inc 、 reset、load

   if      (reset[t] == 1) out[t+1] = 0

   else if (load[t] == 1)  out[t+1] = in[t]

   else if (inc[t] == 1)   out[t+1] = out[t] + 1  (integer addition)

   因此，我们需要一个寄存器，当inc、reset、load 均失效时，寄存器能保存现在的数字

   我们还需要一个增一器，能实现增一运算（上一章实现过）。

   ```
   Register(in=regIn, load=load1, out=final);
   Inc16(in=final, out=finalplus);
   ```

   接下来呢，我们需要两个数据选择器，将三种状态——增一、重置、清零，三选一输入到Register的输入端：

   ```
   Mux16(a=finalplus, b=in, sel=load, out=newdata);
   Mux16(a=newdata, b=false, sel=reset, out=regIn);
   ```

   用两个或门，检测当前到底是否需要给Register置数：

   ```
   Or(a=load, b=reset, out=load0);
   Or(a=load0, b=inc, out=load1);
   ```

   最后用一个Mux16输出即可：

   ```
   Mux16(a=final, b=false, sel=false, out=out);
   ```

   最终结果：

   ![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180124/F65dHBkgee.png)

   Comparison Successfully！！

### 好了，今天这章到这里就结束了，明天进行机器语言的学习

