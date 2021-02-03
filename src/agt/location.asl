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
	.print(Response);
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


+!generateResponse(List, Response)// when there are more than one object
	: .length(List,Length) & Length > 1
<-
	.concat("Eu encontrei ", Length, " objetos, ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	!completingResponse(FinalList, Temp, Response); // assembles the response to send to the user based on FinalList
	.
+!generateResponse(List, Response)// when there are only one object
	: .length(List,Length) & Length == 1
<-
	.concat("Eu encontrei ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	!completingResponse(FinalList, Temp, Response); // assembles the response to send to the user based on FinalList
	.
+!generateResponse(List, Response)// when there are no objects
	: .length(List,Length) & Length < 1
<-
	Response = "Eu nao encontrei nenhum objeto.";
	.concat("Eu nao encontrei nenhum objeto.", Response);
	.


+!dismemberItems([], TempList, FinalList)
<-
	FinalList=TempList;
	.
+!dismemberItems([objectRepresentation(Status)|RestOfTheList], TempList, FinalList) // if there was an error, then it returns 
	: .length(RestOfTheList,Length) & Length < 1
<-
	FinalList = [objectRepresentation(Status)];
	.
+!dismemberItems([objectRepresentation(Nome,_,_,_)|RestOfTheList], TempList, FinalList) // if the object is already in the TempList, then delete it from the list and add it again with the incremented Counter
	: .member(obj(Nome, Count),TempList)
<-	
	.delete(obj(Nome, Count),TempList,L);
	.concat(L, [obj(Nome, Count+1)], ListTemp);
	!dismemberItems(RestOfTheList, ListTemp, FinalList);
	.

+!dismemberItems([objectRepresentation(Nome,_,_,_)|RestOfTheList], TempList, FinalList) // if the object is not yet in the list, add
<-
	.concat(TempList, [obj(Nome, 1)], ListTemp);
	!dismemberItems(RestOfTheList, ListTemp, FinalList);
	.


+!completingResponse([objectRepresentation(Status)|RestOfTheList], Temp, Response) // if there was an error, then it returns this message
	: .length(RestOfTheList,Length) & Length < 1
<-
	Response = "Desculpe-me, houve um erro e nao consegui verificar";
	.	
+!completingResponse([], Temp, Response)
<-
	Response = Temp;
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1 & Count == 1
<-
	.concat(Temp, Count," objeto ", Nome, ", ", Resp); // adds in string something like "1 objeto pessoa,"	
	!completingResponse(RestOfTheList, Resp, Response);
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, Count," objetos ", Nome, ", ", Resp);	// adds in string something like "2 objetos pessoa,"
	!completingResponse(RestOfTheList, Resp, Response);
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response) 
	: .length(RestOfTheList,Length) & Length == 1 & Count == 1
<-
	.concat(Temp, Count," objeto ", Nome, " e ", Resp);	// adds in string something like "1 objeto pessoa e"
	!completingResponse(RestOfTheList, Resp, Response);
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response) 
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, Count," objetos ", Nome, " e ", Resp); // adds in string something like "2 objetos pessoa e"
	!completingResponse(RestOfTheList, Resp, Response);
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response) 
	: .length(RestOfTheList,Length) & Length < 1 & Count == 1
<-
	.concat(Temp, Count," objeto ", Nome, ". ", Resp);// adds in string something like "1 objeto pessoa."
	!completingResponse(RestOfTheList, Resp, Response);
	.
+!completingResponse([obj(Nome, Count)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, Count," objetos ", Nome, ". ", Resp); // adds in string something like "2 objetos pessoa."
	!completingResponse(RestOfTheList, Resp, Response);
	.



+!kqml_received(Sender,question,get_objects,MsgId)
	<-	!getObjects(Response);
		.send(Sender,assert,Response).

+!kqml_received(Sender,question,get_specific_object(Params),MsgId)
	<-	!getSpecificObject(Params, Response);
		.send(Sender,assert,Response).



{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }



/*
 * Objects + location
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
 
 */

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }