//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getLocation(Value, [], ObjectLocation) :- ObjectLocation="indefinido".
//Se houve erro ao buscar os objetos, devolva "erro".
getLocation(Value, [objectRepresentation(Status)], ObjectLocation) :- (Status == "Erro") & ObjectLocation=Status.
//Se o Value for igual ao Nome, devolva a localiza��o
getLocation(Value, [objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value == Nome) & ObjectLocation=Localizacao.
//Se o Value for diferente do Nome, verifique o pr�ximo objeto 
getLocation(Value, [objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value \== Nome) & getLocation(Value, RestOfTheList, ObjectLocation).

!hello.

+request(ResponseId, IntentName, Params, Contexts)
	:true
<-
	.print("Recebido request ",IntentName," do Dialog");
	!responder(ResponseId, IntentName, Params, Contexts);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call Jason Agent")
<-
	reply("Ol�, eu sou seu agente Jason, em que posso lhe ajudar?");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts and Parameters")
<-
	.print("Os contextos e par�metros ser�o listados a seguir.");
	!printContexts(Contexts);
	!printParameters(Params);
	reply("Ol�, eu sou seu agente Jason, recebi seus contextos e par�metros");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts")
<-
	.print("Os contextos ser�o listados a seguir.");
	!printContexts(Contexts);
	reply("Ol�, eu sou seu agente Jason, recebi seus contextos");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get Objects In The Scene")
<-
	.print("Chatbot solicitando informa��o sobre os objetos na imagem.");
	!informObjects(List);
	!generateResponse(List, Response);	
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get specific object")
<-
	.print("Chatbot solicitando localiza��o de objeto.");
	!informObjects(List);
	!locateObject(Params, List, Response)	
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Turn On The Light")
<-
	.print("Chatbot solicitando para ligar a luz.");
	!turnOnTheLight(Params, Response);
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Turn Off The Light")
<-
	.print("Chatbot solicitando para desligar a luz.");
	!turnOffTheLight(Params, Response);
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Check Light")
<-
	.print("Chatbot solicitando para verificar status da luz.");
	!checkLight(Params, Response);
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.

+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Check All Lights")
<-
	.print("Chatbot solicitando para verificar status de todas as luzes.");
	!checkAllLights(Response);
	.print("Respondendo para o chatbot: ", Response);
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: true
<-
	reply("Desculpe, n�o reconhe�o essa intens�o");
	.

+!dismemberItems([], Temp, Response)
<-
	Response = Temp;
	.

+!dismemberItems([objectRepresentation(Status)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	Response = "Desculpe-me, houve um erro e n�o consegui verificar";
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, ", ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, " e ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, ". ", Resp);
	!dismemberItems(RestOfTheList, Resp, Response);
	.

+!generateResponse(List, Response)
	: .length(List,Length) & Length > 1
<-
	.concat("Eu encontrei ", Length, " objetos, ", Temp);
	!dismemberItems(List, Temp, Response);
	.
+!generateResponse(List, Response)
	: .length(List,Length) & Length == 1
<-
	.concat("Eu encontrei ", Length, " objeto, ", Temp);
	!dismemberItems(List, Temp, Response);
	.
+!generateResponse(List, Response)
	: .length(List,Length) & Length < 1
<-
	Response = "Eu n�o encontrei nenhum objeto.";
	.concat("Eu n�o encontrei nenhum objeto.", Response);
	.

 +!locateObject([], List, Response)
<- 
	.print("N�o entendi qual objeto devo procurar");
	Response = "Desculpe, n�o entendi qual objeto devo procurar.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key \== "object-name")
<- 
	.print("Outro par�metro: ", Key);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e n�o consegui verificar";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " n�o localizado na imagem ");
    .concat("Desculpe, n�o consegui localizar o objeto ", Value, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation)
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " est� localizado ", ObjectLocation, Response);
    .
    
+!informObjects(List)
	: true
<- 
	.print("Informe os objetos da imagem");
    informObjects(List); //[objectRepresentation(nome, confidence, center, localizacao)] or [objectRepresentation("Erro")]
    .print(List);
    .

+!turnOnTheLight([], Response)
<-
	Response = "Desculpe-me, n�o compreendi de qual c�modo devo ligar a luz";
	.
+!turnOnTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	turnOnTheLight(Value, Status); //Status = lightStatus(C�modo, Status)
	!checkIfLit(Status, Response);
	.
+!turnOnTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key \== "room")
<-
	!turnOnTheLight(RestOfTheList, Response);
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "On")
<-
	.concat("Ok, a luz do c�modo ", Room, " agora est� ligada", Response);
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Off")
<-
	.concat("N�o consegui ligar a luz do c�modo ", Room, Response);	
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu n�o consegui verificar o status da luz do c�modo ", Room, Response);
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Not implemented")
<-

	.concat("Em breve serei capaz de ligar a luz do c�modo ", Room, Response);
	.

