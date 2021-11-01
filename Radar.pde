import processing.serial.*; // importa la libreria para la "comunicación serial" 
import java.awt.event.KeyEvent; // importa la libreria para leer los datos del "serial Port"
import java.io.IOException;

Serial myPort; // definiendo los objectos del Serial
//Variables
String angle = "";
String distance = "";
String data = "";
String noObject;
float pixsDistance;
int iAngle, iDistance;
int index1 = 0;
int index2 = 0;
PFont orcFont;

void setup() {
 size (1920, 1080);
 smooth();
 myPort = new Serial(this,"COM4", 9600); // Inicia la Comunicación Serial
 myPort.bufferUntil('.'); // Lee los datos desde el puerto serie hasta el carácter '.'. Así que en realidad lee esto: ángulo,distancia.
 orcFont = loadFont("OCRAExtended-30.vlw");
}

void draw() {
  
  fill(98,245,31);
  textFont(orcFont);
  // Simulando desenfoque de movimiento y desvanecimiento lento de la línea en movimiento
  noStroke();
  fill(0,4); 
  rect(0, 0, width, 1010); 
  
  fill(98,245,31); // Color verde
  // Llamar a las funciones para dibujar el radar
  drawRadar(); 
  drawLine();
  drawObject();
  drawText();
}

void serialEvent (Serial myPort) { // Comienza a leer los datos desde el "Serial Port"
  // Lee los datos desde el puerto serie hasta el carácter '.' y los pone en la variable String "data".
  data = myPort.readStringUntil('.');
  data = data.substring(0,data.length()-1);
  
  index1 = data.indexOf(","); // Encuentra el carácter ',' y lo pone en la variable "index1"
  angle= data.substring(0, index1); // Lee los datos de la posición "0" a la posición del índice "variable1" o ese es el valor del ángulo que el Arduino Board envió al "Serial Port"
  distance= data.substring(index1+1, data.length()); // Lee los datos desde la posición "index1" hasta el final de la "PR" datos que sea el valor de la distancia
  
  // Convierte las variables "String" en "Integer"
  iAngle = int(angle);
  iDistance = int(distance);
}

void drawRadar() { //FUNCION PARA DIBUJAR EL RADAR
  pushMatrix();
  translate(960,1000); // Mueve las coordinaciones iniciales a una nueva ubicación
  noFill();
  strokeWeight(2);
  stroke(98,245,31);
  // Dibuja las líneas de arco
  arc(0,0,1800,1800,PI,TWO_PI);
  arc(0,0,1400,1400,PI,TWO_PI);
  arc(0,0,1000,1000,PI,TWO_PI);
  arc(0,0,600,600,PI,TWO_PI);
  // Dibuja las líneas angulares
  line(-960,0,960,0);
  line(0,0,-960*cos(radians(30)),-960*sin(radians(30)));
  line(0,0,-960*cos(radians(60)),-960*sin(radians(60)));
  line(0,0,-960*cos(radians(90)),-960*sin(radians(90)));
  line(0,0,-960*cos(radians(120)),-960*sin(radians(120)));
  line(0,0,-960*cos(radians(150)),-960*sin(radians(150)));
  line(-960*cos(radians(30)),0,960,0);
  popMatrix();
}

void drawObject() { //FUNCION PARA DIBUJAR LA ANIMACION DE LINEA ROJA EN EL RADAR (DEMOSTRANDO SU FUNCIONALIDAD A LO LARGO DEL RANGO DE ESCANEO)
  pushMatrix();
  translate(960,1000); // Mueve las coordinaciones iniciales a una nueva ubicación
  strokeWeight(9);
  stroke(255,10,10); // red color
  pixsDistance = iDistance*22.5; // Cubre la distancia desde el sensor de cm a píxeles
  // limitando el rango a 40 cms
  if(iDistance<40){
    // Dibuja el objeto según el ángulo y la distancia
  line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),950*cos(radians(iAngle)),-950*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawLine() { //Dibuja las lineas del radar
  pushMatrix();
  strokeWeight(9);
  stroke(30,250,60);
  translate(960,1000); // Mueve las coordinaciones iniciales a una nueva ubicación
  line(0,0,950*cos(radians(iAngle)),-950*sin(radians(iAngle))); // Dibuja la línea según el ángulo
  popMatrix();
}

void drawText() { // FUNCION PARA ESCRIBIR LOS TEXTOS EN LA PANTALLA
  
  pushMatrix();
  if(iDistance>40) {
  noObject = "Out of Range";
  }
  else {
  noObject = "In Range";
  }
  fill(0,0,0);
  noStroke();
  rect(0, 1010, width, 1080);
  fill(98,245,31);
  textSize(25);
  text("10cm",1180,990);
  text("20cm",1380,990);
  text("30cm",1580,990);
  text("40cm",1780,990);
  textSize(40);
  text("Object: " + noObject, 240, 1050);
  text("Angle: " + iAngle +" °", 1050, 1050);
  text("Distance: ", 1380, 1050);
  if(iDistance<40) {
  text("        " + iDistance +" cm", 1400, 1050);
  }
  textSize(25);
  fill(98,245,60);
  translate(961+960*cos(radians(30)),982-960*sin(radians(30)));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(954+960*cos(radians(60)),984-960*sin(radians(60)));
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate(945+960*cos(radians(90)),990-960*sin(radians(90)));
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(935+960*cos(radians(120)),1003-960*sin(radians(120)));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate(940+960*cos(radians(150)),1018-960*sin(radians(150)));
  rotate(radians(-60));
  text("150°",0,0);
  popMatrix(); 
}
