package homer.objectsLocation;


import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.google.cloud.translate.Translate;
import com.google.cloud.translate.TranslateOptions;
import com.google.cloud.translate.Translation;
import com.google.cloud.vision.v1.AnnotateImageRequest;
import com.google.cloud.vision.v1.AnnotateImageResponse;
import com.google.cloud.vision.v1.BatchAnnotateImagesResponse;
import com.google.cloud.vision.v1.Feature;
import com.google.cloud.vision.v1.Feature.Type;
import com.google.cloud.vision.v1.Image;
import com.google.cloud.vision.v1.ImageAnnotatorClient;
import com.google.cloud.vision.v1.LocalizedObjectAnnotation;
import com.google.protobuf.ByteString;


public class CloudVision {
	public static List<ObjectRepresentation> detectLocalizedObjects()
	        throws Exception, IOException {
		System.out.format("|======Teste======|%n");
		  List<ObjectRepresentation> returnObjectArr = new ArrayList<>();
		  
		  // Configuracao de conexao com API de traducao
		  Translate translate = TranslateOptions.getDefaultInstance().getService(); 

		  // Configuracao para a API de deteccao
	      List<AnnotateImageRequest> requests = new ArrayList<>();
	      

	      ByteArrayInputStream photo = PersonalWebCam.takePhoto();
	      
//	      ByteString imgBytes = ByteString.readFrom(new FileInputStream(inputPath));
	      ByteString imgBytes = ByteString.readFrom(photo);

	      Image img = Image.newBuilder().setContent(imgBytes).build();
	      AnnotateImageRequest request =
	          AnnotateImageRequest.newBuilder()
	              .addFeatures(Feature.newBuilder().setType(Type.OBJECT_LOCALIZATION))
	              .setImage(img)
	              .build();
	      requests.add(request);
	      
	      System.out.format("Making request for Vision API...%n");
	      // Envia a request para a API
	      try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
	        BatchAnnotateImagesResponse response = client.batchAnnotateImages(requests);
	        List<AnnotateImageResponse> responses = response.getResponsesList();
	        System.out.format("Done!%n");
	       
	        
	        // Mostra e converte os resultados
	        String name = "";
	        for (AnnotateImageResponse res : responses) {
	        
	        	System.out.format("      #Results#    %n");
	        	System.out.format("Objects: %d%n", res.getLocalizedObjectAnnotationsList().size()); 
	       	String[] names = new String[res.getLocalizedObjectAnnotationsList().size()];
	       	 for (int i =0 ; i < names.length; i++) {
	       		 names[i] = "";
	       	 }
	       	 int nObj = 0;
	       	 
	          for (LocalizedObjectAnnotation entity : res.getLocalizedObjectAnnotationsList()) {
	            
	            double[][] objBoundCords  = wrapCords(entity.getBoundingPoly().getNormalizedVerticesList().toString());
	            
	            Translation translation = translate.translate( entity.getName(), // Especificacoes da traducao
	            	     Translate.TranslateOption.sourceLanguage("en"),
	            	     Translate.TranslateOption.targetLanguage("pt"),
	            	           Translate.TranslateOption.model("base"));
			       String Tname = translation.getTranslatedText().toLowerCase(); // Traduz o nome do objeto
			       
			       names[nObj] = Tname; 
			       nObj++;
			       
			       // Conta os objetos iguais
			       int n = 0;
			       for(int i = 0 ; i < names.length; i++) {
			       	if(names[i].equals(Tname)) {
			       		n++;
			       	}
			       }
			       
			        // Muda o nome de objetos iguais
			       if(n > 1) {
			       	name = Tname + " " + String.valueOf(n);
			       } else {
			       	name = Tname;
			       }
			       
			       ObjectRepresentation obj = new ObjectRepresentation(name, entity.getScore(), objBoundCords); //Cria o objeto com seus respectivos valores
			       returnObjectArr.add(obj);         
	          }
	          System.out.format("Drawing result in output.jpg...%n"); 
	          (new DrawImagesThread(res.getLocalizedObjectAnnotationsList())).start();
//	          setDrawImages(Paths.get(outputPath), res.getLocalizedObjectAnnotationsList());
					
	        }
	        System.out.format("|=================|%n");		      
	      }
		return returnObjectArr;
	    }
	
	// Funcao para formatar as cordenadas em array
	public static double[][] wrapCords(String cords) {
		double[][] objBoundCords = new double[4][2];
		double x1, y1, x2, y2, x3, y3, x4, y4;
		String newCords = cords.replace('[', ' ').replace(']', ' ').replaceAll("\n", "").replaceAll(" ", "");

		String cord1 = newCords.substring(0, newCords.indexOf(",")); // x1 e y1
		newCords = newCords.replaceFirst(cord1, "").replaceFirst(",", "");
		if (!cord1.substring(0, 1).contains("x")) {
			x1 = 0.001;
			y1 = Double.parseDouble(cord1.replaceAll("y:", ""));
		} else {
			x1 = Double.parseDouble(cord1.substring(0, cord1.indexOf("y")).replaceAll("x:", ""));
			y1 = Double.parseDouble(cord1.replaceAll("x:" + String.valueOf(x1), "").replaceAll("y:", ""));
		}

		String cord2 = newCords.substring(0, newCords.indexOf(",")); // x2 e y2
		newCords = newCords.replaceFirst(cord2, "").replaceFirst(",", "");
		if (!cord2.substring(0, 1).contains("x")) {
			x2 = 0.999;
			y2 = Double.parseDouble(cord2.replaceAll("y:", ""));
		} else {
			x2 = Double.parseDouble(cord2.substring(0, cord2.indexOf("y")).replaceAll("x:", ""));
			y2 = Double.parseDouble(cord2.replaceAll("x:" + String.valueOf(x2), "").replaceAll("y:", ""));
		}

		String cord3 = newCords.substring(0, newCords.indexOf(",")); // x3 e y3
		newCords = newCords.replaceFirst(cord3, "").replaceFirst(",", "");
		if (!cord3.substring(0, 1).contains("x")) {
			x3 = 0.999;
			y3 = Double.parseDouble(cord3.replaceAll("y:", ""));
		} else {
			x3 = Double.parseDouble(cord3.substring(0, cord2.indexOf("y")).replaceAll("x:", ""));
			y3 = Double.parseDouble(cord3.replaceAll("x:" + String.valueOf(x3), "").replaceAll("y:", ""));
		}

		String cord4 = newCords; // x4 e y4
		if (!cord4.substring(0, 1).contains("x")) {
			x4 = 0.001;
			y4 = Double.parseDouble(cord4.replaceAll("y:", ""));
		} else {
			x4 = Double.parseDouble(cord4.substring(0, cord4.indexOf("y")).replaceAll("x:", ""));
			y4 = Double.parseDouble(cord4.replaceAll("x:" + String.valueOf(x4), "").replaceAll("y:", ""));
		}

		objBoundCords[0][0] = x1;
		objBoundCords[0][1] = y1;
		objBoundCords[1][0] = x2;
		objBoundCords[1][1] = y2;
		objBoundCords[2][0] = x3;
		objBoundCords[2][1] = y3;
		objBoundCords[3][0] = x4;
		objBoundCords[3][1] = y4;

		return objBoundCords;
	}
}