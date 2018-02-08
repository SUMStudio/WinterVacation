## 虚拟机２　调试

码代码一时爽、Debug 火葬场

我们首先可以跑一下 SimpleFunction 测试一下我们的 function 和 return 命令有没有问题

![error][3]

果然，看看是哪里出错了

![local][4]

是这样，恢复完 locacl 之后，我们就丢失了 local 的基地址，就无法再找到返回地址了。

解决的办法是引入一个临时变量，存储保存在 LCL 段的地址。

```
@LCL
D=M
@FRAME
M=D
@4
A=D-A
D=M
@LCL
M=D
//恢复LCL
@FRAME
D=M
@5
A=D-A
A=M
0;JMP
```

进行了修改之后，的确是可以跑完了，但是，现在 SP 的指针，还有返回的栈顶元素都有问题，我们继续进行一些修改：

![返回值的问题][6]
![恢复 SP 的问题][7]

修改之后：

![第一次调试成功][8]

## 整目录 VM 文件的编译

接下来，我们来实现 VM 整目录的编译：

我们在进行翻译时，必须要加入初始化代码

```
@256
D=A
@SP
M=D
call Sys.init
```

[1]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878289.jpg
[2]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878308.jpg
[3]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878292.jpg
[4]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878292.jpg
[5]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878292.jpg
[6]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878293.jpg
[7]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878303.jpg
[8]: http://7xjpym.com1.z0.glb.clouddn.com/blog/2018-2-7/2018-2-1%E6%9C%AA%E5%91%BD%E5%90%8D%E6%96%87%E4%BB%B6/1518009878309.jpg