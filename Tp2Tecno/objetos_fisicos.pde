// --------- Verduras --------- \\
class Verdura extends FCircle {
  PImage verduraImg;
  String nombre;
  float anguloVel = 40;
  float velocidad = 500;
  float angulo = radians(-90);
  float anguloVerdura;
  float vxVerdura = velocidad * cos(anguloVerdura);
  float vyVerdura = velocidad * sin(anguloVerdura);
  float posX;

  Verdura (String _nombre) {
    super (50);
    nombre = _nombre;
    verduraImg = loadImage ("img/" + nombre + ".png");
    setName (nombre);
    setGrabbable (false); // ¿Se puede agarrar? *va false
    setStatic (false); // ¿Es estático?
    setRestitution (1);
    setDamping (-1);
  }

  void inicializar () {
    attachImage (verduraImg);
    posX = -5;
    setVelocity(vxVerdura, vyVerdura);
  }
}

// --------- Ollas --------- \\
class Olla extends FBox {
  String lado;
  PImage ollaDer;
  PImage ollaIzq;

  Olla (float _w, float _h, String _lado) {
    super (_w, _h);
    lado = _lado;
    ollaDer = loadImage ("img/ollanaranja.png");
    ollaIzq =  loadImage ("img/ollanaranja.png");
  }

  void actualizar () {
    
    if (lado.equals("ollaDer")) {
       attachImage(ollaDer);
      setName ("ollaDer"); // Asignacion de nombre
      setPosition (width - 200 / 2, height -  240 / 2 - 130); // Asignacion de posición
      setGrabbable (false); // ¿Se puede agarrar? *va false
      setStatic (true); // ¿Es estático?}
    } else if (lado.equals("ollaIzq")) {
       attachImage(ollaIzq);
      setName ("ollaIzq"); // Asignacion de nombre
      setPosition (200 / 2, height -  240 / 2 - 130); // Asignacion de posición
      setGrabbable (false); // ¿Se puede agarrar? *va false
      setStatic (true); // ¿Es estático?
    }
  }
}


// --------- Jugador --------- \\
class Jugador extends FBox {
  PImage jugadorImg;

  Jugador(float _ancho, float _alto) {
    super (_ancho, _alto);
    setName ("jugador"); // Asignacion de nombre
    setRotatable (false); // ¿Es estático?
    jugadorImg = loadImage ("img/jugadorImg.png");
  }

  void inicializar () {
    attachImage(jugadorImg);
    setPosition (width / 2, height - 119 / 2 - 240); // Asignacion de posición
    setGrabbable (false); // ¿Se puede agarrar? *va false
  }
}


// --------- funcion colision --------- \\
String  conseguirNombre (FBody body) {
  String nombre = "nada";
  if (body != null) {
    nombre = body.getName();
    if (nombre == null) {
      nombre = "nada";
    }
  }
  return nombre;
}
void contactStarted (FContact colision) {
    FBody _body1 = colision.getBody1();
    FBody _body2 = colision.getBody2();

    String nombre1 = conseguirNombre (_body1);
    String nombre2 = conseguirNombre (_body2);

    println (nombre1, nombre2);

    if ((nombre1.equals(jugando.verdura.nombre) && nombre2.equals("ollaDer")) || (nombre2.equals (jugando.verdura.nombre) && nombre1.equals("ollaDer"))) {
      println (nombre1, nombre2);
      if (nombre1.equals(jugando.verdura.nombre) && colision.getNormalY() > 0) {
        println ("punto");
        jugando.puntos++;
        mundo.remove(jugando.verdura);
        jugando.hayVerdura = false;
      } else if (nombre2.equals(jugando.verdura.nombre) && colision.getNormalY() < 0) {
        println ("punto");
        jugando.puntos++;
        mundo.remove(jugando.verdura);
        jugando.hayVerdura = false;
      }
    } else if ((nombre1.equals(jugando.verdura.nombre) && nombre2.equals("ollaIzq")) || (nombre2.equals (jugando.verdura.nombre) && nombre1.equals("ollaIzq"))) {
      println (nombre1, _body2.getName());
      if (nombre1.equals(jugando.verdura.nombre) && colision.getNormalY() > 0) {
        println ("perdiste");
        mundo.remove(jugando.verdura);
        jugando.hayVerdura = true;
      estado = 4; // cambio de estado
      reproducirEs(3); //perder.mp3
      } else if (nombre2.equals(jugando.verdura.nombre) && colision.getNormalY() < 0) {
        println ("perdiste");
        mundo.remove(jugando.verdura);
        jugando.hayVerdura = true;
      estado = 4; // cambio de estado
      reproducirEs(3); //perder.mp3
      }
    } else if ((nombre1.equals(jugando.verdura.nombre) && nombre2.equals("piso")) || (nombre2.equals (jugando.verdura.nombre) && nombre1.equals("piso"))) {
      println (nombre1, nombre2);
      jugando.verdura.setVelocity(0, 0);
    } else if ((nombre1.equals(jugando.verdura.nombre) && nombre2.equals("jugador")) || (nombre2.equals (jugando.verdura.nombre) && nombre1.equals("jugador"))) {
      println (nombre1, nombre2);
    }
    // --------- limpieza --------- \\
    // --------- limpieza --------- \\
jugando.verdurasEnPiso.add(jugando.verdura);
//-------------------------------\\    
    
//-------------------------------\\    
    
  }
