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


+!kqml_received(Sender,question,dayForecast(Params),MsgId)
	<-	!dayForecast(Params, Response);
		.send(Sender,assert,Response).

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }