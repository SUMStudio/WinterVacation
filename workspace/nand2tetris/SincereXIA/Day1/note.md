## 与门 AND gate 实现

与门是我们来实现的第一个门

我们现在可以使用 Nand 门进行实现

Nand 与非，实现思路： Nand（Nand（a，b），1）

*1与任何逻辑变量与非实现非门*



## 或门 Or gate 实现

或门即 A+B ，两重长非号即可实现，实现Or前，不妨先实现Not



## 非门 Not gate 实现

1与任何逻辑变量与非实现非门



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

逻辑代数化简一下，应该有更高效的方法



## 数据分配器 DMux 实现

sel==0时，in分配到a上，反之，in分配到b上

思路：a=Not(sel) and a; b=Not(sel) and b



## 16位按位与门 16-bit bitwise And 实现

看起来好像很可怕，实际上巨简单

但是，好像得一个一个针脚连？复制粘贴16行？



## 异或 Xor 实现

a,b 相异 输出1

思路：相异的话，对其中之一取反即相同，总有一种取反取与输出为1



