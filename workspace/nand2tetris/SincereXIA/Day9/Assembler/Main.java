import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

public class Main {
    static private String SRC = "Pong.asm"; //编译文件路径
    public static void main(String[] args) throws IOException {
        System.out.println(System.getProperty("user.dir"));
        FileWriter fo = new FileWriter("out.hack");
        BufferedWriter bfo = new BufferedWriter(fo);
        FileInputStream fs = new FileInputStream(SRC);
        HackParser hackParser = new HackParser(fs);
        SymbolTable symbolTable = new SymbolTable(SRC);
        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            System.out.println("当前行指令：" + hackParser.nowLine);
            if (hackParser.commandType().equals("A_COMMAND")) {
                System.out.println("Symbol: " + hackParser.symbol());
                System.out.println(symbolTable.getAddress(hackParser.symbol()));
                bfo.write(symbolTable.getAddress(hackParser.symbol()) + "\n");
            } else if (hackParser.commandType().equals("C_COMMAND")) {
                bfo.write("111" + Code.comp(hackParser.comp()) + Code.dest(hackParser.dest()) + Code.jump(hackParser.jump()) + "\n");
                System.out.println("111" + Code.comp(hackParser.comp()) + Code.dest(hackParser.dest()) + Code.jump(hackParser.jump()));
            }
        }
        bfo.close();
        fo.close();
    }
}
