// CArtAgO artifact code for project Homer

package homer;

import java.awt.image.RenderedImage;
import java.io.IOException;
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
			String outputPath = "C:/Users/Juliana/Desktop/Pictures_webcam/testeWebcam-output.jpg";
			List<ObjectRepresentation> returnObjectArr = CloudVision.detectLocalizedObjects(outputPath, System.out);
			List<Object> localizedObjects = new ArrayList<Object>();
			for (ObjectRepresentation objectRepresentation : returnObjectArr) {
				// objectRepresentation(nome, confidence, center, localizacao)
				Literal l = ASSyntax.createLiteral("objectRepresentation", ASSyntax.createString(objectRepresentation.getName()));
				l.addTerm(ASSyntax.createString(objectRepresentation.getConf()));
				l.addTerm(ASSyntax.createString(objectRepresentation.objCenter()));
				l.addTerm(ASSyntax.createString(objectRepresentation.getDegrees()));
				localizedObjects.add(l);
			}
			
			objectNames.set(localizedObjects.toArray(new Literal[localizedObjects.size()]));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}