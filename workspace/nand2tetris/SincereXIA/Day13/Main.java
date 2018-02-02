import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;

public class Main {

    public static void main(String[] args) throws IOException {
        String outputFile = args[0].replaceAll(".vm",".asm");
        FileWriter fileWriter = new FileWriter(outputFile);
        FileInputStream fileInputStream = new FileInputStream(args[0]);
        VMParser parser = new VMParser(fileInputStream);
        CodeWriter writer = new CodeWriter(fileWriter);

        while (parser.hasMoreCommands()){
            parser.advance();
            switch (parser.commandType()){
                case "C_ARITHMETIC":
                    writer.writeArithmetic(parser.arg1());
                    break;
                case "C_PUSH":
                case "C_POP":
                    writer.writePushPoP(parser.commandType(),parser.arg1(),parser.arg2());
                    break;
            }
        }
        fileWriter.close();
        fileInputStream.close();
    }
}
