package homer;

import java.awt.Dimension;
import java.awt.image.RenderedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;

import com.github.sarxos.webcam.Webcam;
import com.github.sarxos.webcam.WebcamResolution;

public class PersonalWebCam {
	
	private static Dimension defaultDimension;
	private static Webcam webcam;
	private static String outputPath = "C:/Users/Juliana/Desktop/Pictures_webcam/testeWebcam.jpg";
	
	static ByteArrayInputStream takePhoto(){
		inicializa();
		System.out.println("Ligando Webcam");
		webcam.open();
		ByteArrayOutputStream buff = new ByteArrayOutputStream();
		System.out.println("Capturando imagem");
		RenderedImage img = webcam.getImage();
		try {
			ImageIO.write(img, "jpg", new File(outputPath));//Salva na pasta do pc
			ImageIO.write(img, "jpg", buff);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		byte[] bytes = buff.toByteArray();			
		ByteArrayInputStream is = new ByteArrayInputStream(bytes);
		System.out.println("Desligando Webcam");
		webcam.close();
		return is;
		
	}
	
	private static void inicializa() {
		try {
			defaultDimension = WebcamResolution.VGA.getSize();
			webcam = Webcam.getDefault();
			webcam.setViewSize(defaultDimension);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
