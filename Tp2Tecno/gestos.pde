class Gesto {

  // --------- variables --------- \\
  float x; // Posición x de gesto
  float y; // Posición y de gesto
  float ancho; // Ancho de gesto
  float alto; // Alto de gesto
  boolean colision; // Evalua si hay colision
  PImage ollaColision;
  
  boolean colisionDetectada; // para rastrear si se detectó una colisión recientemente
  int tiempoColisionDetectada; //tTiempo en que se detectó la colisión
  int tiempoColisionMaximo = 3000; // duracion máxima de la colisión en milisegundos (3 segundos)


  Gesto (float _x, float _y, float _ancho, float _alto) {
    x = _x; 
    y = _y; 
    ancho = _ancho; 
    alto = _alto; 
    ollaColision = loadImage("img/ollaLuz.png");
  }

 void inicializar(float targetX, float targetY) {
    if (estado == 0 || estado == 3 || estado == 4) { // la colisión gestoIniciar solo se permite en 3 estados (Inicio, ganaste, perdiste)
      if (targetX >= x && targetX <= x + ancho && targetY >= y && targetY <= y + alto) { // Si hay colisión entre Mouse y Botón Central...
        if (!colisionDetectada) {
          // si no se ha detectado la colisión recientemente, la detectamos ahora
          colisionDetectada = true;
          tiempoColisionDetectada = millis(); // Registramos el tiempo de detección
          
        
        }

        // verificamos pasaron los 2 segundos para mantener la colisión
        if (millis() - tiempoColisionDetectada >= tiempoColisionMaximo) {
          colision = true; // Si ha pasado el tiempo máximo, dejamos de considerar la colisión         
        }
      } else {
        colision = false;
        colisionDetectada = false; // restablecemos la detección de colisión si no colisiona
      }
    }
     // Dibuja la imagen si la colisión está detectada
  if (colisionDetectada && estado == 0) {
    image(ollaColision, 220, 250, 980, 470);
  }
  }
}
