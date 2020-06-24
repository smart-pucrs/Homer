// CArtAgO artifact code for project Homer

package homer;

import java.io.IOException;

import cartago.*;

public class VisionArtifact extends Artifact {
	void init() {
		System.out.println("init VisionArtifact");
	}
	
	@OPERATION
	void locateObjects(String nameObject) {
		try {
			System.out.println("Chamando CloudVision.detectLocalizedObjects");
			String inputPath = "C:/Users/Juliana/Desktop/Pictures_Vision/two_cherries_2-wallpaper-1280x768.jpg";
			String outputPath = "C:/Users/Juliana/Desktop/Pictures_Vision/two_cherries_2-wallpaper-1280x768-output.jpg";
			CloudVision.detectLocalizedObjects(inputPath, outputPath, System.out);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	@OPERATION
	void inc() {
		ObsProperty prop = getObsProperty("count");
		prop.updateValue(prop.intValue()+1);
		signal("tick");
	}
}