
import java.io.IOException;
import java.net.URI;
import java.net.URLEncoder;
import java.net.http.HttpClient;
import java.net.http.HttpClient.Redirect;
import java.net.http.HttpClient.Version;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * SpellChecker
 *
 * Checks a markdown source file for spelling and grammar issues using the free
 * LanguageTool public API (https://languagetool.org). No API key is required,
 * so anyone who clones LabGen can run the spell checker out of the box.
 *
 * Design notes:
 *  - Uses only the JDK's built-in java.net.http client; LabGen deliberately
 *    carries no third-party Java dependencies, so the (small) JSON response is
 *    parsed with regular expressions rather than a JSON library.
 *  - Personal keys/credentials are accessed through {@link KeyStore}. LanguageTool
 *    does not need one, but if a LANGUAGETOOL_AUTH key is present in key.loc it is
 *    sent so the user can authenticate against a premium/self-hosted endpoint.
 *
 * Run standalone:
 *   java -cp java_util SpellChecker ../projects/projects_markdown/MyLab.md
 */
public class SpellChecker {

    /** Free public LanguageTool endpoint. */
    private static final String API_URL = "https://api.languagetool.org/v2/check";

    private final HttpClient httpClient;
    private final KeyStore keyStore;

    public SpellChecker() {
        this.httpClient = HttpClient.newBuilder()
                .version(Version.HTTP_2)
                .followRedirects(Redirect.NORMAL)
                .connectTimeout(Duration.ofSeconds(10))
                .build();
        this.keyStore = new KeyStore();
    }

    /**
     * A single spelling/grammar issue reported by LanguageTool.
     */
    public static final class Issue {
        public final String message;
        public final String context;
        public final int offset;
        public final int length;
        public final List<String> suggestions;

        Issue(String message, String context, int offset, int length, List<String> suggestions) {
            this.message = message;
            this.context = context;
            this.offset = offset;
            this.length = length;
            this.suggestions = suggestions;
        }
    }

    /**
     * Sends {@code text} to LanguageTool and returns the raw JSON response body.
     * Returns an empty string if the request fails.
     */
    public String sendRequest(String text) {
        try {
            StringBuilder form = new StringBuilder();
            form.append("language=en-US");
            form.append("&text=").append(URLEncoder.encode(text, StandardCharsets.UTF_8));

            // Optional authentication for premium/self-hosted LanguageTool servers.
            if (keyStore.hasKey("LANGUAGETOOL_AUTH")) {
                form.append("&apiKey=")
                    .append(URLEncoder.encode(keyStore.getKey("LANGUAGETOOL_AUTH"), StandardCharsets.UTF_8));
            }

            HttpRequest req = HttpRequest.newBuilder()
                    .uri(URI.create(API_URL))
                    .timeout(Duration.ofSeconds(30))
                    .header("Content-Type", "application/x-www-form-urlencoded")
                    .header("Accept", "application/json")
                    .POST(HttpRequest.BodyPublishers.ofString(form.toString()))
                    .build();

            HttpResponse<String> resp = httpClient.send(req, HttpResponse.BodyHandlers.ofString());
            if (resp.statusCode() / 100 != 2) {
                System.out.println("Spell check request failed with HTTP status " + resp.statusCode() + ".");
                return "";
            }
            return resp.body();
        } catch (IOException e) {
            System.out.println("Network error while contacting the spell check service.");
            e.printStackTrace();
            return "";
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            System.out.println("Spell check request was interrupted.");
            return "";
        }
    }

    /** Convenience: check text and return the parsed list of issues. */
    public List<Issue> check(String text) {
        return parseIssues(sendRequest(text));
    }

    /**
     * Strips markup that would otherwise produce false positives before the text
     * is sent for checking: inline/display math ($...$ and $$...$$), raw LaTeX
     * commands (\frac, \input{...}, etc.), LabGen command macros (@!...!@ and
     * @!word), YAML metadata front matter, and fenced code blocks. Each removed
     * span is replaced with a single space so that character offsets stay roughly
     * aligned and real words on either side are not merged.
     */
    public static String cleanMarkup(String text) {
        if (text == null) {
            return "";
        }
        // Normalize line endings so carriage returns don't leak into contexts.
        text = text.replace("\r\n", "\n").replace("\r", "\n");
        // YAML front matter block at the very top (--- ... ---).
        text = text.replaceFirst("(?s)\\A---\\n.*?\\n---\\n", " ");
        // Fenced code blocks ```...```.
        text = text.replaceAll("(?s)```.*?```", " ");
        // Display and inline math.
        text = text.replaceAll("(?s)\\$\\$.*?\\$\\$", " ");
        text = text.replaceAll("(?s)\\$.*?\\$", " ");
        // LabGen block macros @!word ... !@
        text = text.replaceAll("(?s)@!.*?!@", " ");
        // LabGen inline macros @!word
        text = text.replaceAll("@![A-Za-z]+", " ");
        // Raw LaTeX commands with optional {..}/[..] arguments.
        text = text.replaceAll("\\\\[A-Za-z]+(\\{[^}]*\\}|\\[[^\\]]*\\])*", " ");
        // Remaining backslash-escapes.
        text = text.replaceAll("\\\\.", " ");
        return text;
    }

    // --- JSON parsing -----------------------------------------------------

    // LanguageTool returns an object with a "matches" array. Each match has a
    // "message", a "context" object { text, offset, length }, and a
    // "replacements" array of { value } suggestions. We extract these fields with
    // targeted regexes rather than pulling in a JSON dependency.
    private static final Pattern MATCH_BLOCK =
            Pattern.compile("\\{\"message\":\"(.*?)\",\"shortMessage\".*?"
                    + "\"replacements\":\\[(.*?)\\].*?"
                    + "\"context\":\\{\"text\":\"(.*?)\",\"offset\":(\\d+),\"length\":(\\d+)\\}",
                    Pattern.DOTALL);
    private static final Pattern REPLACEMENT_VALUE =
            Pattern.compile("\"value\":\"(.*?)\"");

    /** Parses LanguageTool JSON into a list of {@link Issue}s. */
    public List<Issue> parseIssues(String json) {
        List<Issue> issues = new ArrayList<>();
        if (json == null || json.isEmpty()) {
            return issues;
        }
        Matcher m = MATCH_BLOCK.matcher(json);
        while (m.find()) {
            String message = unescape(m.group(1));
            String replacementsBlob = m.group(2);
            String context = unescape(m.group(3));
            int offset = Integer.parseInt(m.group(4));
            int length = Integer.parseInt(m.group(5));

            List<String> suggestions = new ArrayList<>();
            Matcher r = REPLACEMENT_VALUE.matcher(replacementsBlob);
            while (r.find() && suggestions.size() < 5) {
                suggestions.add(unescape(r.group(1)));
            }
            issues.add(new Issue(message, context, offset, length, suggestions));
        }
        return issues;
    }

    private static String unescape(String s) {
        return s.replace("\\\"", "\"")
                .replace("\\n", "\n")
                .replace("\\t", "\t")
                .replace("\\/", "/")
                .replace("\\\\", "\\");
    }

    // --- display ----------------------------------------------------------

    /**
     * Prints a human-readable report of the given issues. Uses the project's
     * ANSI color helpers where convenient.
     */
    public void display(List<Issue> issues) {
        final String reset = "\u001B[0m";
        final String red = "\u001B[31m";
        final String yellow = "\u001B[33m";
        final String green = "\u001B[32m";

        if (issues.isEmpty()) {
            System.out.println(green + "No spelling or grammar issues found. You're all set!" + reset);
            return;
        }

        System.out.println(yellow + "Found " + issues.size() + " issue(s):" + reset);
        final String prefix = "   context: ";
        int n = 1;
        for (Issue issue : issues) {
            // Collapse newlines/tabs so the context prints on one tidy line.
            String ctx = issue.context.replaceAll("[\\r\\n\\t]+", " ");
            System.out.println();
            System.out.println(red + n + ". " + issue.message + reset);
            System.out.println(prefix + ctx);
            // issue.offset is the index of the flagged span within the context
            // string, so the caret lines up directly under it.
            String pointer = " ".repeat(prefix.length() + Math.max(0, issue.offset))
                    + "^".repeat(Math.max(1, issue.length));
            System.out.println(pointer);
            if (!issue.suggestions.isEmpty()) {
                System.out.println("   suggestions: " + String.join(", ", issue.suggestions));
            }
            n++;
        }
    }

    // --- entry point ------------------------------------------------------

    /**
     * Usage: {@code java -cp java_util SpellChecker <path-to-markdown>}
     * Defaults to ../projects/projects_markdown/text.md if no path is given.
     */
    public static void main(String[] args) {
        String path = (args.length > 0) ? args[0] : "../projects/projects_markdown/text.md";
        String text;
        try {
            text = Files.readString(Path.of(path));
        } catch (IOException e) {
            System.out.println("Could not read file: " + path);
            return;
        }

        SpellChecker checker = new SpellChecker();
        System.out.println("Running spell check on " + path + " ...");
        List<Issue> issues = checker.check(cleanMarkup(text));
        checker.display(issues);
    }
}
