package homer.objectsLocation;

import java.awt.BasicStroke;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.geom.Path2D;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;

import javax.imageio.ImageIO;

import com.google.cloud.vision.v1.LocalizedObjectAnnotation;

public class DrawImagesThread extends Thread {

	List<LocalizedObjectAnnotation> objs;

	public DrawImagesThread(List<LocalizedObjectAnnotation> objs) {
		super();
		this.objs = objs;
	}

	// Função para localizar aquivos de entrada e saida da imagem
	public void run() {
		try {
			String outputPath = PersonalWebCam.getOutputPath().substring(0, PersonalWebCam.getOutputPath().indexOf(".jpg")) + "-output.jpg"; 
			System.out.println("Executando Thread Assíncrona!");
			File imgtest = new File(PersonalWebCam.getOutputPath());
			FileInputStream imgtd;

			imgtd = new FileInputStream(imgtest);

			BufferedImage img = ImageIO.read(imgtd);
			drawImages(img, objs);
			Path outputP = Paths.get(outputPath);
			ImageIO.write(img, "jpg", outputP.toFile());
			System.out.format("Thread Assíncrona: Done !%n%n");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// Função para desenhar os objetos na imagem
	public static void drawImages(BufferedImage img, List<LocalizedObjectAnnotation> objs) {
		for (LocalizedObjectAnnotation entity : objs) {
			double[][] objBoundCords = CloudVision.wrapCords(entity.getBoundingPoly().getNormalizedVerticesList().toString());
			ObjectRepresentation obj = new ObjectRepresentation(entity.getName(), entity.getScore(), objBoundCords);
			drawImage(img, entity, obj);
		}

	}

	// Função que desenha os contornos dos objetos de acordo com as cordenadas
	public static void drawImage(BufferedImage img, LocalizedObjectAnnotation entity, ObjectRepresentation obj) {
		Graphics2D gfx = img.createGraphics();

		Path2D poly = new Path2D.Double();

		int scaleX = img.getWidth();
		int scaleY = img.getHeight();
		poly.moveTo((obj.getCord(0, 0) * scaleX), (obj.getCord(0, 1) * scaleY));
		for (int i = 1; i < 4; i++) {
			poly.lineTo((obj.getCord(i, 0) * scaleX), (obj.getCord(i, 1) * scaleY));
		}
		poly.closePath();

		if (img.getWidth() > 2000) {
			gfx.setStroke(new BasicStroke(20));
			gfx.setFont(new Font("TimesRoman", Font.PLAIN, 60));
		} else {
			gfx.setStroke(new BasicStroke(2));
		}

		gfx.setColor(new Color(0x00ff00));
		gfx.draw(poly);

		gfx.setColor(new Color(0x000000));
		gfx.drawString(entity.getName(), (float) (obj.getCord(0, 0) * scaleX), (float) (obj.getCord(0, 1) * scaleY));

		drawCenter(gfx, obj, scaleX, scaleY);
	}

	// Função que desenha o centro da imagem
	public static void drawCenter(Graphics2D gfx, ObjectRepresentation obj, int scaleX, int scaleY) {
		double[] xy = obj.getObjCenter();
		Path2D poly2 = new Path2D.Double();

		poly2.moveTo(xy[0] * scaleX - 1.0, xy[1] * scaleY - 1.0);
		poly2.lineTo(xy[0] * scaleX + 1.0, xy[1] * scaleY - 1.0);
		poly2.lineTo(xy[0] * scaleX + 1.0, xy[1] * scaleY + 1.0);
		poly2.lineTo(xy[0] * scaleX - 1.0, xy[1] * scaleY + 1.0);
		poly2.closePath();

		poly2.moveTo(xy[0] * scaleX - 10.0, xy[1] * scaleY - 10.0);
		poly2.lineTo(xy[0] * scaleX + 10.0, xy[1] * scaleY - 10.0);
		poly2.lineTo(xy[0] * scaleX + 10.0, xy[1] * scaleY + 10.0);
		poly2.lineTo(xy[0] * scaleX - 10.0, xy[1] * scaleY + 10.0);
		poly2.closePath();

		gfx.setStroke(new BasicStroke(3));
		gfx.setColor(new Color(0xff0000));
		gfx.draw(poly2);

	}

}