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


//push constant 4000	
@4000
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 0
@SP
AM=M-1
D=M
@3
M=D


//push constant 5000
@5000
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 1
@SP
AM=M-1
D=M
@4
M=D


//call Sys.main 0
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
@Sys.main
0;JMP
//goto f
(return-addressSys.init0)


//pop temp 1
@SP
AM=M-1
D=M
@6
M=D


//label LOOP
(Sys.init$LOOP)


//goto LOOP
@Sys.init$LOOP
0;JMP


//function Sys.main 5
(Sys.main)
@SP
AM=M+1
A=A-1
M=0
@SP
AM=M+1
A=A-1
M=0
@SP
AM=M+1
A=A-1
M=0
@SP
AM=M+1
A=A-1
M=0
@SP
AM=M+1
A=A-1
M=0


//push constant 4001
@4001
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 0
@SP
AM=M-1
D=M
@3
M=D


//push constant 5001
@5001
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 1
@SP
AM=M-1
D=M
@4
M=D


//push constant 200
@200
D=A
@SP
AM=M+1
A=A-1
M=D


//pop local 1
@SP
AM=M-1
D=M
@LCL
A=M
A=A+1
M=D


//push constant 40
@40
D=A
@SP
AM=M+1
A=A-1
M=D


//pop local 2
@SP
AM=M-1
D=M
@LCL
A=M
A=A+1
A=A+1
M=D


//push constant 6
@6
D=A
@SP
AM=M+1
A=A-1
M=D


//pop local 3
@SP
AM=M-1
D=M
@LCL
A=M
A=A+1
A=A+1
A=A+1
M=D


//push constant 123
@123
D=A
@SP
AM=M+1
A=A-1
M=D


//call Sys.add12 1
@return-addressSys.main1
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
@Sys.add12
0;JMP
//goto f
(return-addressSys.main1)


//pop temp 0
@SP
AM=M-1
D=M
@5
M=D


//push local 0
@LCL
D=M
@0
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push local 1
@LCL
D=M
@1
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push local 2
@LCL
D=M
@2
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push local 3
@LCL
D=M
@3
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//push local 4
@LCL
D=M
@4
A=D+A
D=M
@SP
AM=M+1
A=A-1
M=D


//add
@SP
AM=M-1
D=M
A=A-1
M=M+D


//add
@SP
AM=M-1
D=M
A=A-1
M=M+D


//add
@SP
AM=M-1
D=M
A=A-1
M=M+D


//add
@SP
AM=M-1
D=M
A=A-1
M=M+D


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


//function Sys.add12 0
(Sys.add12)


//push constant 4002
@4002
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 0
@SP
AM=M-1
D=M
@3
M=D


//push constant 5002
@5002
D=A
@SP
AM=M+1
A=A-1
M=D


//pop pointer 1
@SP
AM=M-1
D=M
@4
M=D


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


//push constant 12
@12
D=A
@SP
AM=M+1
A=A-1
M=D


//add
@SP
AM=M-1
D=M
A=A-1
M=M+D


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
