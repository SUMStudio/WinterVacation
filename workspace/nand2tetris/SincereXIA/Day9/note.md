# DAY 9 组装计算机

前几天，我们实现了构成一个计算机的所有必须部件：RAM，ROM，CPU

今天，我们把这些部件集成起来，构成我们完整的计算机。

组装的过程就很简单了，只需要把对应的接口接好就行：

```
CHIP Computer {

    IN reset;

    PARTS:
    CPU(inM=inM, instruction=instruction, reset=reset, outM=MemoryIn, writeM=MemoryLoad, addressM=MemoryAddress, pc=ROMAddress);
    ROM32K(address=ROMAddress, out=instruction);
    Memory(in=MemoryIn, load=MemoryLoad, address=MemoryAddress, out=inM);
}
```

上硬件模拟器看看：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/hKmljCaafL.png)

看起来不错，我们看看能不能运行：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/C1144kb5Kj.png)

完美，这证明我们前几天设计的 RAM，CPU 都没有问题

# DAY 9 编译器

编译器，即把汇编语言翻译成二进制代码，编译器的大部分工作很简单，就是全局替换而已。我们先复习一下 HACK 的汇编指令以及他对弈的二进制代码

**A 指令** ：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/19JeDKKh4D.png)

**C 指令：**

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/EH3A6ilKBI.png)

真正比较复杂的是汇编中出现的 Symbol 、 Label 以及 变量。

Symbol 是 HACK 汇编预定义好的，只要做简单的替换即可，汇编表如下：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/lKJ7cG0fhg.png)

而 Label 就比较复杂，因为 Label 是下一行跳转指令要跳转的位置，由于需要实现向下跳转，如果我们不把整个汇编文件读取完毕的话，是无法知道所有的 Label 所代表的内存地址的，因此，在逐行翻译之前，我们必须对整个汇编文件进行一次读取，并给每一条汇编指令编写行号。

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/AAK4jf19eK.png)

其中，A 指令和 C 指令翻译时需要占用一行，Label 指令在二进制代码中不翻译，因此不需要额外的行数，全部读取完后，Label  的下一行 A或C指令所对应的二进制代码行号就是这个 Label 翻译成二进制时所指代的地址。

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/GdCHEiJ0GE.png)

除了预定义 Symbol 和 Label 外，汇编中还有 **自定义 Symbol** 也就是 **变量** 无法被简单替换，在第一次预读取时，我们给所有的 Label 分配了地址，第一次中未被分配的其他单词，就是变量了，变量从第16位开始，依次分配，我们需要进行第二次预读取，才能给变量分配地址。

由于需要进行多次的读取操作，因此我们最好需要封装一个对象替我们把源代码进行处理，处理时，我们需要去掉所有的空格，去掉所有的注释，同时，如果这个对象能替我们判断这一行的指令类型，并提取出关键词，编译工作会顺利很多。

由于编译工作涉及到大量的字符串处理，为了加快开发，我这里使用 JAVA 语言作为编译器的开发语言，同时，JAVA 具有较好的面向对象特性，也能较好的按照教材的思路进行编译器的开发。

高级语言的编写不在本章的讨论范围内，因此在这里直接给出源代码：

*Main.java*

```java
import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

public class Main {
    static private String SRC = "Pong.asm"; //编译文件路径
    public static void main(String[] args) throws IOException {
        System.out.println(System.getProperty("user.dir"));
        FileWriter fo = new FileWriter("out.hack");
        BufferedWriter bfo = new BufferedWriter(fo);
        FileInputStream fs = new FileInputStream(SRC);
        HackParser hackParser = new HackParser(fs);
        SymbolTable symbolTable = new SymbolTable(SRC);
        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            System.out.println("当前行指令：" + hackParser.nowLine);
            if (hackParser.commandType().equals("A_COMMAND")) {
                System.out.println("Symbol: " + hackParser.symbol());
                System.out.println(symbolTable.getAddress(hackParser.symbol()));
                bfo.write(symbolTable.getAddress(hackParser.symbol()) + "\n");
            } else if (hackParser.commandType().equals("C_COMMAND")) {
                bfo.write("111" + Code.comp(hackParser.comp()) + Code.dest(hackParser.dest()) + Code.jump(hackParser.jump()) + "\n");
                System.out.println("111" + Code.comp(hackParser.comp()) + Code.dest(hackParser.dest()) + Code.jump(hackParser.jump()));
            }
        }
        bfo.close();
        fo.close();
    }
}

```

