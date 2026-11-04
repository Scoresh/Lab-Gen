import java.io.File;
import java.nio.file.Files;
import java.util.List;

/**
 * Dependency-free tests for the Java utilities (LabGen carries no third-party
 * libraries, so there is no JUnit). Run via run_tests.bat, or manually:
 *
 *   javac -d tests/out java_util/KeyStore.java java_util/SpellChecker.java tests/JavaTests.java
 *   java -cp tests/out JavaTests
 *
 * Exits non-zero if any check fails.
 */
public class JavaTests {

    private static int total = 0;
    private static int failures = 0;

    private static void check(String name, Object actual, Object expected) {
        total++;
        boolean ok = (expected == null) ? actual == null : expected.equals(actual);
        if (!ok) {
            failures++;
            System.out.println("FAIL: " + name);
            System.out.println("  expected: " + expected);
            System.out.println("  actual:   " + actual);
        }
    }

    public static void main(String[] args) throws Exception {
        testCleanMarkup();
        testParseIssues();
        testChunking();
        testKeyStore();

        System.out.println((total - failures) + "/" + total + " Java checks passed");
        if (failures > 0) {
            System.exit(1);
        }
    }

    // --- SpellChecker.cleanMarkup ------------------------------------------

    static void testCleanMarkup() {
        String cleaned = SpellChecker.cleanMarkup("Hello $x^2$ world @!toc !@ done \\newpage end");
        check("cleanMarkup: math removed", cleaned.contains("x^2"), false);
        check("cleanMarkup: macro removed", cleaned.contains("toc"), false);
        check("cleanMarkup: latex command removed", cleaned.contains("newpage"), false);
        check("cleanMarkup: prose kept", cleaned.contains("Hello") && cleaned.contains("world")
                && cleaned.contains("done") && cleaned.contains("end"), true);

        String front = SpellChecker.cleanMarkup("---\nauthor: Me\n---\nBody text");
        check("cleanMarkup: front matter removed", front.contains("author"), false);
        check("cleanMarkup: body after front matter kept", front.contains("Body text"), true);

        check("cleanMarkup: code fence removed",
                SpellChecker.cleanMarkup("a ```int x = 1;``` b").contains("int"), false);
        check("cleanMarkup: null safe", SpellChecker.cleanMarkup(null), "");
    }

    // --- SpellChecker.parseIssues ------------------------------------------

    static void testParseIssues() {
        SpellChecker sc = new SpellChecker();
        String json = "{\"software\":{\"name\":\"LanguageTool\"},\"matches\":["
                + "{\"message\":\"Possible spelling mistake found.\",\"shortMessage\":\"Spelling mistake\","
                + "\"replacements\":[{\"value\":\"hello\"},{\"value\":\"hallo\"}],\"offset\":0,\"length\":5,"
                + "\"context\":{\"text\":\"helo world\",\"offset\":0,\"length\":4},\"rule\":{\"id\":\"X\"}}]}";
        List<SpellChecker.Issue> issues = sc.parseIssues(json);
        check("parseIssues: count", issues.size(), 1);
        check("parseIssues: message", issues.get(0).message, "Possible spelling mistake found.");
        check("parseIssues: context", issues.get(0).context, "helo world");
        check("parseIssues: offset", issues.get(0).offset, 0);
        check("parseIssues: length", issues.get(0).length, 4);
        check("parseIssues: suggestions", issues.get(0).suggestions, List.of("hello", "hallo"));

        check("parseIssues: empty string", sc.parseIssues("").size(), 0);
        check("parseIssues: null", sc.parseIssues(null).size(), 0);
        check("parseIssues: no matches", sc.parseIssues("{\"matches\":[]}").size(), 0);
    }

    // --- SpellChecker.splitIntoChunks --------------------------------------

    static void testChunking() {
        check("chunks: empty", SpellChecker.splitIntoChunks("", 100).size(), 0);
        check("chunks: short text is one chunk",
                SpellChecker.splitIntoChunks("short text", 100).size(), 1);

        String para = "word ".repeat(10) + "\n\n";           // 52 chars
        String text = para.repeat(10);                        // 520 chars
        List<String> chunks = SpellChecker.splitIntoChunks(text, 120);
        boolean allFit = true;
        StringBuilder joined = new StringBuilder();
        for (String c : chunks) {
            allFit &= c.length() <= 120;
            joined.append(c);
        }
        check("chunks: every chunk within limit", allFit, true);
        check("chunks: no text lost", joined.toString(), text);

        // One giant paragraph with no blank lines must still be split.
        String giant = "lorem ".repeat(100);                  // 600 chars
        List<String> giantChunks = SpellChecker.splitIntoChunks(giant, 100);
        boolean giantFits = true;
        StringBuilder giantJoined = new StringBuilder();
        for (String c : giantChunks) {
            giantFits &= c.length() <= 100;
            giantJoined.append(c);
        }
        check("chunks: giant paragraph within limit", giantFits, true);
        check("chunks: giant paragraph no text lost", giantJoined.toString(), giant);
    }

    // --- KeyStore ----------------------------------------------------------

    static void testKeyStore() throws Exception {
        File tmp = File.createTempFile("labgen-keys", ".loc");
        try {
            Files.writeString(tmp.toPath(),
                    "#NAME;Ada Lovelace\n#EMAIL;\n#openai_auth;sk-test\nstray line\n# ;nokey\n");
            KeyStore ks = new KeyStore(tmp);
            check("KeyStore: value", ks.getKey("NAME"), "Ada Lovelace");
            check("KeyStore: case-insensitive", ks.getKey("OpenAI_Auth"), "sk-test");
            check("KeyStore: empty value is not 'has'", ks.hasKey("EMAIL"), false);
            check("KeyStore: set value is 'has'", ks.hasKey("NAME"), true);
            check("KeyStore: missing is null", ks.getKey("MISSING"), null);
            check("KeyStore: fallback", ks.getKeyOrDefault("EMAIL", "none"), "none");
            check("KeyStore: null name", ks.getKey(null), null);
        } finally {
            tmp.delete();
        }
    }
}
