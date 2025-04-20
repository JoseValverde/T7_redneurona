import ddf.minim.*;

// Constantes de colores
final color PRIMARIO = #1B1F3B;    // Azul Medianoche
final color SECUNDARIO = #FF577F;  // Rosa fuerte
final color ACENTO = #33D1FF;      // Cian eléctrico
final color FONDO = #0D0D0D;       // Negro total
final color TEXTO = #FFFFFF;       // Blanco brillante
final color[] PALETA = {PRIMARIO, SECUNDARIO, ACENTO, TEXTO};

// Variables del sistema
ElementoPrincipal elementoPrincipal;
AudioManager audioManager;
DebugManager debugManager;
FondoManager fondoManager;
boolean mostrarDebug = false;

// Configuración de la red
int hijosDerivados = 6; // Número de hijos que genera cada elemento
int nivelProfundidad = 3; // Niveles de profundidad en la red

void setup() {
  size(700, 1100, P3D);
  smooth();
  
  // Inicializar gestores
  audioManager = new AudioManager(this, "musica/nombre.mp3");
  debugManager = new DebugManager();
  fondoManager = new FondoManager();
  
  // Crear elemento principal
  elementoPrincipal = new ElementoPrincipal(new PVector(width/2, height/2, 0), 10, PRIMARIO);
  elementoPrincipal.generarRedNeuronal(hijosDerivados, nivelProfundidad);
  
  // Configurar la perspectiva para mejor visualización 3D
  perspective(PI/3.0, float(width)/float(height), 10, 1000000);
}

void draw() {
  // Limpiar el buffer de profundidad y color
  background(0);
  
  // Guardar la configuración actual de la cámara
  pushMatrix();
  
  // Dibujar el fondo en modo 2D
  hint(DISABLE_DEPTH_TEST);
  camera();
  // Dibujar el fondo con las imágenes
  fondoManager.actualizar(audioManager.getNivelGraves(), audioManager.hayBeatGraves());
  fondoManager.mostrar();
  
  // Aplicar un overlay semitransparente del color de fondo
  fill(FONDO, 200);
  rect(0, 0, width, height);
  
  // Restaurar la configuración 3D
  hint(ENABLE_DEPTH_TEST);
  popMatrix();
  
  // Obtener la posición del elemento padre
  PVector posPadre = elementoPrincipal.getPosicion();
  
  // Configurar la cámara para seguir al elemento padre
  // La cámara se coloca ligeramente por encima y detrás
  camera(
      posPadre.x, // X de la cámara sigue al padre
      posPadre.y - 100, // Y de la cámara un poco más arriba
      posPadre.z + (height/2) / tan(PI/6), // Z de la cámara a una distancia fija
      posPadre.x, // Mirar hacia X del padre
      posPadre.y, // Mirar hacia Y del padre
      posPadre.z, // Mirar hacia Z del padre
      0, 1, 0 // Vector "arriba" se mantiene igual
  );
  
  // Iluminación
  lights();
  //lightFalloff(1.0, 0.001, 0.0);
  //directionalLight(20, 20, 20, width/2, height/2, 0);
  pointLight(150, 150, 150, width/2, height/2, 00);
 //pointLight(51, 102, 126, 140, 160, 144);


  // Análisis de audio
  audioManager.actualizarAnalisis();
  
  // Actualizar elementos según el audio
  if (audioManager.hayBeatGraves()) {
    elementoPrincipal.cambiarDireccion();
  }
  
  if (audioManager.hayBeatAgudos()) {
    elementoPrincipal.cambiarColor(PALETA);
    float intensidadImpulso = 10 + audioManager.getNivelAgudos() * 10.0;
    elementoPrincipal.aplicarImpulsoATodos(intensidadImpulso);
  }
  
  // Actualizar y dibujar elementos
  elementoPrincipal.actualizar();
  elementoPrincipal.mostrar();
  
  // Dibujar las conexiones
  elementoPrincipal.dibujarConexiones();
  
  // Debug
  if (mostrarDebug) {
    debugManager.mostrarInformacion(elementoPrincipal, audioManager);
  }
}

void keyPressed() {
  if (key == 'd' || key == 'D') {
    mostrarDebug = !mostrarDebug;
  }
}