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
boolean mostrarDebug = false;

// Configuración de la red
int hijosDerivados = 3; // Número de hijos que genera cada elemento
int nivelProfundidad = 3; // Niveles de profundidad en la red

void setup() {
  size(700, 1100, P3D);
  smooth();
  
  // Inicializar gestores
  audioManager = new AudioManager(this, "musica/nombre.mp3");
  debugManager = new DebugManager();
  
  // Crear elemento principal
  elementoPrincipal = new ElementoPrincipal(new PVector(width/2, height/2, 0), 20, PRIMARIO);
  elementoPrincipal.generarRedNeuronal(hijosDerivados, nivelProfundidad);
}

void draw() {
  background(FONDO);
  
  // Iluminación
  lights();
  ambientLight(40, 40, 40);
  
  // Análisis de audio
  audioManager.actualizarAnalisis();
  
  // Actualizar elementos según el audio
  if (audioManager.hayBeatGraves()) {
    elementoPrincipal.cambiarDireccion();
  }
  
  if (audioManager.hayBeatAgudos()) {
    elementoPrincipal.cambiarColor(PALETA);
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