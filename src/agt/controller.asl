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
	: true
<-
	reply("Desculpe, não reconheço essa intenção");
	.
	
+!hello
    : True
<-
    .print("Localize o objeto Food");
    locateObjects("Food");
    .

{ include("$jacamoJar/templates/common-cartago.asl") }
{ include("$jacamoJar/templates/common-moise.asl") }