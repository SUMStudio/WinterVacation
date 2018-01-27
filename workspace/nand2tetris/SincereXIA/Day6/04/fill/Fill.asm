// This file is part of www.nand2tetris.org
// and the book "The Elements of Computing Systems"
// by Nisan and Schocken, MIT Press.
// File name: projects/04/Fill.asm

// Runs an infinite loop that listens to the keyboard input.
// When a key is pressed (any key), the program blackens the screen,
// i.e. writes "black" in every pixel;
// the screen should remain fully black as long as the key is pressed. 
// When no key is pressed, the program clears the screen, i.e. writes
// "white" in every pixel;
// the screen should remain fully clear as long as no key is pressed.

// Put your code here.
@SCREEN
D=A
@R0
M=D //初始化该处理的像素位
(FOREVER)
@KBD
D=M //从键盘读取输入
@FILL
D;JNE //若有输入，跳过清零，点亮像素
@SCREEN
D=A
@R0
D=M-D
@FOREVER
D;JLT //清零出界则取消清零
@R0
A=M
M=0 //对应像素点清屏
@R0
M=M-1
@FOREVER
0;JMP //单次清屏结束，跳转检测输入
(FILL)
@24576
D=A
@R0
D=D-M
@FOREVER
D;JLE //点亮出界则取消点亮
@R0
A=M
M=-1 //对应像素点亮
@R0
M=M+1
@FOREVER
0;JMP