*HackParser.java*

```java
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;

/**
 * Created by SincereXIA on 2018/1/29.
 *
 * @author SincereXIA.
 * @Time 2018/1/29 11:27.
 */
public class HackParser {
    public String nowLine = "";
    private Scanner asmSrc;
    private Boolean hasNext = true;


    HackParser(FileInputStream asmSrc) throws IOException {
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
            s = s.replace(" ", "");
            if (s.isEmpty() || s.charAt(0) == '/') {
                continue;
            }
            if (s.contains("//")) {
                nowLine = s.substring(0, s.indexOf("//"));
            } else nowLine = s;
            hasNext = asmSrc.hasNextLine();
        }
    }

    /**
     * 返回当前命令类型： A_COMMAND, C_COMMAND, L_COMMAND
     *
     * @return
     */
    public String commandType() {

        char typeChar = nowLine.charAt(0);
        if (typeChar == '@') return "A_COMMAND";
        if (typeChar == '(') return "L_COMMAND";
        return "C_COMMAND";
    }

    /**
     * 返回当前A指令符号
     *
     * @return
     */
    public String symbol() {
        return nowLine.substring(1);
    }

    public String Label() {
        return nowLine.substring(nowLine.indexOf('(') + 1, nowLine.indexOf(')'));
    }

    /**
     * 当前指令的 dest 助记符
     *
     * @return
     */
    public String dest() {
        if (!nowLine.contains("=")) {
            return "";
        } else {
            return nowLine.substring(0, nowLine.indexOf("="));
        }
    }

    public String comp() {
        int start;
        if (!nowLine.contains("=")) {
            start = 0;
        } else {
            start = nowLine.indexOf("=") + 1;
        }
        int end;
        if (!nowLine.contains(";")) {
            end = nowLine.length();
        } else {
            end = nowLine.indexOf(";");
        }
        return nowLine.substring(start, end);
    }

    public String jump() {
        if (!nowLine.contains(";")) {
            return "";
        } else {
            return nowLine.substring(nowLine.indexOf(";") + 1);
        }
    }
}

```

*Code.java*

```java
/**
 * Created by SincereXIA on 2018/1/29.
 *
 * @author SincereXIA.
 * @Time 2018/1/29 13:47.
 */
public class Code {
    static public String dest(String code) {
        StringBuilder stringBuilder = new StringBuilder("000");
        if (code.contains("A")) {
            stringBuilder.replace(0, 1, "1");
        }
        if (code.contains("D")) {
            stringBuilder.replace(1, 2, "1");
        }
        if (code.contains("M")) {
            stringBuilder.replace(2, 3, "1");
        }
        return stringBuilder.toString();
    }

    static public String comp(String code) {
        if (code.equals("0")) return "0101010";
        else if (code.equals("1")) return "0111111";
        else if (code.equals("-1")) return "0111010";
        else if (code.equals("D")) return "0001100";
        else if (code.equals("A")) return "0110000";
        else if (code.equals("M")) return "1110000";
        else if (code.equals("!D")) return "0001101";
        else if (code.equals("!A")) return "0110001";
        else if (code.equals("!M")) return "1110001";
        else if (code.equals("-D")) return "0001111";
        else if (code.equals("-A")) return "0110011";
        else if (code.equals("-M")) return "1110011";
        else if (code.equals("D+1")) return "0011111";
        else if (code.equals("A+1")) return "0110111";
        else if (code.equals("M+1")) return "1110111";
        else if (code.equals("D-1")) return "0001110";
        else if (code.equals("A-1")) return "0110010";
        else if (code.equals("M-1")) return "1110010";
        else if (code.equals("D+A")) return "0000010";
        else if (code.equals("D+M")) return "1000010";
        else if (code.equals("D-A")) return "0010011";
        else if (code.equals("D-M")) return "1010011";
        else if (code.equals("A-D")) return "0000111";
        else if (code.equals("M-D")) return "1000111";
        else if (code.equals("D&A")) return "0000000";
        else if (code.equals("D&M")) return "1000000";
        else if (code.equals("D|A")) return "0010101";
        else if (code.equals("D|M")) return "1010101";

        return "error";
    }

    static public String jump(String code) {
        switch (code) {
            case "JGT":
                return "001";
            case "JEQ":
                return "010";
            case "JGE":
                return "011";
            case "JLT":
                return "100";
            case "JNE":
                return "101";
            case "JLE":
                return "110";
            case "JMP":
                return "111";
            default:
                return "000";
        }
    }
}

```

