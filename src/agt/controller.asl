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

//Se a lista est� vazia, retorna o objeto mais pr�ximo
lessDiffY(TargetObj, [], Diff, Obj, Return):- Return=Obj.
//Se o objeto atual da lista � o mesmo que est� sendo pesquisado, pula
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (TargetName==Name) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferen�a entre esses objetos for maior ou igual a diferen�a j� encontrada entre outros objetos, passa pro pr�ximo
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetY + Y)/2) & (Diff1 >= Diff) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferen�a entre esses objetos for menor do que a diferen�a j� encontrada entre outros objetos, salva ela como diferen�a e os novos dados do objeto
lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetY + Y)/2) & (Diff1 < Diff) & lessDiffY(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff1, objectRepresentation(Name,C,X,Y,L), Return).

//Se a lista est� vazia, retorna o objeto mais pr�ximo
lessDiffX(TargetObj, [], Diff, Obj, Return):- Return=Obj.
//Se o objeto atual da lista � o mesmo que est� sendo pesquisado, pula
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (TargetName==Name) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferen�a entre esses objetos for maior ou igual a diferen�a j� encontrada entre outros objetos, passa pro pr�ximo
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetX + X)/2) & (Diff1 >= Diff) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff, Obj, Return).
//Se a diferen�a entre esses objetos for menor do que a diferen�a j� encontrada entre outros objetos, salva ela como diferen�a e os novos dados do objeto
lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], Diff, Obj, Return):- (Diff1 = (TargetX + X)/2) & (Diff1 < Diff) & lessDiffX(objectRepresentation(TargetName,TargetC,TargetX,TargetY,TargetL), RestOfTheList, Diff1, objectRepresentation(Name,C,X,Y,L), Return).

//Se o primeiro valor for menor que o segundo, o primeiro objeto est� � esquerda do segundo
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X<X2 & Loc="esquerda".
//Se o primeiro valor for maior que o segundo, o primeiro objeto est� � direita do segundo
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X>X2 & Loc="direita".
//Se for igual, est�o no mesmo lugar (bem dif�cil de acontecer)
leftOrRight(objectRepresentation(_,_,X,_,_),objectRepresentation(_,_,X2,_,_),Loc):- X==X2 & Loc="igual".

//Se n�o encontrou nenhum objeto com o mesmo nome na lista devolve true
isNewObject(Obj, [], Resp):- Resp=true.
//Se encontrou um objeto com o mesmo nome na lista devolve false
isNewObject(Obj, [objectRepresentation(Obj1,_,_,_,_)|RestOfTheList], Resp):- Obj==Obj1 & Resp=false.
//Se n�o tem o mesmo nome que o objeto que est� sendo procurado, passa para o pr�ximo
isNewObject(Obj, [objectRepresentation(Obj1,_,_,_,_)|RestOfTheList], Resp):- Obj\==Obj1 & isNewObject(Obj, RestOfTheList, Resp).

//Recebe a solicita��o para deletar os objetos que tem Status same
deleteSame(List,NewList):- deleteSame(List,[],NewList).
//Se a lista est� vazia devolve dentro do NewList o que estava em Temp
deleteSame([], Temp, NewList) :- NewList=Temp.
//Se a lista estiver com erro devolve o erro
deleteSame([obj(erro)|RestOfTheList],Temp, NewList) :- deleteSame([],[obj(erro)],NewList).
//Se o objeto est� com status same, ignora ele
deleteSame([obj(_,_,same)|RestOfTheList],Temp, NewList) :- deleteSame(RestOfTheList,Temp,NewList).
//Se � um status diferente de same, guarda junto na lista Temp
deleteSame([Obj|RestOfTheList],Temp, NewList) :- .concat([Obj], Temp, T) & deleteSame(RestOfTheList,T,NewList).

//!getSpecificObject([param("object-name", "pessoa")],R).

//!getObjects(Response).

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

+!changedPlace(Response)
	: lastObjects(InitialList)
<-
	.print("Solicitacao recebida: changedPlace");
	informObjects(NewList);
	.print("InitialList");
	.print(InitialList);
	.print("NewList");
	.print(NewList);
	!searchMembers(InitialList, NewList, [], Resp);//Percorre a lista da imagem inicial para ver se algum objeto mudou de lugar ou desapareceu e salva um resumo do que encontrou
	!checkNewObjects(NewList, InitialList, Resp, Summary);//Percorre a lista da segunda imagem em busca de objetos que n�o estavam na primeira imagem e tamb�m exclui da lista os objetos com status=same
	.print("Summary");
	.print(Summary);
	?deleteSame(Summary,NewSummary); // Deleta os objetos com status same
	.print("NewSummary");
	.print(NewSummary);
	-lastObjects(_);// Deleta da base de cren�as a informa��o da imagem antiga
	!createResponse(NewSummary, "", Response);// Com base no resumo criado, monta a resposta que ser� enviada para o usu�rio
	+lastObjects(NewList);// Salva a informa��o da nova imagem na base de cren�as.
	.
+!changedPlace(Response)
<-
	.print("Solicitacao recebida: changedPlace");
	Response="Desculpe, no momento eu nao tenho nenhuma informacao previa do ambiente para comparar.";
	.

+!createResponse([], "", Response)
<-
	Response = "Nenhum objeto mudou de lugar.";
	.
+!createResponse([], Temp, Response)
<-
	Response = Temp;
	.
+!createResponse([obj(erro)|RestOfTheList], Temp, Response)// Se houver erro, cria a resposta avisando que houve erro
<-
	T="Desculpe-me, houve um erro e nao consegui verificar";
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)// Com base no resumo criado, monta a resposta que ser� enviada para o usu�rio
	: (Status==disappeared)
<-
	.concat(Temp, "e o objeto ", Obj, " nao foi localizado.", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==disappeared)
<-
	.concat(Temp, "O objeto ", Obj, " nao foi localizado, ", T);
	!createResponse(RestOfTheList, T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)
	: (Status==modified)
<-
	.concat(Temp, "e o objeto ", Obj, " agora esta ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==modified)
<-
	.concat(Temp, "O objeto ", Obj, " agora esta ",Loc, ", ", T);
	!createResponse(RestOfTheList, T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)
	: (Status==new)
<-
	.concat(Temp, "e o objeto ", Obj, " agora foi localizado e esta ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==new)
<-
	.concat(Temp, "O objeto ", Obj, " agora foi localizado e esta",Loc, ", ", T);
	!createResponse(RestOfTheList, T, Response);
	.


+!checkNewObjects([], InitialList, Summary, Response)  //Devolve a lista criada 
<-
	Response=Summary;
	.
+!checkNewObjects([objectRepresentation("Erro")|RestOfTheList], InitialList, Summary, Response) //Se a lista estiver com erro devolve o erro
<-
	.concat([obj(erro)], Summary, S);
	!checkNewObjects([], InitialList, S, Response);
	.
+!checkNewObjects([objectRepresentation(Obj,Conf,CenterX,CenterY,Loc)|RestOfTheList], InitialList, Summary, Response) //Percorre a lista da segunda imagem em busca de objetos que n�o estavam na primeira imagem
	: isNewObject(Obj, InitialList, Resp) & (Resp==true)
<-
	.concat([obj(Obj, Loc, new)], Summary, S)
	!checkNewObjects(RestOfTheList, InitialList, S, Response);
	.
+!checkNewObjects([objectRepresentation(Obj,Conf,CenterX,CenterY,Loc)|RestOfTheList], InitialList, Summary, Response)
<-
	!checkNewObjects(RestOfTheList, InitialList, Summary, Response);
	.
	
+!searchMembers([], NewList, Summary, Response)
<-
	Response=Summary;
	.
+!searchMembers([objectRepresentation(Obj,Conf,CenterX,CenterY,Loc)|RestOfTheList], NewList, Summary, Response) //Percorre a lista da imagem inicial para ver se algum objeto mudou de lugar ou desapareceu e salva um resumo do que encontrou
<-
	!isTheLocationModified(Obj, Loc, NewList, Resp); // Verifica se a localiza��o foi modificada e cria um objeto do tipo obj(Obj, Loc, Status)
	.concat([Resp], Summary, S); //Summary=[obj(Obj, Loc, Status)], Status = disappeared/same/modified
	!searchMembers(RestOfTheList, NewList, S, Response);
	.
+!searchMembers([objectRepresentation("Erro")|RestOfTheList], NewList, Summary, Response) //Se a lista estiver com erro devolve o erro
<-
	.concat([obj(erro)], Summary, S);
	!searchMembers([], NewList, S, Response);
	.


+!isTheLocationModified(Obj, Loc, [], Resp)
<-
	Resp=obj(Obj, Loc, disappeared);
	.
+!isTheLocationModified(Obj, Loc, [objectRepresentation(Obj2,Conf,CenterX,CenterY,Loc2)|RestOfTheList], Resp) // Verifica se a localiza��o foi modificada
	: (Obj \== Obj2)
<-
	!isTheLocationModified(Obj, Loc, RestOfTheList, Resp);
	.
+!isTheLocationModified(Obj, Loc, [objectRepresentation("Erro")|RestOfTheList], Resp) //Se a lista estiver com erro devolve o erro
<-
	Resp=obj(erro);
	.
+!isTheLocationModified(Obj, Loc, [objectRepresentation(Obj2,Conf,CenterX,CenterY,Loc2)|RestOfTheList], Resp)
	: (Obj == Obj2) & (Loc == Loc2)
<-
	Resp=obj(Obj, Loc2, same);
	.
+!isTheLocationModified(Obj, Loc, [objectRepresentation(Obj2,Conf,CenterX,CenterY,Loc2)|RestOfTheList], Resp)
	: (Obj == Obj2) & (Loc \== Loc2)
<-
	Resp=obj(Obj, Loc2, modified);
	.


 +!locateObject([], List, Response) // Se n�o veio par�metros responde que n�o sabe oq procurar
<- 
	.print("Nao entendi qual objeto devo procurar");
	Response = "Desculpe, nao entendi qual objeto devo procurar.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se n�o � o par�metro esperado, chama o plano novamente pra ver o pr�ximo par�metro
	: (Key \== "object-name")
<- 
	.print("Outro parametro: ", Key);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado est� com status de erro retornado pelo artefato, informa que houve erro
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e nao consegui verificar";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado est� com status de indefinido retornado pela regra, informa que n�o conseguiu localizar
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " nao localizado na imagem ");
    .concat("Desculpe, nao consegui localizar o objeto ", Value, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se identificou na imagem apenas o objeto procurado, informa a localiza��o dele
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length == 1
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " esta localizado", ObjectLocation, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se encontrou outros objetos al�m do objeto procurado, informa a rela��o dele com outros objetos (no m�ximo 2)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length > 1
<- 
	.print("mais de um objeto");
	!getClosestObjects(Value, List, RelationList);
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " esta localizado", ObjectLocation, ".", Temp);
    .print(RelationList);
	!createRelationString(Value, List, RelationList, Temp, Response);	
    .
   
+!createRelationString(Value, List, [objectRepresentation(Name,_,X,Y,_)|[]], Temp, RelationString) // Adiciona a �ltima frase na resposta que vai ser enviada pro usu�rio
	: getObj(Value, List, Obj) & leftOrRight(Obj,objectRepresentation(Name,_,X,Y,_),Loc)
<-
	.print("E a ",Loc,  " do objeto ", Name, ".");
    .concat(Temp, " E a ",Loc,  " do objeto ", Name, ".", RelationString);   
    .
+!createRelationString(Value, List, [objectRepresentation(Name,_,X,Y,_)|RestOfTheList], Temp, RelationString) // Adiciona a frase de rela��o entre objetos na resposta
	: getObj(Value, List, Obj) & leftOrRight(Obj,objectRepresentation(Name,_,X,Y,_),Loc)
<-
	.print("A ",Loc,  " do objeto ", Name, ".");
    .concat(Temp, " A ",Loc,  " do objeto ", Name, ".", NewTemp);
    !createRelationString(Value, List, RestOfTheList, NewTemp, RelationString);    
    .


+!getClosestObjects(Name, List, RelationList) // se identificou menos de 3 objetos, retira o objeto que est� sendo procurado da lista e devolve os outros dois
	: getObj(Name, List, Obj) & .length(List,Length) & Length <= 3 
<- 
	.delete(Obj,List,RelationList).
    
+!getClosestObjects(Name, List, RelationList) // Pega os dois objetos "mais pr�ximos" e devolve apenas os dois em uma lista 
	: getObj(Name, List, Obj) & .length(List,Length) & Length > 3 
<- 
	.delete(Obj,List,L);
	!getClosestX(Obj,L,ObjX);
	.delete(ObjX,L,NewL);
	!getClosestY(Obj,NewL,ObjY);
	.concat([ObjX],[ObjY],RelationList);
	.
	
+!getClosestX(Obj,L,ObjX) // busca o objeto horizontalmente "mais pr�ximo" 
	: lessDiffX(Obj, L, 10, Objr, Return)
<-
	ObjX=Return.
	
+!getClosestY(Obj,L,ObjY) // busca o objeto verticalmente "mais pr�ximo" 
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

+!kqml_received(Sender,question,changed_place,MsgId)
	<-	!changedPlace(Response);
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