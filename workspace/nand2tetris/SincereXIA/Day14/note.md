# Day14 虚拟机2 程序控制

> If everything seems under control, you're just not going fast enough.

今天我们来完善我们的 VM 虚拟机，昨天我们做的虚拟机能完成基本的数学运算和逻辑操作，还能实现对内存和栈的操作。今天，我们在此基础上更进一步，我们将给 VM 虚拟机加入程序控制流命令，以及函数调用命令。

## 程序控制流命令：

我们通常使用的高级语言，有大量的程序控制流命令，比如 if else，while，for 等等。

而 VM 语言中的程序控制流非常简单，只有以下三种

* `label label` 这条命令声明一个跳转锚点
* `goto label` 执行这条命令无条件跳转到 VM 程序中 `label` 锚点的位置
* `if-goto label` 这条命令同时执行了逻辑判断和跳转的命令，会弹出栈顶元素，当栈顶元素非 0 时，进行 `goto label`跳转

其实，VM 程序控制流命令在 Hack 平台上是非常好实现的，因为 HACK 机器语言本身也使用着类似 label 跳转的机制。

### 程序控制流命令的实现：

1. **label** 命令的实现：

   在实现这些命令之前，我们需要完善一下我们的 Parser 模块，能让其对我们的程序控制流命令进行识别：

   ```java
   /**
        * 返回当前命令类型： C_ARITHMETIC, C_PUSH, C_POP, C_LABEL, C_GOTO, C_IF
        *
        * @return commandType
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
               case "label":
                   return "C_LABEL";
               case "goto":
                   return "C_GOTO";
               case "if-goto":
                   return "C_IF";
           }
           return "error";
       }
   ```

   同时，为了实现以后的多函数编译，CodeWriter 的初始化函数需要修改，我们需要传入 functionName 参数，使得 CodeWriter 能得知自己正在编译哪个函数，保证编译中不会出现标签重名的情况

   ![构造函数加入 functionName][1]

   然后我们实现 label 命令，非常简单（10行以下的代码我还是比较有信心的）

   ```java
   public void writeLabel(String label) throws IOException {
           writer.write("("+functionName+"$"+label+")\n");
       }
   ```

   生成的 Hack 跳转命令的格式是 `(functionName$label)` 这是 VM 标准化实现所规定的，在 164 页。

2. **goto** 指令的实现

   goto 指令也非常简单，只要调用 Hack 语言的 JMP 无条件跳转命令就好

   goto label

   ```
   @functionName$label
   0;JMP
   ```

   `0；JMP` 是 Hack 机器语言的标准无条件跳转命令，我们让 ALU 计算 0 ，这是一个没有意义的计算，然后执行 JMP 无条件跳转即可

   ```java
   public void writeGoto(String label) throws IOException {
           writer.write("@"+functionName+"$"+label+"\n");
           writer.write("0;JMP\n");
       }
   ```

3. **if-goto 指令的实现**

   这条指令相对前两条来说，稍显复杂，我们得先取出来栈顶元素，然后对该元素进行判断，如果非零，则执行跳转

   if-goto label

   ```
   @SP
   AM=M-1
   D=M
   @functionName$label
   D;JNE
   ```

   这就实现了栈顶的非零跳转

   ```java
   public void writeIf(String label) throws IOException {
           writer.write("@SP\n");
           writer.write("AM=M-1\n");
           writer.write("D=M\n");
           writer.write("@" + functionName +"$"+label+"\n");
           writer.write("D;JNE\n");
       }
   ```

   ​