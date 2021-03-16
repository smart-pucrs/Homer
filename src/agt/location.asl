//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getLocation(Value, [], ObjectLocation) :- ObjectLocation="indefinido".
//Se houve erro ao buscar os objetos, devolva "erro".
getLocation(Value, [objectRepresentation(Status)], ObjectLocation) :- (Status == "Erro") & ObjectLocation=Status.
//Se o Value for igual ao Nome, devolva a localizacao
getLocation(Value, [objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value == Nome) & ObjectLocation=Localizacao.
//Se o Value for diferente do Nome, verifique o proximo objeto 
getLocation(Value, [objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- (Value \== Nome) & getLocation(Value, RestOfTheList, ObjectLocation).

//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getObj(Value, [], Obj) :- ObjectLocation="indefinido".
//Se o Value for igual ao Nome, devolva o objeto
getObj(Value, [objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao)|RestOfTheList], Obj) :- (Value == Nome) & Obj=objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao).
//Se o Value for diferente do Nome, verifique o proximo objeto 
getObj(Value, [objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao)|RestOfTheList], Obj) :- (Value \== Nome) & getObj(Value, RestOfTheList, Obj).

//Se a lista está vazia, retorna o objeto mais próximo
lessDiffY(TargetObj, [], Diff, Obj, Return):- Return=Obj.
//Se o objeto atual da lista é o mesmo que está sendo pesquisado, pula
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (TargetName==Name) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferença entre esses objetos for maior ou igual a diferença já encontrada entre outros objetos, passa pro próximo
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetY + Y)/2) & (Diff1 >= Diff) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferença entre esses objetos for menor do que a diferença já encontrada entre outros objetos, salva ela como diferença e os novos dados do objeto
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetY + Y)/2) & (Diff1 < Diff) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff1, objectRepresentation(Name,C,X,Y,L), Return).

//Se a lista está vazia, retorna o objeto mais próximo
lessDiffX(TargetObj, [], Diff, Obj, Return):- Return=Obj.
//Se o objeto atual da lista é o mesmo que está sendo pesquisado, pula
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (TargetName==Name) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferença entre esses objetos for maior ou igual a diferença já encontrada entre outros objetos, passa pro próximo
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetX + X)/2) & (Diff1 >= Diff) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferença entre esses objetos for menor do que a diferença já encontrada entre outros objetos, salva ela como diferença e os novos dados do objeto
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetX + X)/2) & (Diff1 < Diff) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff1, objectRepresentation(Name,C,X,Y,L), Return).

//Se o primeiro valor for menor que o segundo, o primeiro objeto está à esquerda do segundo
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X<X2 & Loc="esquerda".
//Se o primeiro valor for maior que o segundo, o primeiro objeto está à direita do segundo
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X>X2 & Loc="direita".
//Se for igual, estão no mesmo lugar (bem difícil de acontecer)
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X==X2 & Loc="igual".

//!getSpecificObject([param("object-name", "pessoa")],R).

//!getObjects(Response).

+!getObjects(Response)
	: true
<-
	.print("Solicitacao recebida: getObjects");
	!informObjects(List);	
	//!getSpecificObject(params, Resp);
	!generateResponse(List, Response);
	.print(Response);
	.
	
+!getSpecificObject(Params, Response)
	: true
<-
	.print("Solicitacao recebida: getSpecificObject");
	!informObjects(List);
	!locateObject(Params, List, Response);
	.print(Response);
	.

+!informObjects(List)
	: true
<- 
	.print("Informe os objetos da imagem");
	-lastObjects(_);
    informObjects(List); //[objectRepresentation(nome, confidence, centerX, centerY, localizacao)] or [objectRepresentation("Erro")]
    +lastObjects(List);
    .print(List);
    .

 +!locateObject([], List, Response) // Se não veio parâmetros responde que não sabe oq procurar
<- 
	.print("Nao entendi qual objeto devo procurar");
	Response = "Desculpe, nao entendi qual objeto devo procurar.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se não é o parâmetro esperado, chama o plano novamente pra ver o próximo parâmetro
	: (Key \== "object-name")
<- 
	.print("Outro parametro: ", Key);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado está com status de erro retornado pelo artefato, informa que houve erro
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e nao consegui verificar";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado está com status de indefinido retornado pela regra, informa que não conseguiu localizar
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " nao localizado na imagem ");
    .concat("Desculpe, nao consegui localizar o objeto ", Value, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se identificou na imagem apenas o objeto procurado, informa a localização dele
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length == 1
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " esta localizado", ObjectLocation, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se encontrou outros objetos além do objeto procurado, informa a relação dele com outros objetos (no máximo 2)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length > 1
<- 
	.print("mais de um objeto");
	!getClosestObjects(Value, List, RelationList);
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " esta localizado", ObjectLocation, ".", Temp);
    .print(RelationList);
	!createRelationString(Value, List, RelationList, Temp, Response);	
    .
   
+!createRelationString(Value, List, [objectRepresentation(Name,_,X,Y,_)|[]], Temp, RelationString) // Adiciona a última frase na resposta que vai ser enviada pro usuário
	: getObj(Value, List, Obj) & leftOrRight(Obj,objectRepresentation(Name,_,X,Y,_),Loc)
<-
	.print("E a ",Loc,  " do objeto ", Name, ".");
    .concat(Temp, " E a ",Loc,  " do objeto ", Name, ".", RelationString);   
    .
+!createRelationString(Value, List, [objectRepresentation(Name,_,X,Y,_)|RestOfTheList], Temp, RelationString) // Adiciona a frase de relação entre objetos na resposta
	: getObj(Value, List, Obj) & leftOrRight(Obj,objectRepresentation(Name,_,X,Y,_),Loc)
<-
	.print("A ",Loc,  " do objeto ", Name, ".");
    .concat(Temp, " A ",Loc,  " do objeto ", Name, ".", NewTemp);
    !createRelationString(Value, List, RestOfTheList, NewTemp, RelationString);    
    .


+!getClosestObjects(Name, List, RelationList) // se identificou menos de 3 objetos, retira o objeto que está sendo procurado da lista e devolve os outros dois
	: getObj(Name, List, Obj) & .length(List,Length) & Length <= 3 
<- 
	.delete(Obj,List,RelationList).
    
+!getClosestObjects(Name, List, RelationList) // Pega os dois objetos "mais próximos" e devolve apenas os dois em uma lista 
	: getObj(Name, List, Obj) & .length(List,Length) & Length > 3 
<- 
	.delete(Obj,List,L);
	!getClosestX(Obj,L,ObjX);
	.delete(ObjX,L,NewL);
	!getClosestY(Obj,NewL,ObjY);
	.concat([ObjX],[ObjY],RelationList);
	.
	
+!getClosestX(Obj,L,ObjX) // busca o objeto horizontalmente "mais próximo" 
	: lessDiffX(Obj, L, 10, Objr, Return)
<-
	ObjX=Return.
	
+!getClosestY(Obj,L,ObjY) // busca o objeto verticalmente "mais próximo" 
	: lessDiffY(Obj, L, 10, Objr, Return)
<-
	ObjY=Return.


+!generateResponse(List, Response) // when there are more than one object
	: .length(List,Length) & Length > 1
<-
	.concat("Eu encontrei ", Length, " objetos, ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	.print(FinalList);
	!completingResponse(FinalList, Temp, Response); // assembles the response to send to the user based on FinalList
	.
+!generateResponse(List, Response)// when there are only one object
	: .length(List,Length) & Length == 1
<-
	.concat("Eu encontrei ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	.print(FinalList);
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
+!dismemberItems([objectRepresentation(Nome,_,_,_,_)|RestOfTheList], TempList, FinalList) // if the object is already in the TempList, then delete it from the list and add it again with the incremented Counter
	: .member(obj(Nome, Count),TempList)
<-	
	.delete(obj(Nome, Count),TempList,L);
	.concat(L, [obj(Nome, Count+1)], ListTemp);
	!dismemberItems(RestOfTheList, ListTemp, FinalList);
	.

+!dismemberItems([objectRepresentation(Nome,_,_,_,_)|RestOfTheList], TempList, FinalList) // if the object is not yet in the list, add
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
+!dismemberItems([objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length > 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, ", ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length == 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, " e ", Resp);	
	!dismemberItems(RestOfTheList, Resp, Response);
	.
+!dismemberItems([objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], Temp, Response)
	: .length(RestOfTheList,Length) & Length < 1
<-
	.concat(Temp, "O objeto ", Nome, " esta ", Localizacao, ". ", Resp);
	!dismemberItems(RestOfTheList, Resp, Response);
	.
 
 */

// uncomment the include below to have an agent compliant with its organisation
//{ include("$moiseJar/asl/org-obedient.asl") }