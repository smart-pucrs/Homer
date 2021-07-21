//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getLocation(Value, [], ObjectLocation) :- ObjectLocation="indefinido".
//Se houve erro ao buscar os objetos, devolva "erro".
getLocation(Value, [objectRepresentation(Status)], ObjectLocation) :- (Status == "Erro") & ObjectLocation=Status.
//Se o Value for igual ao Nome, devolva a localizacao
getLocation(Value, [objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- .substring(Nome,Value) & .print("---------------- Substring: ") & .print(.substring(Nome,Value)) & .print(Localizacao) & ObjectLocation=Localizacao.
//Se o Value for diferente do Nome, verifique o proximo objeto 
getLocation(Value, [objectRepresentation(Nome,_,_,_,Localizacao)|RestOfTheList], ObjectLocation) :- not .substring(Nome,Value) & getLocation(Value, RestOfTheList, ObjectLocation).

//Se a lista terminar sem encontrar nenhum objeto igual, devolva "indefinido".
getObj(Value, [], Obj) :- ObjectLocation="indefinido".
//Se o Value for igual ao Nome, devolva o objeto
getObj(Value, [objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao)|RestOfTheList], Obj) :- .substring(Nome,Value) & Obj=objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao).
//Se o Value for diferente do Nome, verifique o proximo objeto 
getObj(Value, [objectRepresentation(Nome, Confidence, CenterX, CenterY, Localizacao)|RestOfTheList], Obj) :- not .substring(Nome,Value) & .print("---------------- Substring:false ") & getObj(Value, RestOfTheList, Obj).

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

//Se não encontrou nenhum objeto com o mesmo nome na lista devolve true
isNewObject(Obj, [], Resp):- Resp=true.
//Se encontrou um objeto com o mesmo nome na lista devolve false
isNewObject(Obj, [objectRepresentation(Obj1,_,_,_,_)|RestOfTheList], Resp):- Obj==Obj1 & Resp=false.
//Se não tem o mesmo nome que o objeto que está sendo procurado, passa para o próximo
isNewObject(Obj, [objectRepresentation(Obj1,_,_,_,_)|RestOfTheList], Resp):- Obj\==Obj1 & isNewObject(Obj, RestOfTheList, Resp).

//Recebe a solicitação para deletar os objetos que tem Status same
deleteSame(List,NewList):- deleteSame(List,[],NewList).
//Se a lista está vazia devolve dentro do NewList o que estava em Temp
deleteSame([], Temp, NewList) :- NewList=Temp.
//Se a lista estiver com erro devolve o erro
deleteSame([obj(erro)|RestOfTheList],Temp, NewList) :- deleteSame([],[obj(erro)],NewList).
//Se o objeto está com status same, ignora ele
deleteSame([obj(_,_,same)|RestOfTheList],Temp, NewList) :- deleteSame(RestOfTheList,Temp,NewList).
//Se é um status diferente de same, guarda junto na lista Temp
deleteSame([Obj|RestOfTheList],Temp, NewList) :- .concat([Obj], Temp, T) & deleteSame(RestOfTheList,T,NewList).

//Devolve a quantidade de objetos que tem com aquele nome
howManySimilar(TargetName, [], I, Resp):- Resp=I.
//Se os objetos tem o mesmo nome, incrementa o contador
howManySimilar(TargetName, [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], I, Resp) :- (TargetName==Name) & (J=I+1) & howManySimilar(TargetName, RestOfTheList, J, Resp).
//Se os objetos não tem o mesmo nome, passa para o próximo
howManySimilar(TargetName, [objectRepresentation(Name,C,X,Y,L)|RestOfTheList], I, Resp) :- (TargetName\==Name) & howManySimilar(TargetName, RestOfTheList, I, Resp).

//!getSpecificObject([param("object-name", "pessoa")],R).

//!getObjects(Response).
//!start.
//
//+!start
//<- 
//	 
//	!createResponse([obj("copos","  a frente",modified)], "", Response);
//	.concat([objectRepresentation("pessoa","0.9114741",0.5429375000000001,0.629640235,"  a frente"),objectRepresentation("celular","0.8556559",0.30895625,0.552859215," 8 graus a esquerda"),objectRepresentation("pessoa","0.9114741",0.5429375000000001,0.629640235,"  a frente"),objectRepresentation("janela","0.70355695",0.34507889,0.3008662897," 7 graus a esquerda"),objectRepresentation("janela","0.80355695",0.32507889,0.3108662897," 8 graus a esquerda")], List);
//	+lastObjects(List);
//	!changedPlace(Response);
//	.print(Response);
//	!numberSimilar(List, Resp);
//	.

+!numberSimilar(List, Resp) //Numera os objetos que tem o mesmo nome
<-
	!getNumber(List, List, [], Return); // Cria uma lista com o nome dos objetos e a quantidade de vezes que eles aparecem no formato [qtd(Name, Qtd)]
	!changeNames(List, Return, [], Resp);// Cria uma nova lista com os nomes alterados acrescentando um número na frente do nome do objeto
	.
+!getNumber([], List, NewList, Resp) //Devolve a lista com a quantidade de vezes que cada nome de objeto se repete
<-
	Resp=NewList;
	.print("Numbered List: ", Resp);
	.
+!getNumber([objectRepresentation(Name,C,X,Y,L)|RestOfTheList], List, NewList, Resp) // Se já tem aquele nome na lista, passa para o próximo
	: .member(qtd(Name, Qtd), NewList)
<-
	!getNumber(RestOfTheList, List, NewList, Resp);
	.
+!getNumber([objectRepresentation(Name,C,X,Y,L)|RestOfTheList], List, NewList, Resp) // verifica quantas vezes o nome de objeto se repete e salva na lista 
	: howManySimilar(Name, List, 0, Qtd)
<-
	.concat(NewList,[qtd(Name, Qtd)], T);
	!getNumber(RestOfTheList, List, T, Resp);
	.
+!changeNames([], List, Temp, Resp) // Devolve a lista com os nomes alterados ex: 1pessoa
<-
	Resp=Temp;
	.
+!changeNames([objectRepresentation(Name,C,X,Y,L)|RestOfTheList], List, Temp, Resp)//Coloca um número na frente do objeto e decrementa o número salvo na lista para que o próximo objeto com o mesmo nome fique com um número diferente
	: .member(qtd(Name, Qtd), List)
<-
	.concat(Qtd, Name, N);
	.print("N: ", N);
	.delete(qtd(Name, Qtd),List,NL);
	.print("NL: ", NL);
	.concat([qtd(Name, Qtd-1)],NL,NNL);
	.print("NNL: ", NNL);
	.concat(Temp,[objectRepresentation(N,C,X,Y,L)],T);
	.print("T: ", T);
	!changeNames(RestOfTheList, NNL, T, Resp);
	.


+!getObjects(Params, Response)
	: true
<-
	.print("Solicitacao recebida: getObjects");
	!informObjects(List);
	!getRoom(Params, Room);
	!generateResponse(Room, List, Response);
	.print(Response);
	.

	
+!getSpecificObject(Params, Response)
	: true
<-
	.print("Solicitação recebida: getSpecificObject");
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
	.print("Solicitação recebida: changedPlace");
	!numberSimilar(InitialList, InitialListNumbered);
	informObjects(NewList);	
	!numberSimilar(NewList, NewListNumbered);
	.print("InitialListNumbered");
	.print(InitialListNumbered);
	.print("NewListNumbered");
	.print(NewListNumbered);
	!searchMembers(InitialListNumbered, NewListNumbered, [], Resp);//Percorre a lista da imagem inicial para ver se algum objeto mudou de lugar ou desapareceu e salva um resumo do que encontrou
	!checkNewObjects(NewListNumbered, InitialListNumbered, Resp, Summary);//Percorre a lista da segunda imagem em busca de objetos que não estavam na primeira imagem e também exclui da lista os objetos com status=same
	.print("Summary");
	.print(Summary);
	?deleteSame(Summary,NewSummary); // Deleta os objetos com status same
	.print("NewSummary");
	.print(NewSummary);
	-lastObjects(_);// Deleta da base de crenças a informação da imagem antiga
	!createResponse(NewSummary, "", Response);// Com base no resumo criado, monta a resposta que será enviada para o usuário
	+lastObjects(NewList);// Salva a informação da nova imagem na base de crenças.
	.
+!changedPlace(Response)
<-
	.print("Solicitação recebida: changedPlace");
	Response="Desculpe, no momento eu nao tenho nenhuma informacao previa do ambiente para comparar.";
	.

+!getRoom([], Room)
<-
	Room=false;
	.
+!getRoom([param(Key, Value)|RestOfTheList], Room)
	: (Key \== "room")
<-
	!getRoom(RestOfTheList, Room);
	.
+!getRoom([param(Key, Value)|RestOfTheList], Room)
	: (Key == "room")
<-
	Room = Value;
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
	T="Desculpe-me, houve um erro e nao consegui verificar. Por favor, solicite novamente.";
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], "", Response)// Com base no resumo criado, monta a resposta que será enviada para o usuário
	: (Status==disappeared)
<-
	.delete(0, Obj, O);
	.concat("O objeto ", O, " não foi localizado. Por favor, solicite novamente.", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)
	: (Status==disappeared)
<-
	.delete(0, Obj, O);
	.concat(Temp, "e o objeto ", O, " não foi localizado. Por favor, solicite novamente.", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==disappeared)
<-
	.delete(0, Obj, O);
	.concat(Temp, "O objeto ", O, " não foi localizado, ", T);
	!createResponse(RestOfTheList, T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], "", Response)
	: (Status==modified)
