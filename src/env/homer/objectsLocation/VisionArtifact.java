package homer.objectsLocation;

import java.util.ArrayList;
import java.util.List;

import cartago.*;
import jason.asSyntax.ASSyntax;
import jason.asSyntax.Literal;

public class VisionArtifact extends Artifact {
	void init() {
		System.out.println("init VisionArtifact");
	}
	
	@OPERATION
	void informObjects(OpFeedbackParam<Literal[]> objectNames) {
		try {
			System.out.println("Chamando CloudVision.detectLocalizedObjects");
			List<Object> localizedObjects = new ArrayList<Object>();
			try {
				List<ObjectRepresentation> returnObjectArr = CloudVision.detectLocalizedObjects();
				for (ObjectRepresentation objectRepresentation : returnObjectArr) {
					// objectRepresentation(nome, confidence, center, localizacao)
					Literal l = ASSyntax.createLiteral("objectRepresentation", ASSyntax.createString(objectRepresentation.getName()));
					l.addTerm(ASSyntax.createString(objectRepresentation.getConf()));
					l.addTerm(ASSyntax.createString(objectRepresentation.objCenter()));
					l.addTerm(ASSyntax.createString(objectRepresentation.getDegrees()));
					localizedObjects.add(l);
				}			
				objectNames.set(localizedObjects.toArray(new Literal[localizedObjects.size()]));				
			} catch (Exception e) {
				System.out.println("%n%n========================ERRO==========================%n");
				System.out.println("Erro ao detectar objetos: ");
				System.out.println(e);
				System.out.println("%n======================================================%n%n");
				Literal l = ASSyntax.createLiteral("objectRepresentation", ASSyntax.createString("Erro"));
				localizedObjects.add(l);
				objectNames.set(localizedObjects.toArray(new Literal[localizedObjects.size()]));
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}