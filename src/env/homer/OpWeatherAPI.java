package homer;

import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.LocalDateTime;
import java.time.ZoneOffset;
import java.util.ArrayList;
import java.util.Calendar;
import com.google.gson.Gson;

public class OpWeatherAPI {
		private OWresponse wResponse; // Classe equivalente ao objeto convertido do JSON
		private TimeManager tm;
		private String key;
	
	public OpWeatherAPI (String key) {
		this.key = key;
		tm =  new TimeManager();
	}
	
	private void makeRequest() { //Função que envia request para API
		try {
			HttpClient client = HttpClient.newHttpClient();
            HttpRequest request = HttpRequest.newBuilder() 
                    .uri(URI.create("https://api.openweathermap.org/data/2.5/onecall?lat=-30.0277&lon=-51.2287&units=metric&lang=pt_br&" + 
                    		"appid=" + key)) 
                    .build();
            HttpResponse<String> response = client.send(request,
        			HttpResponse.BodyHandlers.ofString());
           
            Gson g = new Gson();
            wResponse = g.fromJson(response.body(),  OWresponse.class);
            
		} catch (Exception e){
			e.printStackTrace();
		}
	}
	
	public String previsaoDia(int d) { // Função para buscar a previsão de um dia especifico
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		OWresponse.Daily theDay = null;
		for(OWresponse.Daily day : daily ) {
			if(tm.toDay(day.getDt()) == d ){
				theDay = day;
			}
		}
		String previsao = "Dia %d fará %.0f graus e ";
		ArrayList<String> wcs = theDay.getWeather();
		if (wcs.size() < 2) {
			previsao += "a condição do tempo será: " + wcs.get(0);
		} else {
			previsao += "as condições do tempo serão: ";
			for (String wc : wcs) {
				if (wcs.size() -1 != wcs.indexOf(wc) ) {
					previsao += wc + ", ";	
				} else {
					previsao += wc;
				}
			}
		}	
		return String.format(previsao, tm.toDay(theDay.getDt()), theDay.getTemp());
		
	}
	
	
	public String boaNoite() { // Função para ser usada quando usuário for dormir (informações sobre o próximo dia)
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		OWresponse.Current current = wResponse.getCurrent();
		String result = String.format("a temperatura atual é %.0f graus , amanhã a máxima será de %.0f e a minima %.0f, %s", 
				current.getTemp(), daily.get(1).getMinMax()[1], daily.get(1).getMinMax()[0], choverAmanha());
		return result;
	}
	
	
	public String bomDia() { // Função para ser usada quando o usuário acordar (informações sobre o dia em questão)
		makeRequest();
		ArrayList<OWresponse.Hourly> hourly = wResponse.getHourly();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		OWresponse.Current current = wResponse.getCurrent();
		ArrayList<String> wcs = current.getWeather();
		int rainHour = 0;
		for (OWresponse.Hourly hour : hourly) {
			if (tm.toHour(hour.getDt()) != 0 && hour.hasRain() ) {
				rainHour = tm.toHour(hour.getDt());
				break;
			}
		}
		String result = String.format("a temperatura atual é %.0f graus , a máxima será de %.0f e a minima %.0f, ", 
									current.getTemp(), daily.get(0).getMinMax()[1], daily.get(0).getMinMax()[0]);
		
		if(rainHour == 0) {
			result += "não está previsto chuva";
		} else {
			result += " está previsto chuva próximo das " + rainHour + " horas, não esqueça do guarda-chuva, ";
		}
		
		if (wcs.size() < 2) {
			result += "a condição do tempo é " + wcs.get(0);
		} else {
			result += "as condições do tempo de são: ";
			for (String wc : wcs) {
				if (wcs.size() -1 != wcs.indexOf(wc) ) {
					result += wc + ", ";	
				} else {
					result += wc;
				}
			}
		}
		return result;
	}
		
	
	public String choverAmanha() { // Função para saber se irá chover no dia seguinte 
		String result = "" ;
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		if (!daily.get(1).hasRain()) {
			result += "não ";
		}
		result += "está previsto chuva";
		return result;
	}
	
	public String WeatherCondition() {  // Função auxiliar para retornar a condição do tempo 
		makeRequest();
		OWresponse.Current current = wResponse.getCurrent();
		ArrayList<String> wcs = current.getWeather();
		String result = "";
		if (wcs.size() < 2) {
			result = "a condição do tempo de hoje é " + wcs.get(0);
		} else {
			result = "as condições do tempo de hoje são:";
			for (String wc : wcs) {
				if (wcs.size() -1 != wcs.indexOf(wc) ) {
					result += wc + ", ";	
				} else {
					result += wc;
				}
			}
		}
		return result;
	}
	
	public String tempoDeSol() { // Função que retorna quando o sol nasce e se põe
		makeRequest();
		OWresponse.Current current = wResponse.getCurrent();
		return "Hoje o sol nasce as " + tm.toTime(current.getSunrise()) +  " e se põe as " + tm.toTime(current.getSunset());
	}
	
	
	// Classe auxuliar para lidar com datas e a conversão de tempo Epoch
	private class TimeManager {
		private LocalDateTime tm;
		ZoneOffset zost;
		
		public TimeManager() {
			tm = LocalDateTime.now();
			zost = ZoneOffset.of("-3");
		}
		
		public String toTime(int dt) { // Converte e retorna o horário
			tm  = LocalDateTime.ofEpochSecond(dt, 0, zost);
			String hour = "";
			String minute = "";
			if (tm.getMinute() < 10) { minute = "0" + tm.getMinute(); } 
			else { minute += tm.getMinute(); }
			if (tm.getHour() < 10) { hour = "0" + tm.getHour(); }
			else { hour += tm.getHour(); } 
			return hour + ":" + minute;
	    }
		public int toHour(int dt) { // Converte e retorna somente a hora
			tm = LocalDateTime.ofEpochSecond(dt, 0, zost);
			return tm.getHour();
		}
		
		public int toDay(int dt) { // Converte e restorna o dia do mês
			tm  = LocalDateTime.ofEpochSecond(dt, 0, zost);
			return tm.getDayOfMonth();
			
		}
	
	}
}