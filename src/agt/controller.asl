//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getLocation(Value, [], ObjectLocation) :- ObjectLocation="indefinido".
//Se houve erro ao buscar os objetos, devolva "erro".
getLocation(Value, [objectRepresentation(Status)], ObjectLocation) :- (Status == "Erro") & ObjectLocation=Status.
//Se o Value for igual ao Nome, devolva a localização
getLocation(Value, [objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value == Nome) & ObjectLocation=Localizacao.
//Se o Value for diferente do Nome, verifique o próximo objeto 
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
	reply("Olá, eu sou seu agente Jason, em que posso lhe ajudar?");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts and Parameters")
<-
	.print("Os contextos e parâmetros serão listados a seguir.");
	!printContexts(Contexts);
	!printParameters(Params);
	reply("Olá, eu sou seu agente Jason, recebi seus contextos e parâmetros");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Call With Contexts")
<-
	.print("Os contextos serão listados a seguir.");
	!printContexts(Contexts);
	reply("Olá, eu sou seu agente Jason, recebi seus contextos");
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get Objects In The Scene")
<-
	.print("Chatbot solicitando informação sobre os objetos na imagem.")
	!informObjects(List);
	!montarResposta(List, Response);	
	.print("Respondendo para o chatbot: ", Response)
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: (IntentName == "Get specific object")
<-
	.print("Chatbot solicitando localização de objeto.")
	!informObjects(List);
	!locateObject(Params, List, Response)	
	.print("Respondendo para o chatbot: ", Response)
	reply(Response);
	.
	
+!responder(ResponseId, IntentName, Params, Contexts)
	: true
<-
	reply("Desculpe, não reconheço essa intensão");
	.

+!desmembrarItens([], Temp, Response)
<-
	Response = Temp;
	.

+!desmembrarItens([objectRepresentation(Status)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	Response = "Desculpe-me, houve um erro e não consegui verificar";
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, "O objeto ", Nome, " está ", Localizacao, ", ", Resp);	
	!desmembrarItens(RestOfTheList, Resp, Response);
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, "O objeto ", Nome, " está ", Localizacao, " e ", Resp);	
	!desmembrarItens(RestOfTheList, Resp, Response);
	.
+!desmembrarItens([objectRepresentation(Nome,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, "O objeto ", Nome, " está ", Localizacao, ". ", Resp);
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
	Response = "Eu não encontrei nenhum objeto.";
	.concat("Eu não encontrei nenhum objeto.", Response);
	.

 +!locateObject([], List, Response)
<- 
	.print("Não entendi qual objeto devo procurar");
	Response = "Desculpe, não entendi qual objeto devo procurar.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key \== "object-name")
<- 
	.print("Outro parâmetro: ", Key);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e não consegui verificar";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " não localizado na imagem ");
    .concat("Desculpe, não consegui localizar o objeto ", Value, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation)
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " está localizado ", ObjectLocation, Response);
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