*SymbolTable.java*

```java
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Pattern;

/**
 * Created by SincereXIA on 2018/1/29.
 *
 * @author SincereXIA.
 * @Time 2018/1/29 14:40.
 */
public class SymbolTable {
    private HashMap<String, Integer> symbolTable;
    private HackParser hackParser;
    private int addressNow;
    private String fileName;

    SymbolTable(String fileName) throws IOException {
        FileInputStream fs = new FileInputStream(fileName);
        hackParser = new HackParser(fs);
        symbolTable = new HashMap();
        symbolTable.put("SP", 0);
        symbolTable.put("LCL", 1);
        symbolTable.put("ARG", 2);
        symbolTable.put("THIS", 3);
        symbolTable.put("THAT", 4);
        symbolTable.put("R0", 0);
        symbolTable.put("R1", 1);
        symbolTable.put("R2", 2);
        symbolTable.put("R3", 3);
        symbolTable.put("R4", 4);
        symbolTable.put("R5", 5);
        symbolTable.put("R6", 6);
        symbolTable.put("R7", 7);
        symbolTable.put("R8", 8);
        symbolTable.put("R9", 9);
        symbolTable.put("R10", 10);
        symbolTable.put("R11", 11);
        symbolTable.put("R12", 12);
        symbolTable.put("R13", 13);
        symbolTable.put("R14", 14);
        symbolTable.put("R15", 15);
        symbolTable.put("SCREEN", 16384);
        symbolTable.put("KBD", 24576);

        addressNow = 0;

        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            if (hackParser.commandType().equals("A_COMMAND")) {
                addressNow++;
            } else if (hackParser.commandType().equals("C_COMMAND")) {
                addressNow++;
            } else if (hackParser.commandType().equals("L_COMMAND")) {
                symbolTable.put(hackParser.Label(), addressNow);
            }
        }

        addressNow = 16;
        fs.close();
        fs = new FileInputStream(fileName);
        hackParser = new HackParser(fs);
        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            if (hackParser.commandType().equals("A_COMMAND")) {
                if (!symbolTable.containsKey(hackParser.symbol()) && !isInteger(hackParser.symbol())) {
                    symbolTable.put(hackParser.symbol(), addressNow);
                    addressNow++;
                }
            }
        }
    }

    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }

    public String getAddress(String label) {
        Integer address;
        String string;
        if (symbolTable.containsKey(label)) {
            address = symbolTable.get(label);
        } else {
            address = Integer.valueOf(label);
        }
        string = Integer.toBinaryString(address);
        StringBuilder sb = new StringBuilder(string);
        for (int i = sb.length(); i <= 15; i++) {
            sb.insert(0, '0');
        }
        return sb.toString();
    }
}

```

我编写的编译器共有四个类，执行 Main.java 输出 output.hack，为编译好的二进制代码文件。

用这个编译器编译的 Pong.hack 如下图所示，可以看到，和官方编译器的编译结果完全相同：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/BBJcGB4GeJ.png)

整个汇编代码共 27483 行，是一个用方向键控制挡板，反弹小球的游戏，CPU 模拟器执行代码效果如下：

![mark](http://7xjpym.com1.z0.glb.clouddn.com/blog/180129/I387D5jajh.png)

至此，我们就完成了整个 hack 平台硬件体系的设计与制作，至此，我们的 HACK 计算机有了整套的 RAM、ROM、CPU、输入输出设备，有了一整套汇编指令和汇编编译器，能运行汇编语言编写的小程序，接下来，我们会进行 HACK 平台软件体系的建设，HAPPY CODEING！！



 

