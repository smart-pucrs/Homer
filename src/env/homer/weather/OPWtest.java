package homer.weather;

import homer.weather.OpWeatherAPI.DayOutOfRangeException;

public class OPWtest { // Classe de teste para exemplificar o uso da API e classe auxiliar criada
	public static void main (String[] args) throws DayOutOfRangeException {
		OpWeatherAPI wStation = new OpWeatherAPI("01dc0885a94ac05dd3185df11da3d3fc");
		System.out.println("| Exemplos  ========================================================= |");
		System.out.println("Usuário: Boa noite Homer");
		System.out.println("Homer: Boa noite, "  + wStation.boaNoite());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usuário: Bom dia Homer");
		System.out.println("Homer: Bom dia, "  + wStation.bomDia());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usuário: Homer qual a previsão para o dia 2?");
		System.out.println("Homer: " + wStation.previsaoDia(2));
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usuário: Homer vai chover amanhã ?");
		System.out.println("Homer: " + wStation.choverAmanha());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usuário: Homer quando o sol se põe ?");
		System.out.println("Homer: " + wStation.tempoDeSol());
		System.out.println("-----------------------------------------------------------------------");
			
	}
	
}
