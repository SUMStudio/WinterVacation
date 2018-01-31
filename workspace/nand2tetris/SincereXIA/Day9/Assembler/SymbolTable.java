import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.regex.Pattern;

/**
 * Created by 张俊华 on 2018/1/29.
 *
 * @author 张俊华.
 * @Time 2018/1/29 14:40.
 */
public class SymbolTable {
    private HashMap<String, Integer> symbolTable;
    private HackParser hackParser;
    private int addressNow;
    private String fileName;

    SymbolTable(String fileName) throws IOException {
        FileInputStream fs = new FileInputStream(fileName);
        hackParser = new HackParser(fs);
        symbolTable = new HashMap();
        symbolTable.put("SP", 0);
        symbolTable.put("LCL", 1);
        symbolTable.put("ARG", 2);
        symbolTable.put("THIS", 3);
        symbolTable.put("THAT", 4);
        symbolTable.put("R0", 0);
        symbolTable.put("R1", 1);
        symbolTable.put("R2", 2);
        symbolTable.put("R3", 3);
        symbolTable.put("R4", 4);
        symbolTable.put("R5", 5);
        symbolTable.put("R6", 6);
        symbolTable.put("R7", 7);
        symbolTable.put("R8", 8);
        symbolTable.put("R9", 9);
        symbolTable.put("R10", 10);
        symbolTable.put("R11", 11);
        symbolTable.put("R12", 12);
        symbolTable.put("R13", 13);
        symbolTable.put("R14", 14);
        symbolTable.put("R15", 15);
        symbolTable.put("SCREEN", 16384);
        symbolTable.put("KBD", 24576);

        addressNow = 0;

        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            if (hackParser.commandType().equals("A_COMMAND")) {
                addressNow++;
            } else if (hackParser.commandType().equals("C_COMMAND")) {
                addressNow++;
            } else if (hackParser.commandType().equals("L_COMMAND")) {
                symbolTable.put(hackParser.Label(), addressNow);
            }
        }

        addressNow = 16;
        fs.close();
        fs = new FileInputStream(fileName);
        hackParser = new HackParser(fs);
        while (hackParser.hasMoreCommands()) {
            hackParser.advance();
            if (hackParser.commandType().equals("A_COMMAND")) {
                if (!symbolTable.containsKey(hackParser.symbol()) && !isInteger(hackParser.symbol())) {
                    symbolTable.put(hackParser.symbol(), addressNow);
                    addressNow++;
                }
            }
        }
    }

    public static boolean isInteger(String str) {
        Pattern pattern = Pattern.compile("^[-\\+]?[\\d]*$");
        return pattern.matcher(str).matches();
    }

    public String getAddress(String label) {
        Integer address;
        String string;
        if (symbolTable.containsKey(label)) {
            address = symbolTable.get(label);
        } else {
            address = Integer.valueOf(label);
        }
        string = Integer.toBinaryString(address);
        StringBuilder sb = new StringBuilder(string);
        for (int i = sb.length(); i <= 15; i++) {
            sb.insert(0, '0');
        }
        return sb.toString();
    }
}
