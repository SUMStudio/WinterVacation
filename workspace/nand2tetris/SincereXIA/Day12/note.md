# day12 虚拟机 1

虚拟机 Virtual Machine 将实体的计算机进行进一步封装，运行一种介于高级语言和汇编语言之间的 *VM指令*

VM语言包括四种类型的命令：

- 算术命令
- 内存访问
- 程序流程控制
- 子程序调用

本章我们要构建的**VM翻译器**能将前两种VM指令翻译成 Hack 机器命令。

在编写VM翻译器前，我们需要对 VM 指令进行学习

1. VM 指令概述：

   VM 语言运行在 VM 虚拟机上，VM 虚拟机是一个堆栈机，堆栈机根据指令，将需要操作的数据在堆栈上进行操作，并将计算结果从堆栈中弹出到内存单元，或是从内存单元中读取数据到堆栈，神奇的是，任何数学或逻辑表达式，都能转化为对堆栈的简单操作。

2. VM 内存段映射：

  高级语言的特性之一，就是支持变量，比如我们声明两个变量：

  ```
  int x,y
  ```

  那么这两个变量就有了他们独特的逻辑意义，并且这两个变量相互之间不受影响，比如我修改了 x 的值， y 的值不会发生改变。

  同样，为了让我们的 VM 虚拟机支持高级语言的变量特性，我们必须想办法在高级语言-> VM 指令的翻译过程中，将变量的状态进行保存，因此，vm 虚拟机引入了内存段的概念。

  VM 虚拟机共有 8 个内存段，其各自的含义在书上有表示，这里不在赘述。

  这 8 个内存段，每一个都相当于一个独立的内存空间，并且可以用下标进行随机访问。这 8 个内存空间，和栈空间，一同构成了 VM 虚拟机所有的内存区间，stack 可以同样地对这些空间上任意一个元素进行操作

  ​	![stack和其他内存段之间的关系][2]

  VM 作为一个虚拟机，其拥有自己虚拟的内存结构，而 VM 虚拟机若想在 HACK 平台上实现，就必须将这些虚拟的内存在 HACK 实体内存上进行映射。出于效率的考虑，我们采用指针法，将每一个内存段进行映射。

  ![ VM 内存段映射][1]

  上图是 HACK 虚拟机的真实内存。其中，RAM[0] - RAM[4] 存放的全部都是地址指针 ，分别是：栈顶、local、argument、this、that、段的基地址。

  temp 段映射在 RAM[5] - RAM[12] 上，而 static 段使用汇编自己的分配方式进行内存的连续分配。


## VM 翻译器 构建

由于 VM 翻译器涉及到大量的字符串处理操作，因此我们选择 JAVA 语言来简化开发流程。

1. 首先我们构建 Parser 类，该类用于处理读入的原始文件，去除多余的空格和注释，并对每一条指令进行分析和拆分。这个类和之前汇编编译器的 Parser 类十分类似，因此，很多代码可以复用。Parser 类如下：

   *VMparser.java* :

   ```java
   import java.io.FileInputStream;
   import java.io.IOException;
   import java.util.Scanner;

   /**
    * Created by 张俊华 on 2018/1/29.
    *
    * @author 张俊华.
    * @Time 2018/1/29 11:27.
    */
   public class VMParser {
       public String nowLine = "";
       private Scanner asmSrc;
       private Boolean hasNext = true;
       private String[] nowSplitLine;


       VMParser(FileInputStream asmSrc) throws IOException {
           this.asmSrc = new Scanner(asmSrc);
           nowLine = "";
           hasNext = true;
       }

       /**
        * 输入流是否还有更多命令
        *
        * @return
        */
       public boolean hasMoreCommands() {
           return hasNext;
       }

       /**
        * 从输入中读取下一条命令
        */
       public void advance() {
           nowLine = "";
           while (nowLine.equals("") && asmSrc.hasNextLine()) {
               String s;
               s = asmSrc.nextLine();
               s = s.trim();
               if (s.isEmpty() || s.charAt(0) == '/') {
                   continue; //跳过注释
               }
               if (s.contains("//")) {
                   nowLine = s.substring(0, s.indexOf("//")); //去除行内注释
               } else nowLine = s;
               nowSplitLine = nowLine.split(" "); //关键词分割
               hasNext = asmSrc.hasNextLine();
           }
       }

       /**
        * 返回当前命令类型： C_ARITHMETIC, C_PUSH, C_POP
        *
        * @return
        */
       public String commandType() {
           switch (nowSplitLine[0]){
               case "push":
                   return "C_PUSH";
               case "pop":
                   return "C_POP";
               case "add":
               case "sub":
               case "neg":
               case "eq":
               case "gt":
               case "lt":
               case "and":
               case "or":
               case "not":
                   return "C_ARITHMETIC";
           }
           return "error";
       }

       /**
        * 返回当前命令的第一个参数，若当前命令类型为 C_ARITHMETIC ，则返回命令本身
        *
        * @return commend_arg2
        */
       public String arg1() {
           if (this.commandType().equals("C_ARITHMETIC")){
               return this.nowSplitLine[0];
           }else {
               return this.nowSplitLine[1];
           }
       }

       /**
        * 返回当前命令的第二个参数
        *
        * @return commend_arg2
        */
       public String arg2(){
           return this.nowSplitLine[2];
       }
   }

   ```

