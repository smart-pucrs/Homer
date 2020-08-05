#include "WiFi.h"
#include "aREST.h"

 //Configuração e inicialização do Rest
aREST rest = aREST();
WiFiServer server(80);
 
const char* ssid = "NOME_DA_REDE"; // Nome da rede wifi (inserir)
const char* password =  "SENHA_DA_REDE"; // Senha do wifi (inserir)

bool Light; // Variavel simuladora do sensor

void setup() {
 
  Serial.begin(115200); // Inicializa o console da IDE com o ESP32

  // Configura informações do Rest
  rest.set_id("001");
  rest.set_name("Sensor");
  rest.variable("Light",&Light); // Indica a variavel Light para ser checada pelo Rest

  Light = true;
  
  WiFi.begin(ssid, password); // Conecta no Wifi
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  
  //Mostra o IP da placa para fazer a conexão com o Homer
  Serial.println("WiFi connected with IP: "); 
  Serial.println(WiFi.localIP());
 
  server.begin();
}
 
void loop() {
  
  WiFiClient client = server.available();
  if (client) {
    while(!client.available()){
      delay(5);
    }
    rest.handle(client);
  }
}