import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;

/**
 * Created by 张俊华 on 2018/1/29.
 *
 * @author 张俊华.
 * @Time 2018/1/29 11:27.
 */
public class VMParser {
    public String nowLine = "";
    private Scanner asmSrc;
    private Boolean hasNext = true;
    private String[] nowSplitLine;


    VMParser(FileInputStream asmSrc) throws IOException {
        this.asmSrc = new Scanner(asmSrc);
        nowLine = "";
        hasNext = true;
    }

    /**
     * 输入流是否还有更多命令
     *
     * @return
     */
    public boolean hasMoreCommands() {
        return hasNext;
    }

    /**
     * 从输入中读取下一条命令
     */
    public void advance() {
        nowLine = "";
        while (nowLine.equals("") && asmSrc.hasNextLine()) {
            String s;
            s = asmSrc.nextLine();
            s = s.trim();
            if (s.isEmpty() || s.charAt(0) == '/') {
                continue; //跳过注释
            }
            if (s.contains("//")) {
                nowLine = s.substring(0, s.indexOf("//")); //去除行内注释
            } else nowLine = s;
            nowSplitLine = nowLine.split(" "); //关键词分割
            hasNext = asmSrc.hasNextLine();
        }
    }

    /**
     * 返回当前命令类型： C_ARITHMETIC, C_PUSH, C_POP
     *
     * @return
     */
    public String commandType() {
        switch (nowSplitLine[0]){
            case "push":
                return "C_PUSH";
            case "pop":
                return "C_POP";
            case "add":
            case "sub":
            case "neg":
            case "eq":
            case "gt":
            case "lt":
            case "and":
            case "or":
            case "not":
                return "C_ARITHMETIC";
        }
        return "error";
    }

    /**
     * 返回当前命令的第一个参数，若当前命令类型为 C_ARITHMETIC ，则返回命令本身
     *
     * @return commend_arg2
     */
    public String arg1() {
        if (this.commandType().equals("C_ARITHMETIC")){
            return this.nowSplitLine[0];
        }else {
            return this.nowSplitLine[1];
        }
    }

    /**
     * 返回当前命令的第二个参数
     *
     * @return commend_arg2
     */
    public int arg2(){
        return Integer.parseInt(this.nowSplitLine[2]);
    }
}
