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
	
}

