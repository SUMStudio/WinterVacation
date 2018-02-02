import java.io.*;

public class CodeWriter {
    private BufferedWriter writer;
    private int EQCount = 0;
    private int GTCount = 0;
    private int LTCount = 0;

    CodeWriter(FileWriter fileWriter) {
        writer = new BufferedWriter(fileWriter);
    }

    public void writeArithmetic(String command) throws IOException {
        switch (command) {
            case "add":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("M=M+D\n");// *(sp-1) = *(sp-1)+d
                break;
            case "sub":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *sp
                writer.write("A=A-1\n");
                writer.write("M=M-D\n");// *(sp-1) = *(sp-1)-d
                break;
            case "neg":
                writer.write("@SP\n");
                writer.write("A=M-1\n");
                writer.write("M=-M\n");
                break;
            case "eq":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("D=M-D\n");
                writer.write("M=0\n");  //false 写入
                writer.write("@END_EQ" + EQCount + "\n");
                writer.write("D;JNE\n"); //如果不等于0，直接跳过true写入
                writer.write("@SP\n");// sp--;
                writer.write("A=M-1\n"); //寻找到要修改项
                writer.write("M=-1\n"); //true 写入
                writer.write("(END_EQ" + EQCount++ + ")\n");
                break;
            case "gt":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("D=M-D\n");// d = *(sp-2)-*(sp-1) (x-y)
                writer.write("M=0\n");  //false 写入
                writer.write("@END_GT" + GTCount + "\n");
                writer.write("D;JLE\n"); //如果不大于0，直接跳过true写入
                writer.write("@SP\n");// sp--;
                writer.write("A=M-1\n"); //寻找到要修改项
                writer.write("M=-1\n"); //true 写入
                writer.write("(END_GT" + GTCount++ + ")\n");
                break;
            case "lt":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("D=M-D\n");
                writer.write("M=0\n");  //false 写入
                writer.write("@END_LT" + LTCount + "\n");
                writer.write("D;JGE\n"); //如果不小于0，直接跳过true写入
                writer.write("@SP\n");// sp--;
                writer.write("A=M-1\n"); //寻找到要修改项
                writer.write("M=-1\n"); //true 写入
                writer.write("(END_LT" + LTCount++ + ")\n");
                break;
            case "and":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("M=D&M\n");
                break;
            case "or":
                writer.write("@SP\n");
                writer.write("AM=M-1\n");
                writer.write("D=M\n");// d = *(sp-1)
                writer.write("A=A-1\n");
                writer.write("M=D|M\n");
                break;
            case "not":
                writer.write("@SP\n");
                writer.write("A=M-1\n");
                writer.write("M=!M\n");
                break;

        }
        writer.flush();

    }

    public void writePushPoP(String command, String segement, int index) throws IOException {
        switch (command) {
            case "C_PUSH":
                switch (segement) {
                    case "constant":
                        writer.write("@" + index + "\n");
                        writer.write("D=A\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "local":
                        writer.write("@LCL\n");
                        writer.write("D=M\n");
                        writer.write("@" + index + "\n");
                        writer.write("A=D+A\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "argument":
                        writer.write("@ARG\n");
                        writer.write("D=M\n");
                        writer.write("@" + index + "\n");
                        writer.write("A=D+A\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "this":
                        writer.write("@THIS\n");
                        writer.write("D=M\n");
                        writer.write("@" + index + "\n");
                        writer.write("A=D+A\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "that":
                        writer.write("@THAT\n");
                        writer.write("D=M\n");
                        writer.write("@" + index + "\n");
                        writer.write("A=D+A\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "pointer":
                        writer.write("@" + (3 + index) + "\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "temp":
                        writer.write("@" + (5 + index) + "\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                    case "static":
                        writer.write("@static." + index + "\n");
                        writer.write("D=M\n");
                        writer.write("@SP\n");
                        writer.write("AM=M+1\n");
                        writer.write("A=A-1\n");
                        writer.write("M=D\n");
                        break;
                }
                break;
            case "C_POP":
                switch (segement) {
                    case "local":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@LCL\n");
                        writer.write("A=M\n");
                        for (;index>0;index--){
                            writer.write("A=A+1\n");
                        }
                        writer.write("M=D\n");
                        break;
                    case "argument":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@ARG\n");
                        writer.write("A=M\n");
                        for (;index>0;index--){
                            writer.write("A=A+1\n");
                        }
                        writer.write("M=D\n");
                        break;
                    case "this":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@THIS\n");
                        writer.write("A=M\n");
                        for (;index>0;index--){
                            writer.write("A=A+1\n");
                        }
                        writer.write("M=D\n");
                        break;
                    case "that":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@THAT\n");
                        writer.write("A=M\n");
                        for (;index>0;index--){
                            writer.write("A=A+1\n");
                        }
                        writer.write("M=D\n");
                        break;
                    case "pointer":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@" + (3 + index) + "\n");
                        writer.write("M=D\n");
                        break;
                    case "temp":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@" + (5 + index) + "\n");
                        writer.write("M=D\n");
                        break;
                    case "static":
                        writer.write("@SP\n");
                        writer.write("AM=M-1\n");
                        writer.write("D=M\n");
                        writer.write("@static." + index + "\n");
                        writer.write("M=D\n");
                        break;
                }
                break;
        }
        writer.flush();
    }

}
