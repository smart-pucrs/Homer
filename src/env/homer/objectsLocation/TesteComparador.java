package homer.objectsLocation;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class TesteComparador {
	
	public static void main(String[] args) throws IOException, Exception {
		String diretorioImagem1 = "Coloque/o/diretorio/da/imagem1/aqui";
		String diretorioImagem2 = "Coloque/o/diretorio/da/imagem2/aqui";
		
		 List<ObjectRepresentation> foto1 = CloudVision2.detectLocalizedObjects(diretorioImagem1);
		 List<ObjectRepresentation> foto2 = CloudVision2.detectLocalizedObjects(diretorioImagem2);
		 
		 System.out.println(foraDoLugar(foto1, foto2));
	}
	
	public static boolean foraDoLugar(List<ObjectRepresentation> foto1, List<ObjectRepresentation> foto2 ) {
		//IMPLEMENAR: retorna true se algum objeto esta fora do lugar por pelo menos 30%
		return true;
	}
}