+!turnOffTheLight([], Response)
<-
	Response = "Desculpe-me, n�o compreendi de qual c�modo devo desligar a luz";
	.
+!turnOffTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	turnOffTheLight(Value, Status); //Status = lightStatus(C�modo, Status)
	!checkIfTheLightIsOff(Status, Response);
	.
+!turnOffTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key \== "room")
<-
	!turnOffTheLight(RestOfTheList, Response);
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "Off")
<-
	.concat("Ok, a luz do c�modo ", Room, " agora est� desligada", Response);
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "On")
<-
	.concat("N�o consegui desligar a luz do c�modo ", Room, Response);	
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu n�o consegui verificar o status da luz do c�modo ", Room, Response);
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "Not implemented")
<-

	.concat("Em breve serei capaz de desligar a luz do c�modo ", Room, Response);
	.

+!checkLight([], Response)
<-
	Response = "Desculpe-me, n�o compreendi de qual c�modo devo verificar";
	.
+!checkLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	checkAllLights(LightsStatus); //LightsStatus = [lightStatus(C�modo, Status)]
	!checkLightStatus(LightsStatus, Value, Response);
	.
+!checkLight([param(Key, Value)|RestOfTheList], Response)
	: (Key \== "room")
<-
	!checkLight(RestOfTheList, Response);
	.

+!checkLightStatus([], RequestedRoom, Response)
<-
	.concat("Desculpe-me, eu n�o consegui verificar o status da luz do c�modo ", RequestedRoom, Response) ;
	.
+!checkLightStatus([lightStatus(GeneralStatus)], RequestedRoom, Response)
	: (GeneralStatus == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu n�o consegui verificar o status da luz do c�modo ", RequestedRoom, Response);
	.
+!checkLightStatus([lightStatus(GeneralStatus)], RequestedRoom, Response)
	: (GeneralStatus == "Not implemented")
<-
	.concat("Em breve serei capaz de lhe informar o status da luz do c�modo ", RequestedRoom, Response);
	.
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Room \== RequestedRoom)
<-
	!checkLightStatus(RestOfTheList, RequestedRoom, Response);
	.	
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Status == "On") & (Room == RequestedRoom)
<-
	.concat("A luz do c�modo ", Room, " est� ligada", Response);
	.
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Status == "Off") & (Room == RequestedRoom)
<-
	.concat("A luz do c�modo ", Room, " est� desligada", Response);
	.	

+!checkAllLights(Response)
<-
	checkAllLights(LightsStatus); //LightsStatus = [lightStatus(C�modo, Status)]
	!checkAllLightsStatus(LightsStatus, Response);
	.

/*	
//=========================TODO============================
	
+!checkAllLightsStatus([lightStatus(Room, Status)|RestOfTheList], Response)
	: (Status == "On")
<-
	.concat("A luz do c�modo ", Room, " est� ligada", Response);
	.

+!checkAllLightsStatus([lightStatus(Room, Status)|RestOfTheList], Response)
	: (Status == "Off")
<-
	.concat("A luz do c�modo ", Room, " est� desligada", Response);	
	.

//=====================================================
*/
+!checkAllLightsStatus([lightStatus(GeneralStatus)], Response)
	: (GeneralStatus == "Erro")
<-
	Response = "Desculpe-me, houve um erro e eu n�o consegui verificar o status das luzes";
	.

+!checkAllLightsStatus([lightStatus(GeneralStatus)], Response)
	: (GeneralStatus == "Not implemented")
<-
	Response = "Em breve serei capaz de lhe informar o status das luzes";
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

+!hello
    : True
<-
    !informObjects(List);
	!generateResponse(List, Response);
	.print(Response)
    .
    

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }