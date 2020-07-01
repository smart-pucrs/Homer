!hello.

+request(Req)
	:true
<-
	.print("Recebido request ",Req," do Dialog");
	!responder(Req);
	.
	
+!responder(Req)
	: (Req == "Call Jason Agent")
<-
	reply("Olá, eu sou seu agente Jason, em que posso lhe ajudar?");
	.
+!responder(Req)
	: (Req == "Call With Contexts and Parameters")
<-
	reply("Olá, eu sou seu agente Jason com contexto e parametros, em que posso lhe ajudar AQUIII?");
	.
+!responder(Req)
	: (Req == "Call With Contexts")
<-
	reply("Olá, eu sou seu agente Jason com contexto, em que posso lhe ajudar AQUIII?");
	.
+!responder(Req)
	: (Req == "Get Objects In The Scene")
<-
	.print("Chatbot solicitando informação sobre os objetos na imagem.")
	!informObjects(List);
	!montarResposta(List, Response);	
	.print("Respondendo para o chatbot: ", Response)
	reply(Response);
	.
+!responder(Req)
	: true
<-
	reply("Desculpe, não reconheço essa intenção");
	.

+!desmembrarItens([], Temp, Response)
<-
	Response = Temp;
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
	
+!hello
    : True
<-
    !informObjects(List);
	!montarResposta(List, Response);
	.print(Response)
    .
    
+!locateObject(Obj)
	: true
<- 
	.print("Localize o objeto ", Obj);
    !informObjects(List);
    !printInformedObjects(List);
    .
    
+!informObjects(List)
	: true
<- 
	.print("Informe os objetos da imagem");
    informObjects(List); //[objectRepresentation(nome, confidence, center, localizacao)]
//    !printInformedObjects(List);
    .

+!printInformedObjects([]).
+!printInformedObjects([Item|RestOfTheList])
<-
	.print(Item);//objectRepresentation(nome, confidence, center, localizacao)
	!printInformedObjects(RestOfTheList);
	.

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }
