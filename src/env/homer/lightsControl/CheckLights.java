package homer.lightsControl;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import com.google.gson.Gson;

class ReturnValues {
	private boolean Light;
	private int return_value;
	ReturnValues(){	
	}
	public boolean getLight() {
		if(return_value == 0) Light = true;
		else if(return_value == 1) Light = false;
		//else Light = null;
		return Light;
	}
}

public class CheckLights {

	private static String ESP32IP = "192.168.1.128"; // Inserir o IP do ESP32 exibido no console da IDE da placa
	
	public static String check() {
		try {
			String status = null;
			// Envia uma solicitacao de variavel para o ESP32
			System.out.print("Enviando Request ao ESP32... ");
       	 	HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder() // Request  para  atualizar a valor do sensor 
                    .uri(URI.create("http://" + ESP32IP + "/checkLight")) 
                    .build();
            HttpRequest request2 = HttpRequest.newBuilder() // Request para retornar o valor do sensor
                    .uri(URI.create("http://" + ESP32IP + "/Light")) 
                    .build();
            HttpResponse<String> response = client.send(request,
            			HttpResponse.BodyHandlers.ofString());
            HttpResponse<String> response2 = client.send(request2,
        			HttpResponse.BodyHandlers.ofString());
            
            System.out.println("Pronto!");
            
            // Organiza a resposta em JSON
            Gson gson = new Gson();
            ReturnValues Jresponse = gson.fromJson(response.body(), ReturnValues.class);
            
            // Verifica a variavel e exibe a resposta
            if(Jresponse.getLight()) {
            	status = "On";
            	System.out.println("A luz esta ligada");
            } else if(!Jresponse.getLight()) {
            	status = "Off";
            	System.out.println("A luz esta desligada");
            } else {
            	status = "Erro";
            	System.out.println("Nao foi possivel reconhecer o estado da luz");
            }
            return status;
       } catch (Exception e) {
    	    System.out.printf("\n Nao foi possivel conectar ao ESP32");
    	   // e.printStackTrace();
    	    return "Erro";
       }
	}
}
