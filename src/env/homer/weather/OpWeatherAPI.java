package homer.weather;
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
	
	private void makeRequest() { //Fun��o que envia request para API
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
	
	public String previsaoDia(int d) { // Fun��o para buscar a previs�o de um dia especifico
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		OWresponse.Daily theDay = null;
		for(OWresponse.Daily day : daily ) {
			if(tm.toDay(day.getDt()) == d ){
				theDay = day;
			}
		}
		String previsao = "Dia %d far� %.0f graus e ";
		ArrayList<String> wcs = theDay.getWeather();
		if (wcs.size() < 2) {
			previsao += "a condi��o do tempo ser�: " + wcs.get(0);
		} else {
			previsao += "as condi��es do tempo ser�o: ";
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
	
	
	public String boaNoite() { // Fun��o para ser usada quando usu�rio for dormir (informa��es sobre o pr�ximo dia)
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		OWresponse.Current current = wResponse.getCurrent();
		String result = String.format("a temperatura atual � %.0f graus , amanh� a m�xima ser� de %.0f e a minima %.0f, %s", 
				current.getTemp(), daily.get(1).getMinMax()[1], daily.get(1).getMinMax()[0], choverAmanha());
		return result;
	}
	
	
	public String bomDia() { // Fun��o para ser usada quando o usu�rio acordar (informa��es sobre o dia em quest�o)
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
		String result = String.format("a temperatura atual � %.0f graus , a m�xima ser� de %.0f e a minima %.0f, ", 
									current.getTemp(), daily.get(0).getMinMax()[1], daily.get(0).getMinMax()[0]);
		
		if(rainHour == 0) {
			result += "n�o est� previsto chuva";
		} else {
			result += " est� previsto chuva pr�ximo das " + rainHour + " horas, n�o esque�a do guarda-chuva, ";
		}
		
		if (wcs.size() < 2) {
			result += "a condi��o do tempo � " + wcs.get(0);
		} else {
			result += "as condi��es do tempo de s�o: ";
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
		
	
	public String choverAmanha() { // Fun��o para saber se ir� chover no dia seguinte 
		String result = "" ;
		makeRequest();
		ArrayList<OWresponse.Daily> daily = wResponse.getDaily();
		if (!daily.get(1).hasRain()) {
			result += "n�o ";
		}
		result += "est� previsto chuva";
		return result;
	}
	
	public String WeatherCondition() {  // Fun��o auxiliar para retornar a condi��o do tempo 
		makeRequest();
		OWresponse.Current current = wResponse.getCurrent();
		ArrayList<String> wcs = current.getWeather();
		String result = "";
		if (wcs.size() < 2) {
			result = "a condi��o do tempo de hoje � " + wcs.get(0);
		} else {
			result = "as condi��es do tempo de hoje s�o:";
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
	
	public String tempoDeSol() { // Fun��o que retorna quando o sol nasce e se p�e
		makeRequest();
		OWresponse.Current current = wResponse.getCurrent();
		return "Hoje o sol nasce as " + tm.toTime(current.getSunrise()) +  " e se p�e as " + tm.toTime(current.getSunset());
	}
	
	
	// Classe auxuliar para lidar com datas e a convers�o de tempo Epoch
	private class TimeManager {
		private LocalDateTime tm;
		ZoneOffset zost;
		
		public TimeManager() {
			tm = LocalDateTime.now();
			zost = ZoneOffset.of("-3");
		}
		
		public String toTime(int dt) { // Converte e retorna o hor�rio
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
		
		public int toDay(int dt) { // Converte e restorna o dia do m�s
			tm  = LocalDateTime.ofEpochSecond(dt, 0, zost);
			return tm.getDayOfMonth();
			
		}
	
	}
}