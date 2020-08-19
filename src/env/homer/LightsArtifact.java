// CArtAgO artifact code for project Homer

package homer;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;

public class LightsArtifact extends Artifact {
	void init(int initialValue) {
		System.out.println("init LightsArtifact");
	}

	@OPERATION
	void checkAllLights(OpFeedbackParam<Literal[]> lightsStatus) { //[lightStatus(Cômodo, Status)]
		System.out.println("Aqui será chamado o CheckLights...");
		List<Object> lightStatusList = new ArrayList<Object>();
		try {
			Literal l = ASSyntax.createLiteral("lightStatus", ASSyntax.createString("Not implemented"));
			lightStatusList.add(l);
			lightsStatus.set(lightStatusList.toArray(new Literal[lightStatusList.size()]));
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao checar status das luzes: ");
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			Literal l = ASSyntax.createLiteral("lightStatus", ASSyntax.createString("Erro"));
			lightStatusList.add(l);
			lightsStatus.set(lightStatusList.toArray(new Literal[lightStatusList.size()]));		
		}
	}
	
	@OPERATION
	void turnOnTheLight(String room, OpFeedbackParam<Literal> lightStatus) { //lightStatus(Cômodo, Status)
		System.out.println("Aqui será chamado o TurnOnTheLight passando o parâmetro " + room);
		try {
			Literal lightStatusResponse = ASSyntax.createLiteral("lightStatus", ASSyntax.createString(room));
			lightStatusResponse.addTerm(ASSyntax.createString("Not implemented"));
			lightStatus.set(lightStatusResponse); //Ex.: lightStatus("quarto", "On") ou lightStatus("sala", "Off")
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao ligar a luz do cômodo: "+ room);
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			Literal lightStatusResponse = ASSyntax.createLiteral("lightStatus", ASSyntax.createString(room));
			lightStatusResponse.addTerm(ASSyntax.createString("Erro"));
			lightStatus.set(lightStatusResponse); 
		}
	}
	
	@OPERATION
	void turnOffTheLight(String room, OpFeedbackParam<Literal> lightStatus) { //lightStatus(Cômodo, Status)
		System.out.println("Aqui será chamado o TurnOffTheLight passando o parâmetro " + room);
		try {
			Literal lightStatusResponse = ASSyntax.createLiteral("lightStatus", ASSyntax.createString(room));
			lightStatusResponse.addTerm(ASSyntax.createString("Not implemented"));
			lightStatus.set(lightStatusResponse);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("%n%n========================ERRO==========================%n");
			System.out.println("Erro ao desligar a luz do cômodo: "+ room);
			System.out.println(e);
			System.out.println("%n======================================================%n%n");
			Literal lightStatusResponse = ASSyntax.createLiteral("lightStatus", ASSyntax.createString(room));
			lightStatusResponse.addTerm(ASSyntax.createString("Erro"));
			lightStatus.set(lightStatusResponse);
		}
	}
}

