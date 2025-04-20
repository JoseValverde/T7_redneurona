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
int hijosDerivados = 7; // Número de hijos que genera cada elemento
int nivelProfundidad = 2; // Niveles de profundidad en la red

void setup() {
  size(700, 1100, P3D);
  smooth();
  
  // Inicializar gestores
  audioManager = new AudioManager(this, "musica/nombre.mp3");
  debugManager = new DebugManager();
  fondoManager = new FondoManager();
  
  // Crear elemento principal
  elementoPrincipal = new ElementoPrincipal(new PVector(width/2, height/2, 0), 20, PRIMARIO);
  elementoPrincipal.generarRedNeuronal(hijosDerivados, nivelProfundidad);
}

void draw() {
  // Primero dibujamos el fondo con las imágenes
  fondoManager.actualizar(audioManager.getNivelGraves(), audioManager.hayBeatGraves());
  fondoManager.mostrar();
  
  // Aplicar un overlay semitransparente del color de fondo
  fill(FONDO, 200);
  rect(0, 0, width, height);
  
  // Iluminación
  lights();
  //ambientLight(40, 40, 40);
  lightFalloff(1.0, 0.001, 0.0);
  pointLight(150, 250, 150, 200, 200, 200);

  // Análisis de audio
  audioManager.actualizarAnalisis();
  
  // Actualizar elementos según el audio
  if (audioManager.hayBeatGraves()) {
    elementoPrincipal.cambiarDireccion();
  }
  
  if (audioManager.hayBeatAgudos()) {
    // Cambiar color como antes
    elementoPrincipal.cambiarColor(PALETA);
    
    // Aplicar un impulso aleatorio a todos los elementos
    // Reducir la intensidad base y el factor multiplicador para movimientos más suaves
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