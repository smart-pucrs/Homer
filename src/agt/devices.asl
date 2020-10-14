+!turnOnTheLight([], Response)
<-
	Response = "Desculpe-me, nao compreendi de qual comodo devo ligar a luz";
	.
+!turnOnTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	turnOnTheLight(Value, Status); //Status = lightStatus(Comodo, Status)
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
	.concat("Ok, a luz do comodo ", Room, " agora esta ligada", Response);
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Off")
<-
	.concat("Nao consegui ligar a luz do comodo ", Room, Response);	
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu nao consegui verificar o status da luz do comodo ", Room, Response);
	.

+!checkIfLit(lightStatus(Room, Status), Response)
	: (Status == "Not implemented")
<-

	.concat("Em breve serei capaz de ligar a luz do comodo ", Room, Response);
	.

+!turnOffTheLight([], Response)
<-
	Response = "Desculpe-me, nao compreendi de qual comodo devo desligar a luz";
	.
+!turnOffTheLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	turnOffTheLight(Value, Status); //Status = lightStatus(Comodo, Status)
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
	.concat("Ok, a luz do comodo ", Room, " agora esta desligada", Response);
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "On")
<-
	.concat("Nao consegui desligar a luz do comodo ", Room, Response);	
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu nao consegui verificar o status da luz do comodo ", Room, Response);
	.

+!checkIfTheLightIsOff(lightStatus(Room, Status), Response)
	: (Status == "Not implemented")
<-

	.concat("Em breve serei capaz de desligar a luz do comodo ", Room, Response);
	.

+!checkLight([], Response)
<-
	Response = "Desculpe-me, nao compreendi de qual comodo devo verificar";
	.
+!checkLight([param(Key, Value)|RestOfTheList], Response)
	: (Key == "room")
<-
	checkAllLights(LightsStatus); //LightsStatus = [lightStatus(Comodo, Status)]
	!checkLightStatus(LightsStatus, Value, Response);
	.
+!checkLight([param(Key, Value)|RestOfTheList], Response)
	: (Key \== "room")
<-
	!checkLight(RestOfTheList, Response);
	.

+!checkLightStatus([], RequestedRoom, Response)
<-
	.concat("Desculpe-me, eu nao consegui verificar o status da luz do comodo ", RequestedRoom, Response) ;
	.
+!checkLightStatus([lightStatus(Room, Status)], RequestedRoom, Response)
	: (Status == "Erro")
<-
	.concat("Desculpe-me, houve um erro e eu nao consegui verificar o status da luz do comodo ", RequestedRoom, Response);
	.
+!checkLightStatus([lightStatus(Room, Status)], RequestedRoom, Response)
	: (Status == "Not implemented")
<-
	.concat("Em breve serei capaz de lhe informar o status da luz do comodo ", RequestedRoom, Response);
	.
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Room \== RequestedRoom)
<-
	!checkLightStatus(RestOfTheList, RequestedRoom, Response);
	.	
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Status == "On") & (Room == RequestedRoom)
<-
	.concat("A luz do comodo ", Room, " esta ligada", Response);
	.
+!checkLightStatus([lightStatus(Room, Status)|RestOfTheList], RequestedRoom, Response)
	: (Status == "Off") & (Room == RequestedRoom)
<-
	.concat("A luz do comodo ", Room, " esta desligada", Response);
	.	

+!checkAllLights(Response)
<-
	checkAllLights(LightsStatus); //LightsStatus = [lightStatus(Comodo, Status)]
	!checkAllLightsStatus(LightsStatus, Response);
	.

/*	
//=========================TODO============================
	
+!checkAllLightsStatus([lightStatus(Room, Status)|RestOfTheList], Response)
	: (Status == "On")
<-
	.concat("A luz do comodo ", Room, " esta ligada", Response);
	.
+!checkAllLightsStatus([lightStatus(Room, Status)|RestOfTheList], Response)
	: (Status == "Off")
<-
	.concat("A luz do comodo ", Room, " esta desligada", Response);	
	.
//=====================================================
*/
+!checkAllLightsStatus([lightStatus(_,GeneralStatus)], Response)
	: (GeneralStatus == "Erro")
<-
	Response = "Desculpe-me, houve um erro e eu nao consegui verificar o status das luzes";
	.

+!checkAllLightsStatus([lightStatus(_,GeneralStatus)], Response)
	: (GeneralStatus == "Not implemented")
<-
	Response = "Em breve serei capaz de lhe informar o status das luzes";
	.

+!checkAllLightsStatus([lightStatus(_,GeneralStatus)], Response)
<-
	Response = "Erro: " + GeneralStatus;
	.


+!kqml_received(Sender,question,turn_on_the_light(Params),MsgId)
	<-	!turnOnTheLight(Params, Response);
		.send(Sender,assert,Response).
		
+!kqml_received(Sender,question,turn_off_the_light(Params),MsgId)
	<-	!turnOffTheLight(Params, Response);
		.send(Sender,assert,Response).
		
+!kqml_received(Sender,question,check_light(Params),MsgId)
	<-	!checkLight(Params, Response);
		.send(Sender,assert,Response).		

+!kqml_received(Sender,question,check_all_lights,MsgId)
	<-	!checkAllLights(Response);
		.send(Sender,assert,Response).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }