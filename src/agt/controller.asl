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
	.print("Chatbot solicitando informa��o sobre os objetos na imagem.")
	!informObjects(List);
	!montarResposta(List, Response);	
	.print("Respondendo para o chatbot: ", Response)
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get specific object")
<-
	.print("Chatbot solicitando localiza��o de objeto.")
	!informObjects(List);
	!locateObject(Params, List, Response)	
	.print("Respondendo para o chatbot: ", Response)
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: true
<-
	reply("Desculpe, n�o reconhe�o essa intens�o");
	.

+!desmembrarItens([], Temp, Response)
<-
	Response = Temp;
	.

+!desmembrarItens([objectRepresentation(Status)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	Response = "Desculpe-me, houve um erro e n�o consegui verificar";
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, ", ", Resp);	
	!desmembrarItens(RestOfTheList, Resp, Response);
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, " e ", Resp);	
	!desmembrarItens(RestOfTheList, Resp, Response);
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, "O objeto ", Nome, " est� ", Localizacao, ". ", Resp);
	!desmembrarItens(RestOfTheList, Resp, Response);
	.

+!montarResposta(List, Response)
	: .length(List,Length) & Length > 1
<-
	.concat("Eu encontrei ", Length, " objetos, ", Temp);
	!desmembrarItens(List, Temp, Response);
	.
+!montarResposta(List, Response)
	: .length(List,Length) & Length == 1
<-
	.concat("Eu encontrei ", Length, " objeto, ", Temp);
	!desmembrarItens(List, Temp, Response);
	.
+!montarResposta(List, Response)
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
	!montarResposta(List, Response);
	.print(Response)
    .
    

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
