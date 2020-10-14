//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getLocation(Value, [], ObjectLocation) :- ObjectLocation="indefinido".
//Se houve erro ao buscar os objetos, devolva "erro".
getLocation(Value, [objectRepresentation(Status)], ObjectLocation) :- (Status == "Erro") & ObjectLocation=Status.
//Se o Value for igual ao Nome, devolva a localizacao
getLocation(Value, [objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value == Nome) & ObjectLocation=Localizacao.
//Se o Value for diferente do Nome, verifique o proximo objeto 
getLocation(Value, [objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value \== Nome) & getLocation(Value, RestOfTheList, ObjectLocation).

+!getObjects(Response)
	: true
<-
	.print("Solicitacao recebida: getObjects");
	!informObjects(List);
	!generateResponse(List, Response);
	.
	
+!getSpecificObject(Params, Response)
	: true
<-
	.print("Solicitacao recebida: getSpecificObject");
	!informObjects(List);
	!locateObject(Params, List, Response);
	.

+!informObjects(List)
	: true
<- 
	.print("Informe os objetos da imagem");
    informObjects(List); //[objectRepresentation(nome, confidence, center, localizacao)] or [objectRepresentation("Erro")]
    .print(List);
    .

 +!locateObject([], List, Response)
<- 
	.print("Nao entendi qual objeto devo procurar");
	Response = "Desculpe, nao entendi qual objeto devo procurar.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key \== "object-name")
<- 
	.print("Outro parametro: ", Key);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e nao consegui verificar";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " nao localizado na imagem ");
    .concat("Desculpe, nao consegui localizar o objeto ", Value, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation)
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " esta localizado ", ObjectLocation, Response);
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
	Response = "Eu nao encontrei nenhum objeto.";
	.concat("Eu nao encontrei nenhum objeto.", Response);
	.


+!dismemberItems([], Temp, Response)
<-
	Response = Temp;
	.
+!dismemberItems([objectRepresentation(Status)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	Response = "Desculpe-me, houve um erro e nao consegui verificar";
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, ", ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, " e ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, ". ", Resp);
	!dismemberItems(RestOfTheList, Resp, Response);
	.


+!kqml_received(Sender,question,get_objects,MsgId)
	<-	!getObjects(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,get_specific_object(Params),MsgId)
	<-	!getSpecificObject(Params, Response);
		.send(Sender,assert,Response).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }