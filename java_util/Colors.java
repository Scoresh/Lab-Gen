import java.util.HashMap;

public class Colors{
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
            //Ansi Code as argument 1
            String ansiCode = args[0];
            //String as argument 2
            String printedString = args[1];
            printColor(printedString,colorMap.get(ansiCode));
        } catch (ArrayIndexOutOfBoundsException e){
            System.out.println("An error occured while using color schema.");
            e.printStackTrace();
        }
    }
    public static void printColor(String print, String color){
        System.out.println(color + print + ANSI_RESET);
    }


}