package homer;

public class Object {

    public String name;
    public float confidence;
    public double[][] objBoundCords;
    public double x;
    public double y;

    public Object (String name,float confidence,  double[][] objBounds ) {
        this.name = name;
        this.confidence = confidence;
        this.objBoundCords = objBounds;
        this.x = (objBoundCords[1][0] + objBoundCords[0][0])/2.0;
        this.y = (objBoundCords[2][1] + objBoundCords[0][1])/2.0;
        
    }

    public String getName () {
        return name;
    }
    
    public float getConf() {
    	return confidence;
    }

    public Double getCord(int c, int xy) {
    	return objBoundCords[c][xy];
    }
    
    public String AllCords() {
    String cords;
    cords = "x1: " + String.valueOf(objBoundCords[0][0]) + "%n"
          + "y1: " + String.valueOf(objBoundCords[0][1]) + "%n"
          + "x2: " + String.valueOf(objBoundCords[1][0]) + "%n"
          + "y2: " + String.valueOf(objBoundCords[1][1]) + "%n"
          + "x3: " + String.valueOf(objBoundCords[2][0]) + "%n"
          + "y3: " + String.valueOf(objBoundCords[2][1]) + "%n"
          + "x4: " + String.valueOf(objBoundCords[3][0]) + "%n"
          + "y4: " + String.valueOf(objBoundCords[3][1]) + "%n";
    cords = cords.format(cords);
    return cords;	
    }
    
   
    
    public String objCenter() {
    	double centerX = (objBoundCords[1][0] + objBoundCords[0][0])/2.0;
    	double centerY = (objBoundCords[2][1] + objBoundCords[0][1])/2.0;

        String result = "x: " + String.valueOf(centerX) + " # y: " + String.valueOf(centerY);
        
        return result;
    }
    
    public double[] getObjCenter() {
    	double centerX = (objBoundCords[1][0] + objBoundCords[0][0])/2.0;
    	double centerY = (objBoundCords[2][1] + objBoundCords[0][1])/2.0;

        double [] result = {centerX, centerY};
        
        return result;
    }
    
    
    public String getDegrees () {
        double angleView = 46.4;
        double graus = ((angleView*100) * x/100) - angleView/2;
        String result = " ";
        if (graus < -5) {
            result += -(int) graus + " graus a esquerda";
        }
        else if (graus > 5) {
            result += (int) graus + " graus a direita";
        } else{
            result += " a frente";
        }
        return result;
    }

}
