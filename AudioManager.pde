import ddf.minim.analysis.*;

class AudioManager {
  private Minim minim;
  private AudioPlayer player;
  private FFT fft;
  
  private float nivelGraves = 0;
  private float nivelMedios = 0;
  private float nivelAgudos = 0;
  
  private float umbralBeatGraves = 0.5;   // Ajustar según necesidad
  private float umbralBeatAgudos = 0.3;   // Ajustar según necesidad
  
  private boolean beatGraves = false;
  private boolean beatAgudos = false;
  
  private int cooldownGraves = 0;
  private int cooldownAgudos = 0;
  private final int TIEMPO_COOLDOWN = 10; // Frames de espera entre beats
  
  AudioManager(PApplet app, String archivoAudio) {
    minim = new Minim(app);
    try {
      player = minim.loadFile(archivoAudio);
      player.play();
    } catch (Exception e) {
      println("Error al cargar el archivo de audio: " + e.getMessage());
      // Intentar cargar un archivo alternativo
      try {
        player = minim.loadFile("musica/nombre.mp3");
        if (player != null) {
          println("Usando archivo de audio alternativo: musica/nombre.mp3");
          player.play();
        }
      } catch (Exception e2) {
        println("Error al cargar el archivo de audio alternativo: " + e2.getMessage());
        println("Creando un buffer de audio vacío para evitar errores");
        // Crear un buffer de entrada silencioso como último recurso
        player = minim.loadFile("musica/01nombre.mp3", 2048);
      }
    }
    
    if (player != null) {
      fft = new FFT(player.bufferSize(), player.sampleRate());
    } else {
      println("ERROR: No se pudo inicializar el análisis de audio");
    }
  }
  
  void actualizarAnalisis() {
    if (player == null || fft == null) {
      // Si no hay reproductor o FFT, no intentar analizar
      return;
    }
    
    try {
      fft.forward(player.mix);
      
      // Analizar bandas de frecuencia
      float sumGraves = 0;
      float sumMedios = 0;
      float sumAgudos = 0;
      
      // Graves (20-250Hz)
      for(int i = 0; i < 10; i++) {
        sumGraves += fft.getBand(i);
      }
      nivelGraves = sumGraves / 10.0;
      
      // Medios (250-2000Hz)
      for(int i = 10; i < 40; i++) {
        sumMedios += fft.getBand(i);
      }
      nivelMedios = sumMedios / 30.0;
      
      // Agudos (2000-20000Hz)
      for(int i = 40; i < fft.specSize(); i++) {
        sumAgudos += fft.getBand(i);
      }
      nivelAgudos = sumAgudos / (fft.specSize() - 40);
      
      // Detección de beats con cooldown
      detectarBeats();
    } catch (Exception e) {
      // Si hay algún error en el análisis, simplemente continuamos sin actualizar los niveles
      println("Error en el análisis de audio: " + e.getMessage());
    }
  }
  
  private void detectarBeats() {
    // Gestionar cooldowns
    if (cooldownGraves > 0) cooldownGraves--;
    if (cooldownAgudos > 0) cooldownAgudos--;
    
    // Reset de estados
    beatGraves = false;
    beatAgudos = false;
    
    // Detección de beats
    if (nivelGraves > umbralBeatGraves && cooldownGraves == 0) {
      beatGraves = true;
      cooldownGraves = TIEMPO_COOLDOWN;
    }
    
    if (nivelAgudos > umbralBeatAgudos && cooldownAgudos == 0) {
      beatAgudos = true;
      cooldownAgudos = TIEMPO_COOLDOWN;
    }
  }
  
  boolean hayBeatGraves() {
    return beatGraves;
  }
  
  boolean hayBeatAgudos() {
    return beatAgudos;
  }
  
  float getNivelGraves() {
    return nivelGraves;
  }
  
  float getNivelMedios() {
    return nivelMedios;
  }
  
  float getNivelAgudos() {
    return nivelAgudos;
  }
  
  void close() {
    if (player != null) {
      player.close();
    }
    minim.stop();
  }
}