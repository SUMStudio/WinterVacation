/**
 * Created by 张俊华 on 2018/1/29.
 *
 * @author 张俊华.
 * @Time 2018/1/29 13:47.
 */
public class Code {
    static public String dest(String code) {
        StringBuilder stringBuilder = new StringBuilder("000");
        if (code.contains("A")) {
            stringBuilder.replace(0, 1, "1");
        }
        if (code.contains("D")) {
            stringBuilder.replace(1, 2, "1");
        }
        if (code.contains("M")) {
            stringBuilder.replace(2, 3, "1");
        }
        return stringBuilder.toString();
    }

    static public String comp(String code) {
        if (code.equals("0")) return "0101010";
        else if (code.equals("1")) return "0111111";
        else if (code.equals("-1")) return "0111010";
        else if (code.equals("D")) return "0001100";
        else if (code.equals("A")) return "0110000";
        else if (code.equals("M")) return "1110000";
        else if (code.equals("!D")) return "0001101";
        else if (code.equals("!A")) return "0110001";
        else if (code.equals("!M")) return "1110001";
        else if (code.equals("-D")) return "0001111";
        else if (code.equals("-A")) return "0110011";
        else if (code.equals("-M")) return "1110011";
        else if (code.equals("D+1")) return "0011111";
        else if (code.equals("A+1")) return "0110111";
        else if (code.equals("M+1")) return "1110111";
        else if (code.equals("D-1")) return "0001110";
        else if (code.equals("A-1")) return "0110010";
        else if (code.equals("M-1")) return "1110010";
        else if (code.equals("D+A")) return "0000010";
        else if (code.equals("D+M")) return "1000010";
        else if (code.equals("D-A")) return "0010011";
        else if (code.equals("D-M")) return "1010011";
        else if (code.equals("A-D")) return "0000111";
        else if (code.equals("M-D")) return "1000111";
        else if (code.equals("D&A")) return "0000000";
        else if (code.equals("D&M")) return "1000000";
        else if (code.equals("D|A")) return "0010101";
        else if (code.equals("D|M")) return "1010101";

        return "error";
    }

    static public String jump(String code) {
        switch (code) {
            case "JGT":
                return "001";
            case "JEQ":
                return "010";
            case "JGE":
                return "011";
            case "JLT":
                return "100";
            case "JNE":
                return "101";
            case "JLE":
                return "110";
            case "JMP":
                return "111";
            default:
                return "000";
        }
    }
}
