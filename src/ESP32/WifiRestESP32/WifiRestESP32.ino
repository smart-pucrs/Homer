#include "WiFi.h"
#include "aREST.h"
#include "DHT.h"
#define LightPin 33
#define THpin 32
#define DHTTYPE DHT11

// Configuração e inicialização do Rest
aREST rest = aREST();
WiFiServer server(80);
 
const char* ssid = "NOME_DA_REDE"; // Nome da rede wifi (inserir)
const char* password =  "SENHA_REDE"; // Senha do wifi (inserir)

DHT dht(THpin, DHTTYPE); // Define o pino e o tipo de sensor DHT

void setup() {
 
  Serial.begin(115200); // Inicializa o console da IDE com o ESP32
  dht.begin(); // Inicializa a biblioteca do Sensor DHT
  pinMode(LightPin, INPUT_PULLUP); // Configuração do pino do sensor

  // Configura informações do Rest
  rest.set_id("001");
  rest.set_name("Sensor");
  rest.function("checkLight", checkLight);
  rest.function("checkTemp", checkTemp);
  rest.function("checkHum", checkHum);
  
  // Conecta no Wifi
  WiFi.begin(ssid, password); 
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  // Mostra o IP da placa para fazer a conexão com o Homer
  Serial.println("WiFi connected with IP: "); 
  Serial.println(WiFi.localIP());
  
  server.begin();
}
 
void loop() { // Mantem a placa como servidor
  WiFiClient client = server.available();
  if (client) {
    while(!client.available()){
      delay(5);
    }
    rest.handle(client);
  }
}

int checkLight(String command){ //Função que checa o sensor e retorna seu estado (Luz)
  int L =digitalRead(LightPin);
  if(L == 1){
    Serial.print(" Value: "); Serial.print(L); Serial.print(" |");
    Serial.println(" Light is OFF |");
  } else {
    Serial.print(" Value: "); Serial.print(L); Serial.print(" |");
    Serial.println(" Ligh is ON |");
  }
  return L;
}

int checkTemp(String command){ //Função que checa o sensor e retorna seu estado (Temperatura)
  float t = dht.readTemperature() + 0.5;
  Serial.print(" Temperature: "); Serial.println(t);
  return (int)t;
}

int checkHum(String command){ //Função que checa o sensor e retorna seu estado (Humidade)
  float h = dht.readHumidity() + 0.5;
  Serial.print(" Humidity: "); Serial.println(h);
  return (int)h;
}
