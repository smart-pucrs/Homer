+!dayForecast([], Response)
<-
	Response = "Desculpe-me, nao compreendi de que dia devo verificar a previsao";
	.
+!dayForecast([param(Key, Value)|RestOfTheList], Response)
	: (Key == "day")
<-
	.print(param(Key, Value));
	dayForecast(Value, Response);
	.
+!dayForecast([param(Key, Value)|RestOfTheList], Response)
	: (Key \== "day")
<-
	!dayForecast(RestOfTheList, Response);
	.

+!goodNight(Response)
<-
	goodNight(Response);
	.

+!goodMorning(Response)
<-
	goodMorning(Response);
	.

+!tomorrowForecast(Response)
<-
	tomorrowForecast(Response);
	.

+!aboutSun(Response)
<-
	aboutSun(Response);
	.

+!getCurrentTemperature(Response)
<-
	getCurrentTemperature(Response);
	.

+!getCurrentHumidity(Response)
<-
	getCurrentHumidity(Response);
	.
	
+!kqml_received(Sender,question,dayForecast(Params),MsgId)
	<-	!dayForecast(Params, Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,goodNight,MsgId)
	<-	!goodNight(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,goodMorning,MsgId)
	<-	!goodMorning(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,tomorrowForecast,MsgId)
	<-	!tomorrowForecast(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,aboutSun,MsgId)
	<-	!aboutSun(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,currentTemperature,MsgId)
	<-	!getCurrentTemperature(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,currentHumidity,MsgId)
	<-	!getCurrentHumidity(Response);
		.send(Sender,assert,Response).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }