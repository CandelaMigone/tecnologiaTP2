// --------- Instrucciones --------- \\
class Instrucciones {
  String [] instrucciones;
  PImage instruccionesImg; // Tiene la imagen del fondo

  Instrucciones() {
    // instrucciones = loadStrings ("instrucciones.txt");
    instruccionesImg = loadImage ("img/instruccionesImg.png");
  }

  void actualizar() {
    image (instruccionesImg, 0, 0); //Instrucciones
  }
}


// --------- Creditos --------- \\
class Creditos {
  PImage creditosImg;
  int posY; // Variable para controlar la posición vertical

  Creditos () {
    creditosImg = loadImage ("img/creditosImg.png");
    posY = height / 2; // Inicializar posY en la mitad de la pantalla
  }

  void actualizar () {
    image (creditosImg, 0, 0); // Fondo de pantalla

    // --------- Titular --------- \\
    push();
    fill(255);
    textSize(50);
    text ("Créditos de \"Un Especial\"", 0, posY, width, height/2);
    pop();

    // --------- Texto --------- \\
    push();
    textSize (30);
    fill (255);
    text ("Física: Ezequiel Ramírez", 0, posY + 100, width, height/2);
    text ("Sonido: Victoria Mestralet", 0, posY + 200, width, height/2);
    text ("Captura de Movimiento: Maria Candela Migone", 0, posY + 300, width, height/2);
    text ("Ilustración: Lara Magallanes Diaz", 0, posY + 400, width, height/2);
    text ("Basado en la Película Ratatouille de Disney-Pixar", 0, posY + 500, width, height/2);
    text ("TECNOLOGIA MULTIMEDIAL 2", 0, posY + 600, width, height/2);
    pop();
    posY--;
  }
}
