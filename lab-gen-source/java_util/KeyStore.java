
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Scanner;

/**
 * KeyStore
 *
 * A small, reusable layer on top of the project's personal key file ({@code key.loc}).
 * It parses the {@code #KEY;VALUE} line format into a lookup map so other tools
 * (e.g. SpellChecker) can request a personal value by name without re-implementing
 * file parsing.
 *
 * The on-disk format matches the committed template at {@code storage/sparekey.loc}:
 * <pre>
 *   #NAME;Daniel Sabalakov
 *   #EMAIL;someone@example.com
 *   #OPENAI_AUTH;sk-...
 * </pre>
 *
 * If {@code key.loc} does not exist it is created from the blank spare template,
 * matching the behavior in {@link KeyProcessorFile}.
 *
 * This class is intentionally self-contained so it can be compiled and used on its
 * own. It is the single place that knows where personal keys and tool credentials
 * live, keeping secrets out of source and out of version control (key.loc is
 * git-ignored).
 */
public class KeyStore {

    /** Default location of the personal key file, relative to lab-gen-source/. */
    public static final String DEFAULT_KEY_PATH = "../key.loc";

    /** Location of the committed blank template used to seed a new key file. */
    public static final String SPARE_KEY_PATH = "storage/sparekey.loc";

    private final Map<String, String> entries = new HashMap<>();

    /** Loads keys from the default location ({@value #DEFAULT_KEY_PATH}). */
    public KeyStore() {
        this(new File(DEFAULT_KEY_PATH));
    }

    /** Loads keys from a specific file. Useful for tests or alternate configs. */
    public KeyStore(File keyFile) {
        if (!keyFile.exists()) {
            System.out.println("key.loc does not exist. Creating a blank key.loc from the spare template.");
            createSpareKey(keyFile);
        }
        load(keyFile);
    }

    /**
     * Returns the value stored for {@code name}, or {@code null} if the key is
     * absent. Lookup is case-insensitive and tolerant of surrounding whitespace,
     * so {@code getKey("openai_auth")} and {@code getKey("OPENAI_AUTH")} are
     * equivalent.
     */
    public String getKey(String name) {
        if (name == null) {
            return null;
        }
        return entries.get(name.trim().toUpperCase());
    }

    /**
     * Returns {@code true} if the key exists and has a non-empty value. A key
     * present in the template but never filled in (e.g. {@code #OPENAI_AUTH;})
     * is treated as missing.
     */
    public boolean hasKey(String name) {
        String v = getKey(name);
        return v != null && !v.isEmpty();
    }

    /** Returns the value for {@code name}, or {@code fallback} if missing/empty. */
    public String getKeyOrDefault(String name, String fallback) {
        return hasKey(name) ? getKey(name) : fallback;
    }

    // --- internal parsing -------------------------------------------------

    private void load(File keyFile) {
        try (Scanner sc = new Scanner(keyFile)) {
            while (sc.hasNextLine()) {
                parseLine(sc.nextLine());
            }
        } catch (IOException e) {
            System.out.println("An error occurred while reading the key file.");
            e.printStackTrace();
        }
    }

    /**
     * Parses a single {@code #KEY;VALUE} line into the map. Lines that do not
     * contain both a {@code #} and a {@code ;} are ignored (blank lines,
     * comments, stray text). Keys are normalized to upper-case for lookup.
     */
    private void parseLine(String line) {
        if (line == null) {
            return;
        }
        int hash = line.indexOf('#');
        int semi = line.indexOf(';');
        if (hash < 0 || semi < 0 || semi < hash) {
            return;
        }
        String key = line.substring(hash + 1, semi).trim();
        String val = (semi + 1 < line.length()) ? line.substring(semi + 1).trim() : "";
        if (!key.isEmpty()) {
            entries.put(key.toUpperCase(), val);
        }
    }

    /** Seeds a new key file by copying the committed blank template. */
    private void createSpareKey(File keyFileLocation) {
        StringBuilder sb = new StringBuilder();
        File spareKey = new File(SPARE_KEY_PATH);
        try (Scanner in = new Scanner(spareKey)) {
            while (in.hasNextLine()) {
                sb.append(in.nextLine()).append("\n");
            }
        } catch (IOException e) {
            System.out.println("IOException while reading the spare key template (" + SPARE_KEY_PATH + ").");
            e.printStackTrace();
            return;
        }
        try {
            keyFileLocation.createNewFile();
            try (FileWriter fw = new FileWriter(keyFileLocation)) {
                fw.write(sb.toString());
            }
        } catch (IOException e) {
            System.out.println("IOException while creating a new key file.");
            e.printStackTrace();
        }
    }

    /**
     * Simple CLI: prints which keys are present (values are NOT printed, to avoid
     * leaking secrets to the console/logs). Run with {@code java -cp java_util KeyStore}.
     */
    public static void main(String[] args) {
        KeyStore store = new KeyStore();
        System.out.println("Loaded keys from " + DEFAULT_KEY_PATH + ":");
        for (String name : new String[] {
                "NAME", "EMAIL", "UNIVERSITYEMAIL", "GITHUB", "LINKEDIN", "OPENAI_AUTH" }) {
            System.out.println("  " + name + ": " + (store.hasKey(name) ? "set" : "(empty)"));
        }
    }
}