2. 接下来，我们进行最核心的 *CodeWriter* 类的构建，将 VM 命令翻译成 Hack 汇编代码。

   我们首先实现 VM 语言的九个堆栈运算

   * 加法与减法

     加减法的翻译比较简单，思路：先获取当前栈顶元素，复制到 D 寄存器，弹栈，现在栈顶元素加/减 D 寄存器即可，具体指令如下：

     ```java
     switch (command){
                case "add":
                     writer.write("@SP\n");
                     writer.write("A=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("@SP\n");
                     writer.write("M=M-1\n");// sp--;
                     writer.write("A=A-1\n");
                     writer.write("M=M+D\n");// *(sp-1) = *(sp-1)+d
                     break;
                 case "sub":
                     writer.write("@SP\n");
                     writer.write("A=M-1\n");
                     writer.write("D=M\n");// d = *sp
                     writer.write("@SP\n");
                     writer.write("M=M-1\n");// sp--;
                     writer.write("A=A-1\n");
                     writer.write("M=M-D\n");// *(sp-1) = *(sp-1)-d
                     break;
     ```

     其实，这个可以简化一下，同样，负数操作也很简单。

     ```java
     			case "add":
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("M=M+D\n");// *(sp-1) = *(sp-1)+d
                     break;
                 case "sub":
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *sp
                     writer.write("A=A-1\n");
                     writer.write("M=M-D\n");// *(sp-1) = *(sp-1)-d
                     break;
     			case "neg":
                     writer.write("@SP\n");
                     writer.write("A=M-1\n");
                     writer.write("M=-M\n");
                     break;
     ```

   * 坑爹的来了——**逻辑判断! eq、gt、lt**

     这些逻辑判断我想了很久，由于 HACK CPU 只有计算和跳转指令，我一开始想的是用跳转去完成，但是，我想，跳转得知道要跳的行号啊，我想了想好像不行。。。于是就上了一条歧路，妄图通过纯数学计算来实现 true 和 false 的写入（当然，这是绝对不可能的！！）

     后来，走投无路之际，我想到之前的 Pong 程序事由官方的 VM 翻译器生成的，于是，我就去 Pong.asm 中找找灵感！果然我看到了官方的逻辑判断实现方法

     ​	**——用标签跳转啊**

     woc，我怎么没想到。。。老了老了

     但是，用标签跳转需要解决一个问题，那就是如果程序中出现了多个同样的逻辑判断，那么就会生成多个相同的标签，这是不可行的，解决办法就是内置一个计数器，记录这是第几次调用这条指令了

     ```java
     case "eq":
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("D=M-D\n");
                     writer.write("M=0\n");  //false 写入
                     writer.write("@END_EQ"+EQCount+"\n");
                     writer.write("D;JNE\n"); //如果不等于0，直接跳过true写入
                     writer.write("@SP\n");// sp--;
                     writer.write("A=M-1\n"); //寻找到要修改项
                     writer.write("M=-1\n"); //true 写入
                     writer.write("(END_EQ"+EQCount+++")\n");
                     break;
     ```

     我们写好了相等判断，那么另外两个逻辑就非常简单了，只要修改 HACK 指令的跳转标签即可：

     ```java
     case "gt":
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("D=M-D\n");// d = *(sp-2)-*(sp-1) (x-y)
                     writer.write("M=0\n");  //false 写入
                     writer.write("@END_GT"+GTCount+"\n");
                     writer.write("D;JLE\n"); //如果不大于0，直接跳过true写入
                     writer.write("@SP\n");// sp--;
                     writer.write("A=M-1\n"); //寻找到要修改项
                     writer.write("M=-1\n"); //true 写入
                     writer.write("(END_GT"+GTCount+++")\n");
                     break;
                 case "lt" :
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("D=M-D\n");
                     writer.write("M=0\n");  //false 写入
                     writer.write("@END_LT"+LTCount+"\n");
                     writer.write("D;JGE\n"); //如果不小于0，直接跳过true写入
                     writer.write("@SP\n");// sp--;
                     writer.write("A=M-1\n"); //寻找到要修改项
                     writer.write("M=-1\n"); //true 写入
                     writer.write("(END_LT"+LTCount+++")\n");
                     break;
     ```

   * 接下来，是与或非操作，也非常简单：

     ```java
                 case "and" :
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("M=D&M\n");
                     break;
                 case "or" :
                     writer.write("@SP\n");
                     writer.write("AM=M-1\n");
                     writer.write("D=M\n");// d = *(sp-1)
                     writer.write("A=A-1\n");
                     writer.write("M=D|M\n");
                     break;
                 case "not":
                     writer.write("@SP\n");
                     writer.write("A=M-1\n");
                     writer.write("M=!M\n");
                     break;
     ```

   * 最后，为了我们能够进行第一次测试，我们需要完成 push constant x 命令，即把一个常数入栈，对应的机器语言代码如下：

     ```java
     public void writePushPoP(String command, String segement, int index) throws IOException {
             switch (command){
                 case "C_PUSH":
                     switch (segement){
                         case "static":
                             writer.write("@SP\n");
                             writer.write("A=M\n");
                             writer.write("M="+index+"\n");
                     }
             }
         }
     ```

     ​	![第一部分测试结果][3]

     执行第二个栈的运算和逻辑操作：

     ![第一部分测试结果2][4]

[1]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-1/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517460021443.jpg
[2]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-1/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517462316540.jpg
[3]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-1/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517488596345.jpg
[4]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-1/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517489108387.jpg