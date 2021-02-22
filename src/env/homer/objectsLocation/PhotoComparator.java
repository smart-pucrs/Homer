package homer.objectsLocation;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

public class PhotoComparator {
		
	private static double distance = 0.2;
	private List<ObjectRepresentation> notFound = new ArrayList<>(); // Objetos n�o encontrados
	private List<ObjectRepresentation> added    = new ArrayList<>(); // Objetos adicionados
	private List<ObjectRepresentation> moved    = new ArrayList<>(); // Objetos que mudaram de lugar
	private List<ObjectRepresentation> correct  = new ArrayList<>(); // Objetos que est�o no lugar
	private List<ObjectRepresentation> photo1   = new ArrayList<>(); // Recebe lista de objetos na posi��o original
	private List<ObjectRepresentation> photo2   = new ArrayList<>(); // Recebe lista de objetos a serem comparados
		
	public PhotoComparator(List<ObjectRepresentation> photo1, List<ObjectRepresentation> photo2) { // construtor
		this.photo1 = photo1;
		this.photo2 = photo2;
		// print(photo1);
		// print(photo2);
	}

	public void Compare() { // compara a foto original com a �ltima
		System.out.println("\n COMPARANDO\n");
		
		boolean ObjectNotFound = true;
		
		added = photo2;
		for (ObjectRepresentation p1 : photo1) {
			for (ObjectRepresentation p2 : added) {
				if (p1.getName().equals(p2.getName())) {
					// System.out.println(p1.getName() + " igual " + p2.getName());
					
					double [] center1 = p1.getObjCenter(); // Centro de um objeto da foto original
					double [] center2 = p2.getObjCenter(); // Centro de um objeto da foto a ser testada

					double right = center1[0] + distance;
					double left  = center1[0] - distance;
					double up    = center1[1] + distance;
					double down  = center1[1] - distance;
										
					double x2 = center2[0];
					double y2 = center2[1];
					
					if (x2 > right || x2 < left || y2 > up || y2 < down) { // se est� fora do lugar (pela dist�ncia definida)
						// System.out.println("O objeto " + p2.getName() + " est� fora do lugar!");
						// System.out.println("Estava � " + p1.getDegrees() + " e agora est� em " + p2.getDegrees());
						moved.add(p2);	
					} else { // est� no lugar
						correct.add(p2);
					}
					added.remove(p2);
					ObjectNotFound = false;
					break;					
				} else {
					ObjectNotFound = true;
				}
			}
			if(ObjectNotFound){
				// System.out.println("O objeto " + p1.getName() + " n�o est� na segunda foto!");
				notFound.add(p1);
			}
		}	  
	}
	
	public void print(List<ObjectRepresentation> photo) {
		System.out.println("<<< Imprimindo objetos...>>>");
		for(ObjectRepresentation p1 : photo) {
			System.out.println(p1.getName() + " ");
		}			
	}
	
	public boolean getComparator(String obj) {
		for(ObjectRepresentation c1 : correct) {
			if(c1.getName().equals(obj)) {
				return true;
			}
		}
		return false;
	}
	
	public List<ObjectRepresentation> getNotFound(){
		return notFound;
	}
	
	public List<ObjectRepresentation> getAdded(){
		return added;
	}
	
	public List<ObjectRepresentation> getMoved(){
		return moved;
	}
	
	public List<ObjectRepresentation> getCorrect(){
		return correct;
	}
	
	public static void main(String[] args) throws IOException, Exception {
	//	String diretorioImagem1 = "C:\\Users\\Usuario\\Desktop\\Working\\11_IC_trabalhando\\imagens\\img1.jpeg";
	//	String diretorioImagem2 = "C:\\Users\\Usuario\\Desktop\\Working\\11_IC_trabalhando\\imagens\\img2.jpeg";
		
		// Tira foto s� da segunda imagem, a primeira cont�m a posi��o padr�o dos objetos a serem comparados
				
		List<ObjectRepresentation> photo1 = CloudVision.detectLocalizedObjects();		
		List<ObjectRepresentation> photo2 = CloudVision.detectLocalizedObjects();
		
		PhotoComparator t1 = new PhotoComparator(photo1, photo2);
		t1.Compare();
		
		List<ObjectRepresentation> objectsNotFound = t1.getNotFound();		
		List<ObjectRepresentation> addedObjects    = t1.getAdded();
		List<ObjectRepresentation> movedObjects    = t1.getMoved();
		List<ObjectRepresentation> correctObjects  = t1.getCorrect();
		
		System.out.println("\n RESULTADO");
		
		System.out.println("Ser� que esse objeto est� no lugar? " + t1.getComparator("monitor de computador"));
		
		System.out.println("\n" + correctObjects.size() + " objetos est�o no lugar!");
		for(ObjectRepresentation obj : correctObjects) {
			System.out.println(obj.getName());
		}
		
		System.out.println("\n" + movedObjects.size() + " objetos (dos que ficaram na foto) est�o fora do lugar!");
		for(ObjectRepresentation obj : movedObjects) {
			System.out.println(obj.getName());
		}
		
		System.out.println("\n" + objectsNotFound.size() + " objetos faltando!");
		for(ObjectRepresentation obj : objectsNotFound) {
			System.out.println(obj.getName());
		}
		
		System.out.println("\n" + addedObjects.size() + " objetos novos!");	
		for(ObjectRepresentation obj : addedObjects) {
			System.out.println(obj.getName());
		}
	}
}
