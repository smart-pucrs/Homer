package homer;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import com.google.gson.Gson;

class ReturnValues {
	private boolean Light;
	ReturnValues(){	
	}
	public boolean getLight() {
		return Light;
	}
}

public class CheckLights {

	public static void main(String[] args) {
		try {
			// Envia uma solicitação de variavel para o ESP32
			System.out.print("Enviando Request ao ESP32... ");
       	 	HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create("http://IP_ESP32/Light")) // Inserir o IP do ESP32 exibido no console da IDE da placa
                    .build();
            HttpResponse<String> response = client.send(request,
            			HttpResponse.BodyHandlers.ofString());
            System.out.println("Pronto!");
            
            // Organiza a resposta em JSON
            Gson gson = new Gson();
            ReturnValues Jresponse = gson.fromJson(response.body(), ReturnValues.class);
            
            // Verifica a variavel e exibe a resposta
            if(Jresponse.getLight()) {
            	System.out.println("A luz está ligada");
            } else if(!Jresponse.getLight()) {
            	System.out.println("A luz está desligada");
            } else {
            	System.out.println("Não foi possivel reconhecer o estado da luz");
            }
            
       } catch (Exception e) {
           e.printStackTrace();
       }
	}
}
