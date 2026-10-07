
import java.net.Authenticator;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.net.http.HttpClient.Redirect;
import java.net.http.HttpClient.Version;
import java.time.Duration;


public class SpellChecker {
    private HttpClient httpClient;
    public SpellChecker(){
        httpClient = HttpClient.newBuilder()
            .version(Version.HTTP_3)
            .followRedirects(Redirect.NORMAL)
            .connectTimeout(Duration.ofSeconds(10))
            .authenticator(Authenticator.getDefault())
            .build();
        
        
    }



    public String sendRequest(){
        HttpRequest req = HttpRequest.newBuilder().uri(URI.create("")).build();
        
        
        return "";
    }

    public void display(){

    }

}