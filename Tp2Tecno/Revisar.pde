// --------- Bibliotecas --------- \\
import fisica.*; // Importamos la biblioteca de Física
import processing.sound.*; // Importamos la biblioteca de sonido


// --------- Gestos --------- \\
Gesto gestoIniciar; // Declaramos Gesto Inicial
Gesto gestoOtraVez;  // Declaramos Gesto Volver a jugar


// --------- ESTADOS --------- \\
float estado; // Lógica de estados
Instrucciones instrucciones; // 1 - Tiene las instrucciones del juego

Jugando jugando; // 2 - Tiene lo necesario para ser jugable
Creditos creditos; // 5 - Tiene los créditos
FMouseJoint cadena; // Declaramos joint para mover al jugador


// --------- Recursos --------- \\
PImage portadaImg; // Tiene la imagen de la portada
PFont fuente; // Tiene la typo


// --------- Captura de movimiento --------- \\
int PUERTO_OSC = 12345; // Puerto de comunicación con el programa de Matias
Receptor receptor; // Administra la  entrada de los mensajes y asignacion de blobs
Administrador administrador;
float currentTargetX;
float currentTargetY;
Jugador jugador; // Declaramos jugador

// --------- Fisicas --------- \\
FWorld mundo;
//FMouseJoint cadena; // Declaramos joint para mover al jugador

// --------- Sonido --------- \\
SoundFile[] estados = new SoundFile[5];  // Array para sonidos de estados
SoundFile[] eventos = new SoundFile[5];  // Array para sonidos de eventos

// --------- Tiempo estado créditos --------- \\
float tiempoInicioEstado5 = 0; // Variable para el tiempo de inicio del estado 5
float tiempoEspera = 13000;

void setup () {
  size(1280, 720);
  Fisica.init(this); // Inicializa la librería de Fisica

  mundo = new FWorld(); // Crea un nuevo mundo de física
  mundo.setEdges(color (0, 0)); // Bordes o paredes transparentes

  // Crea objetos que dependen del mundo de física
  receptor = new Receptor();
  administrador = new Administrador(mundo);
  jugando = new Jugando(); // Inicializar la instancia de Jugando
 // jugador = new Jugador (110, 40); // Crear el jugador
 // mundo.add (jugador); // Agregar jugador al mundo
  //jugador.inicializar(); // Inicializar el jugador (incluyendo la carga de la imagen y la posición)

  // Crear el FMouseJoint después de que el jugador se haya inicializado completamente
 // cadena = new FMouseJoint (jugador, width / 2, height - 117/2);
  setupOSC(PUERTO_OSC);

  // --------- Sonido --------- \\
  //sonidos de estados:
  estados[0] = new SoundFile(this, "menu.mp3");
  estados[1] = new SoundFile(this, "cocinando2.mp3");
  estados[2] = new SoundFile(this, "ganar.mp3");
  estados[3] = new SoundFile(this, "perder.mp3");
  estados[4] = new SoundFile(this, "credituille.mp3");

  //sonidos de eventos:
  eventos[0] = new SoundFile(this, "arrojar.wav");
  eventos[1] = new SoundFile(this, "rebote.wav");
  eventos[2] = new SoundFile(this, "piso.wav");
  eventos[3] = new SoundFile(this, "limpiar.mp3");
  eventos[4] = new SoundFile(this, "splash.wav");


  // --------- Recursos --------- \\
  textAlign (CENTER, CENTER); // Tiene la alineación de la typo para todo el juego
  fuente = createFont ("fuente.otf", 32); // Tiene la typo de pixel
  textFont(fuente); // Tiene la typo de pixel
  portadaImg = loadImage ("img/portadaImg.png"); // Tiene la imagen de portada


  // --------- ESTADOS --------- \\
  estado = 0; // Lógica de estados empieza en 0 - INICIO
  instrucciones = new Instrucciones(); // Tiene las instrucciones del juego
  creditos = new Creditos(); // Tiene los créditos
  reproducirEs(0); //menu.mp3


  // --------- Gestos --------- \\
  gestoIniciar = new Gesto(width/2-250, 450, 650, 270); // Gesto Inicial
  gestoOtraVez = new Gesto(width/2-10, 450, 640, 270); // Gesto volver a jugar
}


