// --------- Administrador --------- \\

class Administrador {

  ArrayList <Puntero> punteros;

  FWorld mundo; // puntero al mundo en el main


  Administrador(FWorld _mundo) {
    punteros = new ArrayList<Puntero>();

    mundo = _mundo;
  }
//le vamos a pasar el blob a crear puntero 
  void crearPuntero(Blob b) {

    Puntero p = new Puntero(mundo, b.id, b.centroidX * width, b.centroidY * height);
    punteros.add(p);
  }
// cuando un puntero se va  (o blob) lo borramos 
  void removerPuntero(Blob b) {
    for (int i= punteros.size()-1; i>=0; i--) {

      Puntero p = punteros.get(i);

      if (p.id == b.id) {
        p.borrar();  
        punteros.remove(i);
        break;
      }
    }
  }
//el momento que se mueva se actualiza el blob, si el blob se esta moviendo coincide con algguno de mis punteeros le digo que lo siga
  void actualizarPuntero(Blob b) {
    for (Puntero p : punteros) {
      if (p.id == b.id) {
        p.setTarget(b.centroidX * width, b.centroidY * height);
        break;
      }
    }
  }

  void dibujar() {
    for (Puntero p : punteros) {
   //  p.dibujar();
    }
  }
}


// --------- Blob --------- \\

class Blob {

  boolean actualizado;
  boolean entro;
  boolean salio;
  
  int vida;
  
  int ultimaActualizacion;
  
  int limite_tiempo_salir;

  // datos del blob
  int id; 
  float age;
  float centroidX;
  float centroidY;
  float averageX;
  float averageY;
  float centerX;
  float centerY;
  float velocityX;
  float velocityY;
  float area;
  float perimeter;
  float boundingRectX;
  float boundingRectY;
  float boundingRectW;
  float boundingRectH;
  float vertexNumber;

  ArrayList <Float> contorno;

  Blob() {

    entro =  true;
    actualizado = false;
    salio = false;

    vida = 0;
    ultimaActualizacion = 0;
    
    limite_tiempo_salir = -5;
    
    id = -1;
    age = 0 ;
    centroidX = 0;
    centroidY = 0;
    averageX = 0;
    averageY = 0;
    centerX = 0;
    centerY = 0;
    velocityX = 0;
    velocityY = 0;
    area = 0;
    perimeter = 0;
    boundingRectX = 0;
    boundingRectY = 0;
    boundingRectW = 0;
    boundingRectH = 0;
    vertexNumber = 0;
    
    contorno = new ArrayList<Float>();
  }

  void actualizar(){
    if(vida > 0){
      entro = false;
    }
    vida++;
    vida = vida % 100;
  
    salio = ultimaActualizacion == limite_tiempo_salir ? true : false;
  }
  void actualizarDatos(OscMessage m) {

    contorno.clear();
    
    age = m.get(1).floatValue();
    centroidX = m.get(2).floatValue();
    centroidY = m.get(3).floatValue();
    averageX = m.get(4).floatValue();
    averageY = m.get(5).floatValue();
    centerX = m.get(6).floatValue();
    centerY = m.get(7).floatValue();
    velocityX = m.get(8).floatValue();
    velocityY = m.get(9).floatValue();
    area = m.get(10).floatValue();
    perimeter = m.get(11).floatValue();
    boundingRectX = m.get(12).floatValue();
    boundingRectY = m.get(13).floatValue();
    boundingRectW = m.get(14).floatValue();
    boundingRectH = m.get(15).floatValue();
    vertexNumber = m.get(16).floatValue();

    for (int i = 17; i < m.arguments ().length; i++) {
      contorno.add(m.get(i).floatValue());
    }    
  }

  void setID( int id) {
    this.id = id;
  }

  void dibujar(float w, float h) {

    // Centro - ID - Age
    float x = centerX * w;
    float y = centerY * h;

    stroke(255, 255, 0);
    pushMatrix();
    translate(x, y);
    ellipse(0, 0, 5, 5);
    stroke(255, 0, 0);
    line(0, 0,  velocityX * w, velocityY * h);
    fill(0);
    text("id: " + id, 5, 5);
    text("age: " + age, 5, 15);
    popMatrix();

    // Bounding Rect
    float rx = boundingRectX * w;
    float ry = boundingRectY * h;

    noFill();
    stroke(0, 0, 255);
    pushMatrix();
    translate(rx, ry);
    rect( 0, 0, boundingRectW * w, boundingRectH * h);
    popMatrix();

    // Contorno
    stroke(0, 255, 0);
    beginShape();

    for (int i=0; i<contorno.size()-1; i+=2) {

      vertex(contorno.get(i) * w, contorno.get(i+1) * h);
    }
    endShape(CLOSE);
  }
}

