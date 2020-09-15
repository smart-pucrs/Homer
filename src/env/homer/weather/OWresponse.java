package homer.weather;

import java.util.ArrayList;

public class OWresponse { // Classe com informações de retorno da API
	private Current current;
	private Daily[] daily = new Daily[8];
	private Hourly[] hourly =  new Hourly[23];
	
	public Current getCurrent() {
		return current;
	}
	
	public ArrayList<Daily> getDaily() {
		ArrayList<Daily> days = new ArrayList<>();
		for(Daily day: daily) {
			days.add(day);
		}
		return days;
	}
	
	public ArrayList<Hourly> getHourly() {
		ArrayList<Hourly> hours = new ArrayList<>();
		for(Hourly hour: hourly) {
			hours.add(hour);
		}
		return hours;
	}
	
	/* Classes auxiliares contidas dentro de cada tipo de previsão (atual, dias, horas) =========================== */
	private class Weather {
		private int id;
		private String main, description;
		public int getId() {
			return id;
		}
		public String getMain() {
			return main;
		}
		public String getDesc() {
			return description;
		}
		@Override
		public String toString() {
			return "W [id=" + id + ", main=" + main + ", description=" + description + "] ";
		}
	}
	
	private class Temp {
		private double morn, day, eve, night, min, max;
		public double getMorn() { return morn; }
		public double getDay() { return day; }
		public double getEve() { return eve; }
		public double getNight() { return night; }
		public double getMin() { return min; }
		public double getMax() { return max; }
		
		@Override
		public String toString() {
			return "Temp [morn=" + morn + ", day=" + day + ", eve=" + eve + ", night=" + night + ", min=" + min
					+ ", max=" + max + "]";
		}

		
	}
	
	private class Feels_like {
			private double morn, day, eve, night;
			public double getMorn() { return morn; }
			public double getDay() { return day; }
			public double getEve() {	 return eve; }
			public double getNight() { return night;}
			
			@Override
			public String toString() {
				return "Feels_Like [morn=" + morn + ", day=" + day + ", eve=" + eve + ", night=" + night + "]";
			}
		}
	
	// Classes para cada funcionalidade da API
	/* Classe do tempo atual =============================================================================== */
		public class Current {  
		private double temp, feels_like ;
		private int sunrise, sunset, pressure, humidity;
		private Weather weather[] = new Weather[10];
				
		public double getTemp() { return temp; }
		public double getFeelsLike() {return feels_like; }
		public int getPressure() {return pressure; }
		public int getHumidity() {return humidity; }
		public int getSunrise() { return sunrise; }
		public int getSunset() { return sunset; }
		public ArrayList<String> getWeather() { 
			ArrayList<String> wts = new ArrayList<>();
			for(Weather wt : weather) {
				wts.add(wt.getDesc());
			}
			return wts;
		}
		
		@Override
		public String toString() {
			String weathers = "";
			for (int i = 0; i < weather.length; i++) {
				if (weather[i] != null) { weathers += weather[i]; }
			}
			return "Current [temp=" + temp + ", feels_like=" + feels_like + ", sunrise="  + sunrise +
					", sunset=" + sunset + ", pressure=" + pressure + ", humidity=" + humidity + "] | " + weathers ;
		}	
	}
	
	/* Classe do tempo diario  =============================================================================== */
	public class Daily {
		private int dt, sunrise, sunset, pressure, humidity; 
		private double pop;
		private Temp temp;
		private Feels_like feels_like;
		private Weather weather[] = new Weather[10];
		
		public int getDt() { return dt; }
		public int getSunrise() { return sunrise; }
		public int getSunset() { return sunset; }
		public int getPressure() { return pressure; }
		public int getHumidty() { return humidity; }
		public double getPop() { return pop; }
		public double getTemp() {
			return temp.getDay();
		}
		public double getTemp( String tag) {
			double result = 0.0;
			switch (tag) {
			case "morn" : result = temp.getMorn(); break;
			case "day" : result = temp.getDay(); break;
			case "eve" : result = temp.getEve();	break;
			case "night" : result = temp.getNight(); break;
			}
			return result;
		}
		public double[] getMinMax() {
			double[] mm = new  double[2];
			mm[0] = temp.getMin(); mm[1] = temp.getMax();
			return mm;
		}
		public double getFeels_LIke() {
			return feels_like.getDay();
		}
		public double getFeels_LIke(String tag) {
			double result = 0.0;
			switch (tag) {
			case "morn" : result = feels_like.getMorn(); break;
			case "day" : result =feels_like.getDay(); break;
			case "eve" : result = feels_like.getEve();	break;
			case "night" : result = feels_like.getNight(); break;
			}
			return result;
		}
		public ArrayList<String> getWeather() { 
			ArrayList<String> wts = new ArrayList<>();
			for(Weather wt : weather) {
				wts.add(wt.getDesc());
			}
			return wts;
		}
		public boolean hasRain() { 
			boolean rain = false;
			int id = 0;
			for(Weather wt : weather) {
				id = wt.getId();
				if( id >= 500 && id <= 531 || id < 321 ) {
					rain = true;
				}
			}
			return rain;
		}
		
		@Override
		public String toString() {
			String weathers = "";
			for (int i = 0; i < weather.length; i++) {
				if (weather[i] != null) { weathers += weather[i]; }
			}
			return "Daily [dt=" + dt + ", sunrise=" + sunrise + ", sunset=" + sunset + ", pressure=" + pressure
					+ ", humidty=" + humidity + ", pop=" + pop + ", temp=" + temp + ", feels_like=" + feels_like + "] | " + weathers;
		}
	}
	
	// Classe do tempo por hora ==============================================================//
	public class Hourly {
		private int dt, pressure, humidity; 
		private double pop, temp,feels_like;
		private Weather weather[] = new Weather[10];
		
		public int getDt() { return dt; }
		public int getPressure() { return pressure; }
		public int getHumidty() { return humidity; }
		public double getPop() { return pop; }
		public double getTemp() { return temp;}
		public ArrayList<String> getWeather() { 
			ArrayList<String> wts = new ArrayList<>();
			for(Weather wt : weather) {
				wts.add(wt.getDesc());
			}
			return wts;
		}
		
		public boolean hasRain() {
			boolean rain = false;
			int id = 0;
			for(Weather wt : weather) {
				id = wt.getId();
				if( id >= 500 && id <= 531 || id < 321 ) {
					rain = true;
				}
			}
			return rain;
		}
		
		@Override
		public String toString() {
			String weathers = "";
			for (int i = 0; i < weather.length; i++) {
				if (weather[i] != null) { weathers += weather[i]; }
			}
			return "Hourly [dt=" + dt + ", pressure=" + pressure + ", humidity=" + humidity + ", pop=" + pop + ", temp="
					+ temp + ", feels_like=" + feels_like + "] | " + weathers;
		}
		
		
		
	} 
	
}


