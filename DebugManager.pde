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
    text("Graves: "+ nf(audio.getNivelGraves(), 1, 2), 20, y);
    fill(SECUNDARIO);
    rect(x + 25, y - barHeight, barWidth * audio.getNivelGraves()/100, barHeight);
    



    // Medios
    y += 25;
    fill(TEXTO);
    text("Medios: "+ nf(audio.getNivelMedios(), 1, 2), 20, y);
    fill(PRIMARIO);
    rect(x +25, y - barHeight, barWidth * audio.getNivelMedios()/100, barHeight);
  
    
    // Agudos
    y += 25;
    fill(TEXTO);
    text("Agudos: "+nf(audio.getNivelAgudos(), 1, 2), 20, y);
    fill(ACENTO);
    rect(x + 25, y - barHeight, barWidth * audio.getNivelAgudos()/100, barHeight);
    
    
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