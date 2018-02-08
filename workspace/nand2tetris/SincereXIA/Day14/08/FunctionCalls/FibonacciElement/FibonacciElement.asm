@256
D=A
@SP
M=D
@return-addressCALL0
D=A
@SP
AM=M+1
A=A-1
M=D
//push return-address
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
//push LCL
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
//push ARG
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
//push THIS
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
//push THAT
@SP
D=M
@0
D=D-A
@5
D=D-A
@ARG
M=D
//ARG=SP-n-5
@SP
D=M
@LCL
M=D
//LCL=SP
@Sys.init
0;JMP
//goto f
(return-addressCALL0)


////Sys.vm


//function Sys.init 0
(Sys.init)


//push constant 4
@4
D=A
@SP
AM=M+1
A=A-1
M=D


//call Main.fibonacci 1   
@return-addressSys.init0
D=A
@SP
AM=M+1
A=A-1
M=D
//push return-address
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
//push LCL
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
//push ARG
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
//push THIS
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
//push THAT
@SP
D=M
@1
D=D-A
@5
D=D-A
@ARG
M=D
//ARG=SP-n-5
@SP
D=M
@LCL
M=D
//LCL=SP
@Main.fibonacci
0;JMP
//goto f
(return-addressSys.init0)


//label WHILE
(Sys.init$WHILE)


//goto WHILE              
@Sys.init$WHILE
0;JMP


////Main.vm


//function Main.fibonacci 0
(Main.fibonacci)


//push argument 0
@ARG
D=M
@0
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push constant 2
@2
D=A
@SP
AM=M+1
A=A-1
M=D


//lt                     
@SP
AM=M-1
D=M
A=A-1
D=M-D
M=0
@END_LT0
D;JGE
@SP
A=M-1
M=-1
(END_LT0)


//if-goto IF_TRUE
@SP
AM=M-1
D=M
@Main.fibonacci$IF_TRUE
D;JNE


//goto IF_FALSE
@Main.fibonacci$IF_FALSE
0;JMP


//label IF_TRUE          
(Main.fibonacci$IF_TRUE)


//push argument 0
@ARG
D=M
@0
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//return
@SP
AM=M-1
D=M
@ARG
A=M
M=D
//重置调用者的返回值
@ARG
D=M
@SP
M=D+1
//恢复调用者的 SP
@LCL
D=M
@1
A=D-A
D=M
@THAT
M=D
//恢复THAT
@LCL
D=M
@2
A=D-A
D=M
@THIS
M=D
//恢复THIS
@LCL
D=M
@3
A=D-A
D=M
@ARG
M=D
//恢复ARG
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


//label IF_FALSE         
(Main.fibonacci$IF_FALSE)


//push argument 0
@ARG
D=M
@0
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push constant 2
@2
D=A
@SP
AM=M+1
A=A-1
M=D


//sub
@SP
AM=M-1
D=M
A=A-1
M=M-D


//call Main.fibonacci 1  
@return-addressMain.fibonacci0
D=A
@SP
AM=M+1
A=A-1
M=D
//push return-address
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
//push LCL
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
//push ARG
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
//push THIS
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
//push THAT
@SP
D=M
@1
D=D-A
@5
D=D-A
@ARG
M=D
//ARG=SP-n-5
@SP
D=M
@LCL
M=D
//LCL=SP
@Main.fibonacci
0;JMP
//goto f
(return-addressMain.fibonacci0)


//push argument 0
@ARG
D=M
@0
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push constant 1
@1
D=A
@SP
AM=M+1
A=A-1
M=D


//sub
@SP
AM=M-1
D=M
A=A-1
M=M-D


//call Main.fibonacci 1  
@return-addressMain.fibonacci1
D=A
@SP
AM=M+1
A=A-1
M=D
//push return-address
@LCL
D=M
@SP
AM=M+1
A=A-1
M=D
//push LCL
@ARG
D=M
@SP
AM=M+1
A=A-1
M=D
//push ARG
@THIS
D=M
@SP
AM=M+1
A=A-1
M=D
//push THIS
@THAT
D=M
@SP
AM=M+1
A=A-1
M=D
//push THAT
@SP
D=M
@1
D=D-A
@5
D=D-A
@ARG
M=D
//ARG=SP-n-5
@SP
D=M
@LCL
M=D
//LCL=SP
@Main.fibonacci
0;JMP
//goto f
(return-addressMain.fibonacci1)


//add                    
@SP
AM=M-1
D=M
A=A-1
M=M+D


//return
@SP
AM=M-1
D=M
@ARG
A=M
M=D
//重置调用者的返回值
@ARG
D=M
@SP
M=D+1
//恢复调用者的 SP
@LCL
D=M
@1
A=D-A
D=M
@THAT
M=D
//恢复THAT
@LCL
D=M
@2
A=D-A
D=M
@THIS
M=D
//恢复THIS
@LCL
D=M
@3
A=D-A
D=M
@ARG
M=D
//恢复ARG
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
