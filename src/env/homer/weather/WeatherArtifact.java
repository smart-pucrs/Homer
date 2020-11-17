// CArtAgO artifact code for project Homer

package homer.weather;

import cartago.*;

public class WeatherArtifact extends Artifact {
	OpWeatherAPI wStation = null;
	void init() {
		System.out.println("init WeatherArtifact");
		this.wStation = new OpWeatherAPI("01dc0885a94ac05dd3185df11da3d3fc");
	}

	@OPERATION
	void dayForecast(Byte day, OpFeedbackParam<String> forecast) {	
		try {
			forecast.set(wStation.previsaoDia(day));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar previsao para o dia: "+ day);
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			forecast.set("Desculpe-me, houve um erro ao verificar a previsao para o dia " + day);		
		}
	}
	
	@OPERATION
	void goodNight(OpFeedbackParam<String> forecast) {	
		try {
			forecast.set(wStation.boaNoite());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar previsao");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			forecast.set("Desculpe-me, houve um erro ao verificar a previsao");
		}
	}

	@OPERATION
	void goodMorning(OpFeedbackParam<String> forecast) {	
		try {
			forecast.set(wStation.bomDia());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar previsao");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			forecast.set("Desculpe-me, houve um erro ao verificar a previsao");
		}
	}
	
	@OPERATION
	void tomorrowForecast(OpFeedbackParam<String> forecast) {	
		try {
			forecast.set(wStation.choverAmanha());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar previsao");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			forecast.set("Desculpe-me, houve um erro ao verificar a previsao para amanha");
		}
	}

	@OPERATION
	void aboutSun(OpFeedbackParam<String> forecast) {	
		try {
			forecast.set(wStation.tempoDeSol());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar horários do sol");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			forecast.set("Desculpe-me, houve um erro ao verificar horarios do sol");
		}
	}

	@OPERATION
	void getCurrentTemperature(OpFeedbackParam<String> temperature) {	
		try {
			temperature.set(CheckRoomTemp.currentTemperature());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar temperatura");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			temperature.set("Desculpe-me, houve um erro ao checar a temperatura");
		}
	}


	@OPERATION
	void getCurrentHumidity(OpFeedbackParam<String> humidity) {	
		try {
			humidity.set(CheckRoomHum.currentHumidity());
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar temperatura");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			humidity.set("Desculpe-me, houve um erro ao checar a umidade");
		}
	}

	
}
