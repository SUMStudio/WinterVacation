# Day 17 整目录调试 2

## 困扰了我一天的 Bug 终于解决了

这绝对是我调过的最难受的代码，本身 VM 翻译出来的汇编语言就看不懂，官方的 CPU 模拟器还会去掉所有的注释，把所有的 LCL、SP、ARG 之类的变量名全部替换成数字，进一步降低可读性，最难受的是，还会自动去掉所有的标签，导致行号完全和生成的 asm 对不上。

为了解决这个问题，我还写了一个给生成的 asm 加上行号的 Java 程序，会忽视所有的标签以及注释：

```java
import java.io.*;
import java.util.Scanner;

public class Main {
    public static void main(String args[]) throws IOException {
        int lineNum = 0;
        FileReader  fileReader = new FileReader(args[0]);
        Scanner scanner = new Scanner(fileReader);
        FileWriter fileWriter = new FileWriter("line.asm");
        while (scanner.hasNext()){
            String newLine = scanner.nextLine();
            newLine = newLine.trim();
            if (!newLine.equals("")){
                if (!(newLine.charAt(0)=='/')&&!(newLine.charAt(0)=='(')){
                    newLine = newLine+"            \t"+lineNum++;
                }
            }
            fileWriter.write(newLine+"\n");
        }
        fileWriter.flush();
    }
}
```

生成了带行号的 asm 之后，终于调试轻松了一些，但是还是找不出哪里出错，看着满屏幕的汇编，一行一行单步调试，没几行就没耐心了。好在官方提供了一个专门用来 Debug 的样例：NestedCall，这个样例自带一个 Html 文档，详细说明了各个关键指令前后的栈空间的数据值，通过比较可以比较方便的判断出自己到底哪一步出错。

但要注意的是，由于引导代码（bootstrap code）的不同，我们的 RAM[257-260]的值有些可能和 HTML 中的不同，不用在这上面纠结

![ram][9]

最终，我发现是我的 return 实现的有问题，重置返回值的时候，如果函数本身是 0 参数的，会覆盖掉返回地址，导致无法正常返回到调用的地方。

还有一个问题，局部变量初始化为 0 的时候，少写了一个 A = A-1 导致有一个局部变量没有被初始化

最后一个问题，Static 变量，应该是按文件进行分配的，同一个文件中的 Static[index] 是同一个变量，Static不是按函数分配的



在解决了这些问题之后，VM 虚拟机完美运行

![完美运行][10]

[9]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518013471214.jpg
[10]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518013471217.jpg