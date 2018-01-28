// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Mult.asm

// Multiplies R0 and R1 and stores the result in R2.
// (R0, R1, R2 refer to RAM[0], RAM[1], and RAM[2], respectively.)

// Put your code here.

@0
D=A
@R2
M=D //R2清零
(WHILE)
@R1
MD=M-1 //计数位减一
@END
D;JLT  //处理被乘数为0的情况
@R0
D=M    
@R2
M=D+M  //结果位累加
@WHILE
D;JGT  //跳转执行下一次累加
@END
0;JMP  //程序结束