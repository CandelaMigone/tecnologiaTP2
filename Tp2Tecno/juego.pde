class Jugando {
  // --------- Objetos físicos --------- \\
  Verdura verdura;
  Olla ollaDer, ollaIzq;  // Declaramos Ollas
  FBox piso; // Declaramos piso
  Jugador jugador; // Declaramos jugador
  FMouseJoint cadena; // Declaramos joint para mover al jugador


  // --------- Captura de movimiento --------- \\
  int PUERTO_OSC = 12345; // Puerto de comunicación con el programa de Matias
  Receptor receptor; // Administra la  entrada de los mensajes y asignacion de blobs
  Administrador administrador;
  float currentTargetX;
  float currentTargetY;


  // --------- Recursos --------- \\
  PImage ganasteImg; // Poster ganaste
  PImage perdisteImg; // Poster perdiste
  PImage fondoImg; // Poster fondo
  
  
  // --------- limpieza --------- \\
boolean puedeLimpiar;
ArrayList <Verdura> verdurasEnPiso;
//-------------------------------\\


// --------- Antes del constructor --------- \\
PImage remyImg;
PImage barraImg;
PImage colette;
//-------------------------------\\

  // --------- variables --------- \\
  int puntos;
  boolean hayVerdura;

  Jugando () {
    ganasteImg = loadImage ("img/ganasteImg.png");
    perdisteImg = loadImage ("img/perdisteImg.png");
    fondoImg = loadImage ("img/fondoImg.png");
    //colette = loadImage ("manoDerecha.png");
   // colette1 = loadImage ("manoIzquierda.png");

// --------- limpieza --------- \\
verdurasEnPiso = new ArrayList<Verdura>();
//-------------------------------\\

// --------- constructor --------- \\
remyImg = loadImage ("img/remyImg.png");
barraImg = loadImage ("img/barraImg.png");
colette = loadImage ("img/manoIzquierda.png");

//-------------------------------\\



    puntos = 0;
    hayVerdura = false;
// --------- limpieza --------- \\
  puedeLimpiar = false;
//-------------------------------\\

  
    ollaDer = new Olla (200, 250, "ollaDer"); // Inicializamos olla izquierda
    ollaDer.actualizar ();
    mundo.add (ollaDer); // Agregamos olla izquierda al mundo

    ollaIzq = new Olla (200, 240, "ollaIzq"); // Inicializamos olla izquierda
    ollaIzq.actualizar ();
    mundo.add (ollaIzq); // Agregamos olla izquierda al mundo

    piso = new FBox(width, 240); // Inicializamos el piso transparente
    piso.setPosition (width/2, height - 5); // Asignacion de posición
    piso.setName ("piso"); // Asignacion de nombre
    piso.setNoStroke(); // noStroke
    piso.setNoFill(); // noFill
    piso.setStatic (true); // ¿Es estático?
    piso.setGrabbable (false); // ¿Se puede agarrar?
    mundo.add (piso); // Agregamos piso al mundo
    receptor = new Receptor();
    administrador = new Administrador(mundo);
    jugador = new Jugador (110, 40); // Inicializamos jugador
    jugador.inicializar ();
    mundo.add (jugador); // Agregamos jugador al mundo

    cadena = new FMouseJoint (jugador, width / 2, height - 119/2 - 130); // Inicializamos la cadena
    cadena.setFrequency (2); // delay de acercamiento - = + delay
    mundo.add (cadena); // Agregamos la cadena al mundo


    // --------- Captura de movimiento --------- \\

    setupOSC(PUERTO_OSC);
  }

  void dibujar() {


    image (fondoImg, 0, 0); // Se reemplaza por portadaImg en el estado 0
   // image(colette1, -40, 50, 250, 150);
    if (!hayVerdura) {
      String [] nombresVerduras = {"cebolla", "morron", "papa", "papaFea", "morronFeo", "cebollaFea"};
      String nombreRandom = nombresVerduras [int (random (nombresVerduras.length))];
      verdura = new Verdura (nombreRandom); // Inicializamos verdura1
      mundo.add(verdura);
      verdura.inicializar();
      hayVerdura = true;

      println (nombreRandom);
    }
// --------- void dibujar --------- \\
  image (remyImg, width/2 - 104/2, 100 ); // 
  image (barraImg, 40, 50 , 450/3, 210/3); //
image(colette,-40, 130, 200,100);
//-------------------------------\\

    //image(colette1,1070, 50, 250,150);

// --------- limpieza --------- \\
if (currentTargetX <= 40 + (450/3) && currentTargetX >= 40 && currentTargetY >= 50 && currentTargetY <= 50 + (210/3)) {
  puedeLimpiar = true;
}

if (puedeLimpiar) {
for(Verdura v : verdurasEnPiso) {
  mundo.remove(v);
  hayVerdura = false;
}
verdurasEnPiso.clear();
puedeLimpiar = false;
}
//-------------------------------\\


    // --------- Captura de movimiento --------- \\
    receptor.actualizar(mensajes); //
    receptor.dibujarBlobs(width, height);

    //// Eventos de entrada y salida de blobs
    for (Blob b : receptor.blobs) {

      if (b.entro) {
        administrador.crearPuntero(b);
        println("--> entro blob: " + b.id);
      }

      if (b.salio) {
        administrador.removerPuntero(b);
        println("<-- salio blob: " + b.id);
      }

      administrador.actualizarPuntero(b);
    }

    if (!receptor.blobs.isEmpty()) {
      Blob blob = receptor.blobs.get(0); // Sup primer blob en la lista

      float targetX = blob.centroidX * width;
      float targetY = blob.centroidY * height;

      // lerp para suavizar el movimiento
      float lerpAmount = 0.2; // Ajusta este valor según la velocidad de suavizado deseada
      currentTargetX = lerp(currentTargetX, targetX, lerpAmount);
      currentTargetY = lerp(currentTargetY, targetY, lerpAmount);

      cadena.setTarget(currentTargetX, height - 119/2); // el joint recibe la x del puntero
    }
    if (receptor.blobs.isEmpty()) {
    }

    mundo.step(); // Sucede el tiempo
    mundo.draw(); // Dibuja el mundo

    if (puntos >= 1) {
      estado = 3; // cambio de estado
      reproducirEs(2); //ganar.mp3
    }

    //pruebas sin captura, se borra
    //   cadena.setTarget(mouseX, height - 119/2); // el joint recibe la x del puntero
  }

  void contactStarted (FContact colision) {
    FBody _body1 = colision.getBody1();
    FBody _body2 = colision.getBody2();

    String nombre1 = conseguirNombre (_body1);
    String nombre2 = conseguirNombre (_body2);

    println (nombre1, nombre2);

    if ((nombre1.equals(verdura.nombre) && nombre2.equals("ollaDer")) || (nombre2.equals (verdura.nombre) && nombre1.equals("ollaDer"))) {
      println (nombre1, nombre2);
      if (nombre1.equals(verdura.nombre) && colision.getNormalY() > 0) {
        println ("punto");
        puntos++;
        mundo.remove(verdura);
        hayVerdura = false;
      } else if (nombre2.equals(verdura.nombre) && colision.getNormalY() < 0) {
        println ("punto");
        puntos++;
        mundo.remove(verdura);
        hayVerdura = false;
      }
    } else if ((nombre1.equals(verdura.nombre) && nombre2.equals("ollaIzq")) || (nombre2.equals (verdura.nombre) && nombre1.equals("ollaIzq"))) {
      println (nombre1, _body2.getName());
      if (nombre1.equals(verdura.nombre) && colision.getNormalY() > 0) {
        println ("perdiste");
        mundo.remove(verdura);
        hayVerdura = false;
        estado = 4; // cambio de estado
        reproducirEs(3); //perder.mp3
      } else if (nombre2.equals(verdura.nombre) && colision.getNormalY() < 0) {
        println ("perdiste");
        mundo.remove(verdura);
        hayVerdura = false;
        estado = 4; // cambio de estado
        reproducirEs(3); //perder.mp3
      }
    } else if ((nombre1.equals(verdura.nombre) && nombre2.equals("piso")) || (nombre2.equals (verdura.nombre) && nombre1.equals("piso"))) {
      println (nombre1, nombre2);
      verdura.setVelocity(0, 0);
    } else if ((nombre1.equals(verdura.nombre) && nombre2.equals("jugador")) || (nombre2.equals (verdura.nombre) && nombre1.equals("jugador"))) {
      println (nombre1, nombre2);
    }
    
    
  }

    

  void ganar() {
    image (ganasteImg, 0, 0); // Imagen de Poster en posición
  }


  void perder () {
    image (perdisteImg, 0, 0); // Imagen de Poster en posición
  }
}
