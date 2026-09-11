
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.FileWriter;

public class KeyProcessorFile {

    public static String ProcessFile(){
        File keyFile = new File("../../key.loc");
        if (!keyFile.exists()){
            System.out.println("Key.loc does not exist. Creating blank Key.loc file");
            createSpareKey(keyFile);
        }
        
        // read in key-val pairs:
        return readKeyFile(keyFile);
    }
    public static void createSpareKey(File keyFileLocation) {
        File spareKey = new File("../storage/sparekey.loc");            
        String st = "";
        try {
            Scanner in = new Scanner(spareKey);
            while (in.hasNextLine()){
                st+=in.nextLine() + "\n";
            }
            in.close();
        } catch (IOException e){
            System.out.println("IOException found when trying to read the sparekey file.");
            e.printStackTrace();
            return;
        }
        // catch any new file errors
        try {
            keyFileLocation.createNewFile();
            FileWriter fw = new FileWriter(keyFileLocation);
            fw.write(st);
            fw.close();
        } catch (IOException fnf){
            System.out.println("File not found exception found while trying to create a new keyfile.");
            fnf.printStackTrace();
            return;
        }
        return;
    }
    
    // returns string in key, val pairs. 
    public static String readKeyFile(File keyFileLocation){
        String rtrString = "";
        try {
            Scanner sc = new Scanner(keyFileLocation);
            while (sc.hasNextLine()){
                rtrString += extractKeyValPair(sc.nextLine()) + " ";
            }
            sc.close();
        } catch (IOException e){
            System.out.println("An error occured when reading the key file. ");
            e.printStackTrace();
            return "";
        }
        return rtrString;
    }

    public static String extractKeyValPair(String line){
        String key = line.substring(line.indexOf('#'), line.indexOf(';'));
        String val = line.substring(line.indexOf(";"));
        return key + " " + val;
    }


}