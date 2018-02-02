# DAY 13 虚拟机1 下 内存访问命令的实现

昨天，我们使用 Java 语言，编写了 VM 翻译器的堆栈运算命令的翻译指令，今天，我们将剩余的内存访问命令进行实现。

1. **Local** 段处理：

   Local 段的基地址指针在 RAM[1] 处，也就是 LCL 处，对 Local 段的操作共有两种：

   ```
   push local index
   pop local index
   ```

   push 操作是把 local[index] 的数值入栈，pop 操作是把栈顶元素出出栈到 local[index] 。

   入栈用 HACK 语言的实现如下：

   ```
   @LCL
   D=M
   @[index]
   A=D+A
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   ```

   出栈实现如下：(*注意：下面的源码是错误的 !*)

   ```
   @SP
   AM=M-1
   D=M
   @LCL
   D=M
   @[index]
   A=D+A
   M=D
   ```

   用 Java 语言把这些指令写入文件的源码如下：

   ```java
   public void writePushPoP(String command, String segement, int index) throws IOException {
           switch (command){
               case "C_PUSH":
                   switch (segement){
                       case "constant":
                           writer.write("@"+index+"\n");
                           writer.write("D=A\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "local" :
                           writer.write("@LCL\n");
                           writer.write("A=M+" +index+ "\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                   }
               case "C_POP":
                   switch (segement){
                       case "local":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@LCL\n");
                           writer.write("A=M+" +index+"\n");
                           writer.write("M=D\n");
                   }
           }
           writer.flush();
       }
   ```

   同样，argument、this、that、段的操作完全相同，只要修改基地址名称即可。

2. pointer 和 temp 段的实现：

   pointer 的 index 值只能为 0,1 分别对应 this、that，通过修改 pointer 的值，即可实现对 this、that 基地址的修改。我们要做的，就是把 pointer[0] 物理映射到 this 上去：

   push pointer index

   ```
   @3+[index]
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   ```

   pop pointer index

   ```
   @SP
   AM=M-1
   D=M
   @3+[index]
   M=D
   ```

   而 temp 是被直接映射到 RAM[5-12] 上

   push temp index

   ```
   @5+[index]
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   ```

   pop temp index

   ```
   @SP
   AM=M-1
   D=M
   @5+[index]
   M=D
   ```

3. 最后，我们处理 Static 段：

   static 段和之前的实现有些不同，之前的内存段我们都为其分配了连续的内存，通过基地址映射的方法对其进行读写，而 static 段通过汇编语言自己的符号分配方法，，进行地址的映射：

   push static index:

   ```
   @static.[index]
   D=M
   @SP
   AM=M+1
   A=A-1
   M=D
   ```

   pop static index:

   ```
   @SP
   AM=M-1
   D=M
   @static.[index]
   M=D
   ```

