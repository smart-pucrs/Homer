package homer.weather;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import com.google.gson.Gson;

public class CheckRoomTemp{
	
	class ReturnValues {
		private int return_value;
		ReturnValues(){	
		}
		public int getTemp() {
			return return_value;
		}
	}

	private static String ESP32IP = "192.168.1.128"; // Inserir o IP do ESP32 exibido no console da IDE da placa
	
//	public static void main(String args[]) {
	public static String currentTemperature() {
		try {
			String status = null;
			// Envia uma solicitação de variavel para o ESP32
			System.out.print("Enviando Request ao ESP32... ");
       	 	HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder() // Request para atualizar e retornar valor do sensor 
                    .uri(URI.create("http://" + ESP32IP + "/checkTemp")) 
                    .build();
            HttpResponse<String> response = client.send(request,
            			HttpResponse.BodyHandlers.ofString());
            
            System.out.println("Pronto!");
            
            // Organiza a resposta em JSON
            Gson gson = new Gson();
            ReturnValues Jresponse = gson.fromJson(response.body(), ReturnValues.class);
            String resp;
            if(!(Jresponse.getTemp() > 100)) {
            	resp = "A temperatura atual e " + Jresponse.getTemp() + "graus celsius";            	
            } else {
            	resp = "Desculpe, houve um erro no sensor";
            }
            return resp;
           
       } catch (Exception e) {
    	    System.out.printf("\n Nao foi possivel conectar ao ESP32");
    	    return "Desculpe, houve um erro e nao consegui localizar o sensor de temperatura";
    	    // e.printStackTrace();
       }
	}
}