<-
	.delete(0, Obj, O);
	.concat("O objeto ", O, " agora esta ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)
	: (Status==modified)
<-
	.delete(0, Obj, O);
	.concat(Temp, "e o objeto ", O, " agora esta ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==modified)
<-
	.delete(0, Obj, O);
	.concat(Temp, "O objeto ", O, " agora esta ",Loc, ", ", T);
	!createResponse(RestOfTheList, T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], "", Response)
	: (Status==new)
<-
	.delete(0, Obj, O);
	.concat("O objeto ", O, " agora foi localizado e está ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|[]], Temp, Response)
	: (Status==new)
<-
	.delete(0, Obj, O);
	.concat(Temp, "e o objeto ", O, " agora foi localizado e está ",Loc, ".", T);
	!createResponse([], T, Response);
	.
+!createResponse([obj(Obj, Loc, Status)|RestOfTheList], Temp, Response)
	: (Status==new)
<-
	.delete(0, Obj, O);
	.concat(Temp, "O objeto ", O, " agora foi localizado e está",Loc, ", ", T);
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
+!checkNewObjects([objectRepresentation(Obj,Conf,CenterX,CenterY,Loc)|RestOfTheList], InitialList, Summary, Response) //Percorre a lista da segunda imagem em busca de objetos que não estavam na primeira imagem
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
	!isTheLocationModified(Obj, Loc, NewList, Resp); // Verifica se a localização foi modificada e cria um objeto do tipo obj(Obj, Loc, Status)
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
+!isTheLocationModified(Obj, Loc, [objectRepresentation(Obj2,Conf,CenterX,CenterY,Loc2)|RestOfTheList], Resp) // Verifica se a localização foi modificada
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


 +!locateObject([], List, Response) // Se não veio parâmetros responde que não sabe oq procurar
<- 
	.print("Nao entendi qual objeto devo procurar. Por favor, repita a solicitação. ");
	Response = "Desculpe, não entendi qual objeto devo procurar. Por favor, repita a solicitação.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se não é o parâmetro esperado, chama o plano novamente pra ver o próximo parâmetro
	: (Key \== "object-name")
<- 
	.print("Outro parametro: ", Key);
	.print("-------- List: ")
    .print(List);
	!locateObject(RestOfTheList, List, Response)
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado está com status de erro retornado pelo artefato, informa que houve erro
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "Erro")
<- 
	.print("Erro ao localizar o objeto ", Value);
    Response = "Desculpe-me, houve um erro e não consegui verificar. Por favor, repita a solicitação.";
    .
 +!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se o objeto procurado está com status de indefinido retornado pela regra, informa que não conseguiu localizar
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & (ObjectLocation == "indefinido")
<- 	
	.print("Objeto ", Value, " não localizado na imagem ");
    .concat("Desculpe, não consegui localizar o objeto ", Value, ". Por favor, repita a solicitação.", Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se identificou na imagem apenas o objeto procurado, informa a localização dele
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length == 1
<- 
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " está localizado", ObjectLocation, Response);
    .
+!locateObject([param(Key, Value)|RestOfTheList], List, Response) // Se encontrou outros objetos além do objeto procurado, informa a relação dele com outros objetos (no máximo 2)
	: (Key == "object-name") & getLocation(Value, List, ObjectLocation) & .length(List,Length) & Length > 1
<- 
	.print("mais de um objeto");
	!getClosestObjects(Value, List, RelationList);
	.print("Objeto ", Value, " localizado: ", ObjectLocation);
    .concat("O objeto ", Value, " está localizado", ObjectLocation, ".", Temp);
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

+!generateResponse(Room, List, Response) // when the room was not informed
	: (Room == false)
<-
	Response = "Desculpe-me, não compreendi de qual cômodo devo verificar os objetos. Por favor, tente novamente.";
	.
+!generateResponse(Room, List, Response) // when there are more than one object
	: .length(List,Length) & Length > 1
<-
	.concat("Eu encontrei ", Length, " objetos no cômodo ", Room, ", ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	.print(FinalList);
	!completingResponse(FinalList, Temp, Response); // assembles the response to send to the user based on FinalList
	.
+!generateResponse(Room, List, Response)// when there are only one object
	: .length(List,Length) & Length == 1
<-
	.concat("Eu encontrei no cômodo ", Room, " ", Temp);
	!dismemberItems(List, [], FinalList); // create a list in the format [obj (Name, Count)] where Count is the number of occurrences of a given object 
	.print(FinalList);
	!completingResponse(FinalList, Temp, Response); // assembles the response to send to the user based on FinalList
	.
+!generateResponse(Room, List, Response)// when there are no objects
	: .length(List,Length) & Length < 1
<-
	.concat("Eu não encontrei nenhum objeto no cômodo ", Room, ". Por favor, tente novamente", Response);
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
	Response = "Desculpe-me, houve um erro e nao consegui verificar. Por favor, repita a solicitação.";
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



+!kqml_received(Sender,question,get_objects(Params),MsgId)
	<-	!getObjects(Params, Response);
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