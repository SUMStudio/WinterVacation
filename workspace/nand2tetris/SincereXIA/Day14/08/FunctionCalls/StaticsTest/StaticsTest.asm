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


//push constant 6
@6
D=A
@SP
AM=M+1
A=A-1
M=D


//push constant 8
@8
D=A
@SP
AM=M+1
A=A-1
M=D


//call Class1.set 2
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
@2
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
@Class1.set
0;JMP
//goto f
(return-addressSys.init0)


//pop temp 0 
@SP
AM=M-1
D=M
@5
M=D


//push constant 23
@23
D=A
@SP
AM=M+1
A=A-1
M=D


//push constant 15
@15
D=A
@SP
AM=M+1
A=A-1
M=D


//call Class2.set 2
@return-addressSys.init1
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
@2
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
@Class2.set
0;JMP
//goto f
(return-addressSys.init1)


//pop temp 0 
@SP
AM=M-1
D=M
@5
M=D


//call Class1.get 0
@return-addressSys.init2
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
@Class1.get
0;JMP
//goto f
(return-addressSys.init2)


//call Class2.get 0
@return-addressSys.init3
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
@Class2.get
0;JMP
//goto f
(return-addressSys.init3)


//label WHILE
(Sys.init$WHILE)


//goto WHILE
@Sys.init$WHILE
0;JMP


////Class2.vm


//function Class2.set 0
(Class2.set)


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


//pop static 0
@SP
AM=M-1
D=M
@static.Class2.vm.0
M=D


//push argument 1
@ARG
D=M
@1
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//pop static 1
@SP
AM=M-1
D=M
@static.Class2.vm.1
M=D


//push constant 0
@0
D=A
@SP
AM=M+1
A=A-1
M=D


//return
@LCL
D=M
@FRAME
M=D
@5
A=D-A
D=M
@RET
M=D
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
@FRAME
D=M
@4
A=D-A
D=M
@LCL
M=D
//恢复LCL
@RET
A=M
0;JMP


//function Class2.get 0
(Class2.get)


//push static 0
@static.Class2.vm.0
D=M
@SP
AM=M+1
A=A-1
M=D


//push static 1
@static.Class2.vm.1
D=M
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


//return
@LCL
D=M
@FRAME
M=D
@5
A=D-A
D=M
@RET
M=D
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
@FRAME
D=M
@4
A=D-A
D=M
@LCL
M=D
//恢复LCL
@RET
A=M
0;JMP


////Class1.vm


//function Class1.set 0
(Class1.set)


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


//pop static 0
@SP
AM=M-1
D=M
@static.Class1.vm.0
M=D


//push argument 1
@ARG
D=M
@1
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//pop static 1
@SP
AM=M-1
D=M
@static.Class1.vm.1
M=D


//push constant 0
@0
D=A
@SP
AM=M+1
A=A-1
M=D


//return
@LCL
D=M
@FRAME
M=D
@5
A=D-A
D=M
@RET
M=D
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
@FRAME
D=M
@4
A=D-A
D=M
@LCL
M=D
//恢复LCL
@RET
A=M
0;JMP


//function Class1.get 0
(Class1.get)


//push static 0
@static.Class1.vm.0
D=M
@SP
AM=M+1
A=A-1
M=D


//push static 1
@static.Class1.vm.1
D=M
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


//return
@LCL
D=M
@FRAME
M=D
@5
A=D-A
D=M
@RET
M=D
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
@FRAME
D=M
@4
A=D-A
D=M
@LCL
M=D
//恢复LCL
@RET
A=M
0;JMP