4. 第一次测试，测试结果如下

   ![第二部分测试结果1][5]

   果然，不出所料。仔细找一下原因，发现是出栈操作有问题，出栈时，进行基地址 index 偏移的时候调用了 D 寄存器，导致 D 寄存器中保存的出栈结果被覆盖。

   所以，怎么办？我们应该是不能借助额外的 RAM 空间去做中间结果的保存的。。。。

   苦思冥想无果，还得翻出来 Pong.asm 寻找灵感。

   果然，我发现了神奇的一段：

   ![Pong.asm][6]

   woc，就这么暴力地增一？

   好吧好吧

   ```
   @SP
   AM=M-1
   D=M
   @LCL
   A=M
   for(;index>0;index--)
   	A=A+1
   M=D
   ```

   恩，就照这个改吧。

   改了之后。。。还是不对啊。。。再看看。。。最终发现一个很弱智的错误。。。两个 switch 中间忘了加break了。。。。

   ![第二部分测试结果2][7]

   剩余的两个测试也完美正确

   最后，给出 VM 翻译器1 的完整 JAVA 源码：

   *main.java*

   ```java
   import java.io.FileInputStream;
   import java.io.FileWriter;
   import java.io.IOException;

   public class Main {

       public static void main(String[] args) throws IOException {
           String outputFile = args[0].replaceAll(".vm",".asm");
           FileWriter fileWriter = new FileWriter(outputFile);
           FileInputStream fileInputStream = new FileInputStream(args[0]);
           VMParser parser = new VMParser(fileInputStream);
           CodeWriter writer = new CodeWriter(fileWriter);

           while (parser.hasMoreCommands()){
               parser.advance();
               switch (parser.commandType()){
                   case "C_ARITHMETIC":
                       writer.writeArithmetic(parser.arg1());
                       break;
                   case "C_PUSH":
                   case "C_POP":
                       writer.writePushPoP(parser.commandType(),parser.arg1(),parser.arg2());
                       break;
               }
           }
           fileWriter.close();
           fileInputStream.close();
       }
   }

   ```

   *VMParser.java*

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
       public int arg2(){
           return Integer.parseInt(this.nowSplitLine[2]);
       }
   }

   ```

   *CodeWriter.java*

   ```java
   import java.io.*;

   public class CodeWriter {
       private BufferedWriter writer;
       private int EQCount = 0;
       private int GTCount = 0;
       private int LTCount = 0;

       CodeWriter(FileWriter fileWriter) {
           writer = new BufferedWriter(fileWriter);
       }

       public void writeArithmetic(String command) throws IOException {
           switch (command) {
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
               case "eq":
                   writer.write("@SP\n");
                   writer.write("AM=M-1\n");
                   writer.write("D=M\n");// d = *(sp-1)
                   writer.write("A=A-1\n");
                   writer.write("D=M-D\n");
                   writer.write("M=0\n");  //false 写入
                   writer.write("@END_EQ" + EQCount + "\n");
                   writer.write("D;JNE\n"); //如果不等于0，直接跳过true写入
                   writer.write("@SP\n");// sp--;
                   writer.write("A=M-1\n"); //寻找到要修改项
                   writer.write("M=-1\n"); //true 写入
                   writer.write("(END_EQ" + EQCount++ + ")\n");
                   break;
               case "gt":
                   writer.write("@SP\n");
                   writer.write("AM=M-1\n");
                   writer.write("D=M\n");// d = *(sp-1)
                   writer.write("A=A-1\n");
                   writer.write("D=M-D\n");// d = *(sp-2)-*(sp-1) (x-y)
                   writer.write("M=0\n");  //false 写入
                   writer.write("@END_GT" + GTCount + "\n");
                   writer.write("D;JLE\n"); //如果不大于0，直接跳过true写入
                   writer.write("@SP\n");// sp--;
                   writer.write("A=M-1\n"); //寻找到要修改项
                   writer.write("M=-1\n"); //true 写入
                   writer.write("(END_GT" + GTCount++ + ")\n");
                   break;
               case "lt":
                   writer.write("@SP\n");
                   writer.write("AM=M-1\n");
                   writer.write("D=M\n");// d = *(sp-1)
                   writer.write("A=A-1\n");
                   writer.write("D=M-D\n");
                   writer.write("M=0\n");  //false 写入
                   writer.write("@END_LT" + LTCount + "\n");
                   writer.write("D;JGE\n"); //如果不小于0，直接跳过true写入
                   writer.write("@SP\n");// sp--;
                   writer.write("A=M-1\n"); //寻找到要修改项
                   writer.write("M=-1\n"); //true 写入
                   writer.write("(END_LT" + LTCount++ + ")\n");
                   break;
               case "and":
                   writer.write("@SP\n");
                   writer.write("AM=M-1\n");
                   writer.write("D=M\n");// d = *(sp-1)
                   writer.write("A=A-1\n");
                   writer.write("M=D&M\n");
                   break;
               case "or":
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

           }
           writer.flush();

       }

       public void writePushPoP(String command, String segement, int index) throws IOException {
           switch (command) {
               case "C_PUSH":
                   switch (segement) {
                       case "constant":
                           writer.write("@" + index + "\n");
                           writer.write("D=A\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "local":
                           writer.write("@LCL\n");
                           writer.write("D=M\n");
                           writer.write("@" + index + "\n");
                           writer.write("A=D+A\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "argument":
                           writer.write("@ARG\n");
                           writer.write("D=M\n");
                           writer.write("@" + index + "\n");
                           writer.write("A=D+A\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "this":
                           writer.write("@THIS\n");
                           writer.write("D=M\n");
                           writer.write("@" + index + "\n");
                           writer.write("A=D+A\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "that":
                           writer.write("@THAT\n");
                           writer.write("D=M\n");
                           writer.write("@" + index + "\n");
                           writer.write("A=D+A\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "pointer":
                           writer.write("@" + (3 + index) + "\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "temp":
                           writer.write("@" + (5 + index) + "\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                       case "static":
                           writer.write("@static." + index + "\n");
                           writer.write("D=M\n");
                           writer.write("@SP\n");
                           writer.write("AM=M+1\n");
                           writer.write("A=A-1\n");
                           writer.write("M=D\n");
                           break;
                   }
                   break;
               case "C_POP":
                   switch (segement) {
                       case "local":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@LCL\n");
                           writer.write("A=M\n");
                           for (;index>0;index--){
                               writer.write("A=A+1\n");
                           }
                           writer.write("M=D\n");
                           break;
                       case "argument":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@ARG\n");
                           writer.write("A=M\n");
                           for (;index>0;index--){
                               writer.write("A=A+1\n");
                           }
                           writer.write("M=D\n");
                           break;
                       case "this":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@THIS\n");
                           writer.write("A=M\n");
                           for (;index>0;index--){
                               writer.write("A=A+1\n");
                           }
                           writer.write("M=D\n");
                           break;
                       case "that":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@THAT\n");
                           writer.write("A=M\n");
                           for (;index>0;index--){
                               writer.write("A=A+1\n");
                           }
                           writer.write("M=D\n");
                           break;
                       case "pointer":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@" + (3 + index) + "\n");
                           writer.write("M=D\n");
                           break;
                       case "temp":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@" + (5 + index) + "\n");
                           writer.write("M=D\n");
                           break;
                       case "static":
                           writer.write("@SP\n");
                           writer.write("AM=M-1\n");
                           writer.write("D=M\n");
                           writer.write("@static." + index + "\n");
                           writer.write("M=D\n");
                           break;
                   }
                   break;
           }
           writer.flush();
       }

   }
   ```

   ​

   [5]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-2/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517556116889.jpg

[6]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-2/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517556528659.jpg
[7]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-2/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1517558820781.jpg

