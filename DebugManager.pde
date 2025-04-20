class DebugManager {
  
  void mostrarInformacion(ElementoPrincipal ep, AudioManager audio) {
    pushMatrix();
    hint(DISABLE_DEPTH_TEST);
    camera();
    noLights();
    
    // Panel de fondo
    fill(0, 180);
    rect(10, 10, 300, 200);
    
    fill(TEXTO);
    textAlign(LEFT);
    textSize(14);
    
    // Información del Elemento Principal
    text("Elemento Principal:", 20, 30);
    text("Posición: " + formatVector(ep.getPosicion()), 20, 50);
    text("Color: " + formatColor(ep.getColor()), 20, 70);
    text("Elementos totales: " + ep.getNumeroElementos(), 20, 90);
    
    // Información del Audio
    text("Audio:", 20, 120);
    
    // Barras de niveles de audio
    float barWidth = 200;
    float barHeight = 15;
    float x = 80;
    float y = 140;
    
    // Graves
    text("Graves:", 20, y);
    fill(SECUNDARIO);
    rect(x, y - barHeight, barWidth * audio.getNivelGraves(), barHeight);
    text(nf(audio.getNivelGraves(), 1, 2), x + barWidth * audio.getNivelGraves() + 5, y);
    
    // Medios
    y += 25;
    fill(TEXTO);
    text("Medios:", 20, y);
    fill(PRIMARIO);
    rect(x, y - barHeight, barWidth * audio.getNivelMedios(), barHeight);
    text(nf(audio.getNivelMedios(), 1, 2), x + barWidth * audio.getNivelMedios() + 5, y);
    
    // Agudos
    y += 25;
    fill(TEXTO);
    text("Agudos:", 20, y);
    fill(ACENTO);
    rect(x, y - barHeight, barWidth * audio.getNivelAgudos(), barHeight);
    text(nf(audio.getNivelAgudos(), 1, 2), x + barWidth * audio.getNivelAgudos() + 5, y);
    
    hint(ENABLE_DEPTH_TEST);
    popMatrix();
  }
  
  private String formatVector(PVector v) {
    return "(" + nf(v.x, 1, 1) + ", " + nf(v.y, 1, 1) + ", " + nf(v.z, 1, 1) + ")";
  }
  
  private String formatColor(color c) {
    return "(" + int(red(c)) + ", " + int(green(c)) + ", " + int(blue(c)) + ")";
  }
}