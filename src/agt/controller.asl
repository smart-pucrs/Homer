+request(ResponseId, IntentName, Params, Contexts)
	:true
<-
	.print("Recebido request ",IntentName," do Dialog");
	!responder(ResponseId, IntentName, Params, Contexts);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call Jason Agent")
<-
	reply("Ola, eu sou seu agente Jason, em que posso lhe ajudar?");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts and Parameters")
<-
	.print("Os contextos e parametros serao listados a seguir.");
	!printContexts(Contexts);
	!printParameters(Params);
	reply("Ola, eu sou seu agente Jason, recebi seus contextos e parametros");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts")
<-
	.print("Os contextos serao listados a seguir.");
	!printContexts(Contexts);
	reply("Ola, eu sou seu agente Jason, recebi seus contextos");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get Objects In The Scene")
<-
	.print("Chatbot solicitando informacao sobre os objetos na imagem.");
	.send(location1,question,get_objects);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get specific object")
<-
	.print("Chatbot solicitando localizacao de objeto.");
	.send(location1,question,get_specific_object(Params));
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Turn On The Light")
<-
	.print("Chatbot solicitando para ligar a luz.");
	.send(device1,question,turn_on_the_light(Params));
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Turn Off The Light")
<-
	.print("Chatbot solicitando para desligar a luz.");
	.send(device1,question,turn_off_the_light(Params));
	.

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Check Light")
<-
	.print("Chatbot solicitando para verificar status da luz.");
	.send(device1,question,check_light(Params));
	.

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Check All Lights")
<-
	.print("Chatbot solicitando para verificar status de todas as luzes.");
	.send(device1,question,check_all_lights);
	.

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Day Forecast")
<-
	.print("Chatbot solicitando para verificar a previsao do tempo");
	.send(enter1,question,dayForecast(Params));
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Good Night")
<-
	.print("Chatbot dando Boa noite");
	.send(enter1,question,goodNight);
	.
		
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Good Morning")
<-
	.print("Chatbot dando Bom Dia");
	.send(enter1,question,goodMorning);
	.
		
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Tomorrow Forecast")
<-
	.print("Chatbot pedindo previsão para amanhã");
	.send(enter1,question,tomorrowForecast);
	.	
		
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "About Sun")
<-
	.print("Chatbot pedindo informaçãoo sobre os horários do sol");
	.send(enter1,question,aboutSun);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get Current Temperature")
<-
	.print("Chatbot pedindo a temperatura atual");
	.send(enter1,question,currentTemperature);
	.	
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get Current Humidity")
<-
	.print("Chatbot pedindo a umidade atual");
	.send(enter1,question,currentHumidity);
	.	

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Changed Place")
<-
	.print("Chatbot pedindo se algum objeto mudou de lugar");
	.send(location1,question,changed_place);
	.	
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: true
<-
	reply("Desculpe, nao reconheco essa intensao");
	.

+!printInformedObjects([]).
+!printInformedObjects([Item|RestOfTheList])
<-
	.print(Item);//objectRepresentation(nome, confidence, center, localizacao)
	!printInformedObjects(RestOfTheList);
	.

+!printContexts([]).
+!printContexts([Context|List])
<-
	.print(Context);
	!printContexts(List);
	.

+!printParameters([]).
+!printParameters([Param|List])
<-
	.print(Param)
	!printParameters(List)
	.

+!kqml_received(Sender,assert,Response,MsgId)
	<-	.print("Respondendo para o chatbot: ", Response);
		reply(Response).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }