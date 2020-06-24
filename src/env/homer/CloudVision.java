package homer;

import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.geom.Path2D;
import java.awt.image.BufferedImage;
import java.io.*;

import java.nio.file.Path;
import java.nio.file.Paths;

import com.google.cloud.vision.v1.LocalizedObjectAnnotation;
import com.google.cloud.vision.v1.AnnotateImageRequest;
import com.google.cloud.vision.v1.AnnotateImageResponse;
import com.google.cloud.vision.v1.BatchAnnotateImagesResponse;
import com.google.cloud.vision.v1.Feature;
import com.google.cloud.vision.v1.Feature.Type;
import com.google.cloud.vision.v1.Image;
import com.google.cloud.vision.v1.ImageAnnotatorClient;
import com.google.protobuf.ByteString;

public class CloudVision {
	public static void detectLocalizedObjects(String  inputPath, String outputPath, PrintStream out)
	        throws Exception, IOException {
		  out.format("|======Teste======|%n");
		  
	      List<AnnotateImageRequest> requests = new ArrayList<>();

	      ByteString imgBytes = ByteString.readFrom(new FileInputStream(inputPath));

	      Image img = Image.newBuilder().setContent(imgBytes).build();
	      AnnotateImageRequest request =
	          AnnotateImageRequest.newBuilder()
	              .addFeatures(Feature.newBuilder().setType(Type.OBJECT_LOCALIZATION))
	              .setImage(img)
	              .build();
	      requests.add(request);
	      
          out.format("Making request for Vision API...%n");
	      // Envia a request para a API
	      try (ImageAnnotatorClient client = ImageAnnotatorClient.create()) {
	        BatchAnnotateImagesResponse response = client.batchAnnotateImages(requests);
	        List<AnnotateImageResponse> responses = response.getResponsesList();
	        out.format("Done!%n");
	       
	        
	        // Mostra e converte os resultados
	        String name = "";
	        String Lastnames = "";
	        int nObjs = 2;
	        for (AnnotateImageResponse res : responses) {
	        
	         out.format("      #Results#    %n");
	       	 out.format("Objects: %d%n", res.getLocalizedObjectAnnotationsList().size()); 
	        	 
	          for (LocalizedObjectAnnotation entity : res.getLocalizedObjectAnnotationsList()) {
	            
	            double[][] objBoundCords  = wrapCords(entity.getBoundingPoly().getNormalizedVerticesList().toString());
	            
	             // Indica a presença de mais de um objeto igual
	            if(Lastnames.contains(entity.getName())) {
	            	name = entity.getName() + " " + String.valueOf(nObjs);
	            	nObjs++;
	            } else {
	            	name = entity.getName();
	            }
	            Lastnames = Lastnames + entity.getName();
	           
	            ObjectRepresentation obj = new ObjectRepresentation(name, entity.getScore(), objBoundCords); //Cria o objeto com seus respectivos valores
	            
	            out.format("Name: %s%nConfidence: %s%nCordinates: %s%nLocalização: %s%n%n", obj.getName(), 
	            		                                                    String.valueOf(obj.getConf()), 
	            		                                                                  obj.objCenter(),
	            		                                                                obj.getDegrees()); 
	          }
	          
	          	if (!outputPath.toLowerCase().endsWith(".jpg")) { //Confere se a imagem está no formato jpg
	          		System.err.println("outputImagePath must have the file extension 'jpg' !");
	          		System.exit(1);
	          	}
	          	out.format("Drawing result in output.jpg...%n"); 
	          	setDrawImages(Paths.get(inputPath), Paths.get(outputPath), res.getLocalizedObjectAnnotationsList());
	          	out.format("Done !%n%n"); 
	         
	        }
	        out.format("|=================|%n");
	      }
	    }
	
	//Função para formatar as cordenadas em array
	public static double[][] wrapCords(String cords) {  
		double[][] objBoundCords = new double[4][2];
		double x1, y1, x2, y2, x3, y3, x4, y4;
		String newCords = cords.replace('[', ' ')
				               .replace(']', ' ')
				               .replaceAll("\n","")
				               .replaceAll(" ","");
		
		String cord1 = newCords.substring(0,newCords.indexOf(",")); //x1 e y1
		newCords = newCords.replaceFirst(cord1, "").replaceFirst(",", "");
		if(!cord1.substring(0,1).contains("x")) {
			x1 = 0.001;
			y1 = Double.parseDouble(cord1.replaceAll("y:", ""));
		} else {                            
		    x1 = Double.parseDouble(cord1.substring(0,cord1.indexOf("y")).replaceAll("x:", ""));
		    y1 = Double.parseDouble(cord1.replaceAll("x:" + String.valueOf(x1), "").replaceAll("y:", ""));	 
		}
		
		String cord2 = newCords.substring(0,newCords.indexOf(",")); //x2 e y2 
		newCords = newCords.replaceFirst(cord2, "").replaceFirst(",", "");
		if(!cord2.substring(0,1).contains("x")) {
			x2 = 0.999;
			y2 = Double.parseDouble(cord2.replaceAll("y:", ""));
		} else { 
			x2 = Double.parseDouble(cord2.substring(0,cord2.indexOf("y")).replaceAll("x:", ""));
	        y2 = Double.parseDouble(cord2.replaceAll("x:" + String.valueOf(x2), "").replaceAll("y:", ""));
		}
		
		String cord3 = newCords.substring(0,newCords.indexOf(",")); //x3 e y3
		newCords = newCords.replaceFirst(cord3, "").replaceFirst(",", "");
		if(!cord3.substring(0,1).contains("x")) {
			x3 = 0.999;
			y3 = Double.parseDouble(cord3.replaceAll("y:", ""));
		} else { 
			x3 = Double.parseDouble(cord3.substring(0,cord2.indexOf("y")).replaceAll("x:", ""));
	        y3 = Double.parseDouble(cord3.replaceAll("x:" + String.valueOf(x3), "").replaceAll("y:", ""));
		}
		
		String cord4 = newCords; //x4 e y4
		if(!cord4.substring(0,1).contains("x")) {
			x4 = 0.001;
			y4 = Double.parseDouble(cord4.replaceAll("y:", ""));
		} else {
		    x4 = Double.parseDouble(cord4.substring(0,cord4.indexOf("y")).replaceAll("x:", ""));
		    y4 = Double.parseDouble(cord4.replaceAll("x:" + String.valueOf(x4), "").replaceAll("y:", ""));
		}		
	
		objBoundCords[0][0] = x1; objBoundCords[0][1] = y1;
		objBoundCords[1][0] = x2; objBoundCords[1][1] = y2;
		objBoundCords[2][0] = x3; objBoundCords[2][1] = y3;
		objBoundCords[3][0] = x4; objBoundCords[3][1] = y4;
		
		return objBoundCords;
	}

	//Função para localizar aquivos de entrada e saida da imagem
	public static void setDrawImages(Path inputP, Path outputP, List<LocalizedObjectAnnotation> objs) throws IOException{
		 
			  BufferedImage img = ImageIO.read(inputP.toFile());
			  drawImages(img, objs);
			  ImageIO.write(img, "jpg", outputP.toFile());
			
	}
	
	//Função para desenhar os objetos na imagem
	public static void drawImages(BufferedImage img, List<LocalizedObjectAnnotation> objs) {
	     for (LocalizedObjectAnnotation entity : objs) {
	    	 double[][] objBoundCords  = wrapCords(entity.getBoundingPoly().getNormalizedVerticesList().toString());
	    	 ObjectRepresentation obj = new ObjectRepresentation(entity.getName(), entity.getScore(), objBoundCords);
	    	 drawImage(img, entity, obj);
		  }
	     
	}
	
	//Função que desenha os contornos dos objetos de acordo com as cordenadas 
	public static void drawImage(BufferedImage img, LocalizedObjectAnnotation entity, ObjectRepresentation obj) {
		Graphics2D gfx = img.createGraphics();
		
		Path2D poly = new Path2D.Double();
		
		int scaleX = img.getWidth();
		int scaleY = img.getHeight();		
		 poly.moveTo((obj.getCord(0,0)*scaleX), (obj.getCord(0,1)*scaleY));
		 for (int i = 1; i < 4; i++) {
			 poly.lineTo((obj.getCord(i,0)*scaleX), (obj.getCord(i,1)*scaleY));
		 }
		 poly.closePath(); 
	
		  if(img.getWidth()>2000) {
			  gfx.setStroke(new BasicStroke(20));
			  gfx.setFont(new Font("TimesRoman", Font.PLAIN, 60));
		  } else {
			  gfx.setStroke(new BasicStroke(2));
		  }
		  
		  gfx.setColor(new Color(0x00ff00));
		  gfx.draw(poly);
		 
		  gfx.setColor(new Color(0x000000));
		  gfx.drawString(entity.getName(), (float)(obj.getCord(0,0)*scaleX) ,  (float)(obj.getCord(0,1)*scaleY));
		  
		 drawCenter(gfx, obj, scaleX, scaleY); 
	}
	
	//Função que desenha o centro da imagem
	public static void drawCenter(Graphics2D gfx, ObjectRepresentation obj, int scaleX, int scaleY) {
		double[] xy = obj.getObjCenter(); 
		Path2D poly2 = new Path2D.Double();
		
		poly2.moveTo(xy[0]*scaleX-1.0, xy[1]*scaleY-1.0);
		poly2.lineTo(xy[0]*scaleX+1.0, xy[1]*scaleY-1.0);
		poly2.lineTo(xy[0]*scaleX+1.0, xy[1]*scaleY+1.0);
		poly2.lineTo(xy[0]*scaleX-1.0, xy[1]*scaleY+1.0);
		poly2.closePath();
		
		poly2.moveTo(xy[0]*scaleX-10.0, xy[1]*scaleY-10.0);
		poly2.lineTo(xy[0]*scaleX+10.0, xy[1]*scaleY-10.0);
		poly2.lineTo(xy[0]*scaleX+10.0, xy[1]*scaleY+10.0);
		poly2.lineTo(xy[0]*scaleX-10.0, xy[1]*scaleY+10.0);
		poly2.closePath(); 
		
		gfx.setStroke(new BasicStroke(3));
		gfx.setColor(new Color(0xff0000));
		gfx.draw(poly2);
		
	}
}