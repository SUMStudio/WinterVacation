# Day01 布尔逻辑

《计算机系统要素》中，每一章都安排了需要动手实践的项目，在这里，我会给出一些项目的实现过程和方法。

在进行第一章的项目实现前，我们需要下载本书配套的工具包：

[ Nand2tetris Software Suite](http://www.nand2tetris.org/software/nand2tetris.zip)

工具包内含多个工具，今天我们只需要其中的 Hardware Simulator 硬件模拟器。

官方的工具包都是基于 Java 开发的，因此，不论是 windows、Linux 或是 Mac ，只要配置好 Jre ，工具包都可以执行。

Jre 在这里下载：http://www.oracle.com/technetwork/java/javase/downloads/jre8-downloads-2133155.html

Jre 安装完后，解压之前下载的安装包，进入 tools 文件夹，直接执行 HardwareSimulator.bat 即可

 在本章，我们需要做的是完善 project/01 中的 hdl 文件，各个逻辑门的输入输出接口已经给出，直接补全 PARTS 部分即可。

## 非门 Not gate 实现

注意，我们现在只能使用 Nand 门，其他的逻辑门基于 Nand 门

1与任何逻辑变量与非实现非门

```
CHIP Not {
    IN in;
    OUT out;

    PARTS:
    Nand(a=in, b=true, out=out);
}
```



##与门 AND gate 实现

实现思路： Nand（Nand（a，b），1）

*



## 或门 Or gate 实现

或门即 A+B ，两重长非号即可实现

```
CHIP Or {
    IN a, b;
    OUT out;

    PARTS:
    Not(in=a, out=na);
    Not(in=b, out=nb);
    Nand(a=na, b=nb, out=out);
}
```



## 异或 Xor 实现

a,b 相异 输出1

思路：相异的话，对其中之一取反即相同，总有一种取反取与输出为1

```
CHIP Xor {
    IN a, b;
    OUT out;

    PARTS:
    Not(in=a, out=na);
    And(a=na, b=b, out=o1);
    Not(in=b, out=nb);
    And(a=a, b=nb, out=o2);
    Or(a=o1, b=o2, out=out);
}
```



## 选择器 Mux 实现

```
/** 
 * Multiplexor:
 * out = a if sel == 0
 *       b otherwise
 */
```

二选一数据选择器，当sel为0时，输出a，1时输出b。

思路：输出 And(a,not(sel))+And(b,sel) 貌似即可

逻辑化简一下，应该有更高效的方法

```
CHIP Mux {
    IN a, b, sel;
    OUT out;

    PARTS:
    Not(in=sel, out=nsel);
    And(a=a, b=nsel, out=oa);
    And(a=b, b=sel, out=ob);
    Or(a=oa, b=ob, out=out);
}
```



## 数据分配器 DMux 实现

sel==0时，in分配到a上，反之，in分配到b上

思路：a=Not(sel) and a; b=Not(sel) and b

```
CHIP DMux {
    IN in, sel;
    OUT a, b;

    PARTS:
    Not(in=sel, out=nsel);
    And(a=in, b= nsel, out=a);
    And(a=in, b=sel, out=b);
}
```



## 16位按位与门 16-bit bitwise And 实现

看起来好像很可怕，实际上巨简单

但是，好像得一个一个针脚连？复制粘贴16行？

```
CHIP And16 {
    IN a[16], b[16];
    OUT out[16];

    PARTS:
    And(a=a[0], b=b[0], out=out[0]);
    And(a=a[1], b=b[1], out=out[1]);
    And(a=a[2], b=b[2], out=out[2]);
    And(a=a[3], b=b[3], out=out[3]);
    And(a=a[4], b=b[4], out=out[4]);
    And(a=a[5], b=b[5], out=out[5]);
    And(a=a[6], b=b[6], out=out[6]);
    And(a=a[7], b=b[7], out=out[7]);
    And(a=a[8], b=b[8], out=out[8]);
    And(a=a[9], b=b[9], out=out[9]);
    And(a=a[10], b=b[10], out=out[10]);
    And(a=a[11], b=b[11], out=out[11]);
    And(a=a[12], b=b[12], out=out[12]);
    And(a=a[13], b=b[13], out=out[13]);
    And(a=a[14], b=b[14], out=out[14]);
    And(a=a[15], b=b[15], out=out[15]);
}
```