void draw () {
  receptor.actualizar(mensajes); //
  receptor.dibujarBlobs(width, height);


  // --------- Logica de estados --------- \\
  if (estado == 0) { // INICIO
    image (portadaImg, 0, 0); // Fondo de pantalla
    gestoIniciar.inicializar(currentTargetX, currentTargetY); // Se llama a los Gestos
    if (gestoIniciar.colision) { // se elige el Gesto
      estado = 1; // cambio de estado
    }
  } else if (estado == 1) { // INSTRUCCIONES
    instrucciones.actualizar(); // Muestra las instrucciones
    if (frameCount % 1000 == 0) { // ¿reemplazar por millis? tiempo que dura la pantalla
      estado = 2; // cambio de estado
      reproducirEs(1); //cocinando2.mp3
    }
  } else if (estado == 2) { // GAME

    jugando.dibujar(); // Escenario y las físicas en pantalla
  } else if (estado == 3) { // GANASTE
    jugando.ganar(); // carga pantalla ganar
    gestoOtraVez.inicializar(currentTargetX, currentTargetY); // Se llama al gesto
    if (gestoOtraVez.colision) { // se elige el gesto
      estado = 5; // cambio de estado
      reproducirEs(4); //credituille.mp3
    }
  } else if (estado == 4) { // PERDISTE
    jugando.perder(); // Pantalla de perder
    gestoOtraVez.inicializar(currentTargetX, currentTargetY); // Se llama al gesto
    if (gestoOtraVez.colision) { // se elige el gesto
      estado = 2; // cambio de estado
      reproducirEs(1); //cocinando2.mp3
    }
  } else if (estado == 5) { // CRÉDITOS
    if (tiempoInicioEstado5 == 0) {
      tiempoInicioEstado5 = millis();
    }
    creditos.actualizar(); // muestra las instrucciones
    // comprueba si paso el tiempo de espera desde el inicio del estado 5
    if (millis() - tiempoInicioEstado5 >= tiempoEspera) {
      estado = 0; // Cambio de estado
      tiempoInicioEstado5 = 0; // reinicia el tiempo de inicio
      reproducirEs(0); //menu.mp3
    }
  } else {
    tiempoInicioEstado5 = 0; // reinicia el tiempo de inicio si no estás en el estado 5
  }


  // --------- Captura de movimiento --------- \\
  // Eventos de entrada y salida de blobs
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
    float lerpAmount = 0.1; // Ajusta este valor según la velocidad de suavizado deseada
    currentTargetX = lerp(currentTargetX, targetX, lerpAmount);
    currentTargetY = lerp(currentTargetY, targetY, lerpAmount);
  }
  if (receptor.blobs.isEmpty()) {
  }
  //cadena.setTarget(currentTargetX, height - 119/2); // el joint recibe la x del puntero
}


// --------- SONIDO --------- \\

void reproducirEs(int numEstado) {
  //  //paramos lo que este sonando pq sino se pisan los sonidos de estados anteriores
  for (int i = 0; i < estados.length; i++) {
    if (estados[i] != null && estados[i].isPlaying()) {
      estados[i].stop();
    }
  }

  //  //reproducimos el sonido que va en el estado
  if (estados[numEstado] !=null) {

    estados[numEstado].loop();
    if (numEstado == 4) {
      estados[numEstado].amp(1);
      estados[numEstado].rate(0.8);
    } else
      estados[numEstado].amp(0.7);
    estados[numEstado].rate(0.9);
  }
}

void reproducirEv(int numEvento) {
  if (eventos[numEvento] !=null) {
    eventos[numEvento].amp(0.5);
    eventos[numEvento].play();
  }
}
