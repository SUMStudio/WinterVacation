import java.io.FileInputStream;
import java.io.IOException;
import java.util.Scanner;

/**
 * Created by 张俊华 on 2018/1/29.
 *
 * @author 张俊华.
 * @Time 2018/1/29 11:27.
 */
public class HackParser {
    public String nowLine = "";
    private Scanner asmSrc;
    private Boolean hasNext = true;


    HackParser(FileInputStream asmSrc) throws IOException {
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
            s = s.replace(" ", "");
            if (s.isEmpty() || s.charAt(0) == '/') {
                continue;
            }
            if (s.contains("//")) {
                nowLine = s.substring(0, s.indexOf("//"));
            } else nowLine = s;
            hasNext = asmSrc.hasNextLine();
        }
    }

    /**
     * 返回当前命令类型： A_COMMAND, C_COMMAND, L_COMMAND
     *
     * @return
     */
    public String commandType() {

        char typeChar = nowLine.charAt(0);
        if (typeChar == '@') return "A_COMMAND";
        if (typeChar == '(') return "L_COMMAND";
        return "C_COMMAND";
    }

    /**
     * 返回当前A指令符号
     *
     * @return
     */
    public String symbol() {
        return nowLine.substring(1);
    }

    public String Label() {
        return nowLine.substring(nowLine.indexOf('(') + 1, nowLine.indexOf(')'));
    }

    /**
     * 当前指令的 dest 助记符
     *
     * @return
     */
    public String dest() {
        if (!nowLine.contains("=")) {
            return "";
        } else {
            return nowLine.substring(0, nowLine.indexOf("="));
        }
    }

    public String comp() {
        int start;
        if (!nowLine.contains("=")) {
            start = 0;
        } else {
            start = nowLine.indexOf("=") + 1;
        }
        int end;
        if (!nowLine.contains(";")) {
            end = nowLine.length();
        } else {
            end = nowLine.indexOf(";");
        }
        return nowLine.substring(start, end);
    }

    public String jump() {
        if (!nowLine.contains(";")) {
            return "";
        } else {
            return nowLine.substring(nowLine.indexOf(";") + 1);
        }
    }


}
