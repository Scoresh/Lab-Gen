import java.util.HashMap;

public class ColoredText{
    //Basic colors
    public static final String ANSI_RESET = "\u001B[0m";
    public static final String ANSI_BLACK = "\u001B[30m";
    public static final String ANSI_RED = "\u001B[31m";
    public static final String ANSI_GREEN = "\u001B[32m";
    public static final String ANSI_YELLOW = "\u001B[33m";
    public static final String ANSI_BLUE = "\u001B[34m";
    public static final String ANSI_PURPLE = "\u001B[35m";
    public static final String ANSI_CYAN = "\u001B[36m";
    public static final String ANSI_WHITE = "\u001B[37m";

    
    public static HashMap<String,String> colorMap = new HashMap<>();
    


    public static void main(String[] args){
        colorMap.put("reset",ANSI_RESET);
        colorMap.put("black",ANSI_BLACK);
        colorMap.put("red",ANSI_RED);
        colorMap.put("green",ANSI_GREEN);
        colorMap.put("yellow",ANSI_YELLOW);
        colorMap.put("blue",ANSI_BLUE);
        colorMap.put("purple",ANSI_PURPLE);
        colorMap.put("cyan",ANSI_CYAN);
        colorMap.put("white",ANSI_WHITE);
        try {
            //Ansi Color
            String ansiCode = args[0].toLowerCase();
            String parsedText = args[1];
            String color = colorMap.get(ansiCode);
            if (color == null){color="red";}
            
            if (parsedText.equalsIgnoreCase("default")){
                
                printGen(color);
            }
            else {
                //runs parser to find escape characters and replace them
                parsedText = insertEscapeCharacters(parsedText);
                printColor(parsedText,color);
            }
        } catch (ArrayIndexOutOfBoundsException e){
            System.out.println("An error occured while using color schema.");
            e.printStackTrace();
        }
    }
    
    public static String insertEscapeCharacters(String text){
        return text
        .replace("\\n", "\n")
        .replace("\\t", "\t")
        .replace("\\b", "\b")
        .replace("\\r", "\r")
        .replace("\\f", "\f")
        .replace("\\\"", "\"")
        .replace("\\'", "'")
        .replace("\\\\", "\\");
    }

    public static void printColor(String print, String color){
        System.out.println(color + print + ANSI_RESET);
    }

    public static void printGen(String color){
        System.out.println("\n\n");
        printColor("     _//                _//                   _////                      ",color);
        printColor("     _//                _//                 _/    _//                    ",color);
        printColor("     _//         _//    _//                _//           _//    _// _//  ",color);
        printColor("     _//       _//  _// _// _//            _//         _/   _//  _//  _//",color);
        printColor("     _//      _//   _// _//   _//          _//   _////_///// _// _//  _//",color);
        printColor("     _//      _//   _// _//   _//           _//    _/ _/         _//  _//",color);
        printColor("     _////////  _// _///_// _//              _/////     _////   _///  _//",color);
        System.out.println("\n\n");
    }


}