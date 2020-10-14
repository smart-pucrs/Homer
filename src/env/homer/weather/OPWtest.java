package homer.weather;
public class OPWtest { // Classe de teste para exemplificar o uso da API e classe auxiliar criada
	public static void main (String[] args) {
		OpWeatherAPI wStation = new OpWeatherAPI("01dc0885a94ac05dd3185df11da3d3fc");
		System.out.println("| Exemplos  ========================================================= |");
		System.out.println("Usu�rio: Boa noite Homer");
		System.out.println("Homer: Boa noite, "  + wStation.boaNoite());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usu�rio: Bom dia Homer");
		System.out.println("Homer: Bom dia, "  + wStation.bomDia());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usu�rio: Homer qual a previs�o para o dia 2?");
		System.out.println("Homer: " + wStation.previsaoDia(2));
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usu�rio: Homer vai chover amanh� ?");
		System.out.println("Homer: " + wStation.choverAmanha());
		System.out.println("-----------------------------------------------------------------------");
		System.out.println("Usu�rio: Homer quando o sol se p�e ?");
		System.out.println("Homer: " + wStation.tempoDeSol());
		System.out.println("-----------------------------------------------------------------------");
			
	}
	
}