// --------- OSC --------- \\
import oscP5.*;
OscP5 osc;

OscProperties propiedadesOSC;

ArrayList <OscMessage> mensajes; // lista de mensajes entrantes

void setupOSC( int puerto) {


  propiedadesOSC = new OscProperties();

  propiedadesOSC.setDatagramSize(10000);
  propiedadesOSC.setListeningPort(puerto);
  osc = new OscP5(this, propiedadesOSC);

  mensajes = new ArrayList<OscMessage>();

}

void oscEvent (OscMessage m) {
  mensajes.add(m);
}


// --------- Puntero --------- \\
class Puntero {
//puntero es el blob que estamos dectectando convertido en un objeto de fisica 
  float id; //identificador de blob 
  float x;
  float y;

  float diametro;

  FWorld mundo; // puntero al mundo de fisica que está en el main


  FCircle body; //representa al cuerpo dentro del mundo de fisica que se va  amover a partir de un mouse joint

  FMouseJoint mj; //para mover cualquier objeto de manera dinamica en fisica necesito un mouse joint

  Puntero(FWorld _mundo, float _id, float _x, float _y) {
    mundo = _mundo;
    id = _id;
    x = _x;
    y = _y;
    diametro = 2;

    body = new FCircle(diametro);
    body.setPosition(x, y);
    mj = new FMouseJoint(body, x, y); //creamos el mouse joint por el cual se va a mover

    mundo.add(body);
    mundo.add(mj);
  }
 //para moverlo vamos a crear una funcion setTarget
  void setTarget(float nx, float ny) {
    mj.setTarget(nx, ny);
  }

  void setID(float id) {
    this.id = id;
  }
//funcion para cuando no hay blob, el orden es inverso para quitarlo del mundo que para agregarlo
  void borrar() {
    mundo.remove(mj);
    mundo.remove(body);
  }
  
  void dibujar() {
   
  }
 
}


// --------- Receptor --------- \\
class Receptor {

  ArrayList <Blob> blobs;
  int tiempo_para_borrar = -15;

  Receptor() {

    blobs = new ArrayList<Blob>();
  }

  void actualizar(ArrayList <OscMessage> mensajes) {

    resetBlobs(); // Si hay blobs, pone la variable "estaActualizado" en false, en todos los blobs

    while (mensajes.size() > 0) { // Mientras hay mensajes en el buffer


      OscMessage m = mensajes.get(0); // carga el primer mensaje que llegó en la variable m

      if (m.addrPattern().equals("/bblobtracker/blobs")) { // si el mensaje tiene la etiqueta (address) "/bblobtracke/blobs"

        boolean encontrado = false;  // 

        int id = (int) m.get(0).floatValue(); // le pido el ID a cada blob del mensaje

        for (int i=0; i<blobs.size(); i++) { // recorro la lista de blobs del repector

          Blob b = blobs.get(i);

          if (b.id == id) { // si el blob del mensaje ya estaba en mi lista de blobs
    
            b.actualizarDatos(m); // le envio el mensaje al blob para que tome los datos del indice correspondiente para actualizarse
            b.actualizado = true; // aviso que este blob ya fue actualizado
            b.ultimaActualizacion = 0;
            encontrado = true; // aviso que el blob del mensaje ya fue encontrado para que deje de buscar entre los de mi lista de blobs
            break; // salgo del siclo for para que deje de buscar
          }
        }

        if (!encontrado) { 
          Blob nb = new Blob();   // creo un NUEVO blob
          nb.setID(id);           // le pongo el ID
          nb.actualizarDatos(m);   // le actualizo los datos
          nb.actualizado = true; // lo marco como ya actualizado
          blobs.add(nb);
        }
      }
      mensajes.remove(0);
    }

    for (int k=blobs.size()-1; k>=0; k--) { //recorro mi lista de blobs de atras para adelante
      Blob vb = blobs.get(k);
      if (!vb.actualizado) {  // si encuentro alguno que no fue actualizado (porque en los mensajes de entrada no estaba
        vb.ultimaActualizacion--;
      }
      if (vb.ultimaActualizacion < tiempo_para_borrar) {

        blobs.remove(k);  // lo borro de la lista
      }
    }
    
    for (Blob b : blobs) {
      b.actualizar();
    }
  }

  void resetBlobs() {
    for (Blob b : blobs) {
      b.actualizado = false;
    }
  }

  void dibujarBlobs(float w, float h) {

    for (Blob b : blobs) {
  //   b.dibujar(w, h);
    }
  }
}
