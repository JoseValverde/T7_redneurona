class ElementoSeguidor extends ElementoBase {
  private ElementoBase objetivo;
  private float delay;
  private PVector posicionObjetivo;
  private color colorObjetivo;
  private PVector posicionInicial; // Posición inicial respecto al padre
  private float distanciaBase; // Distancia al que debe mantener del objetivo
  
  ElementoSeguidor(PVector posicion, float tamano, color c, ElementoBase objetivo, float delay) {
    super(posicion, tamano, c);
    this.objetivo = objetivo;
    this.delay = delay;
    this.posicionObjetivo = objetivo.getPosicion().copy();
    this.colorObjetivo = objetivo.getColor();
    
    // Calcular vector diferencia inicial desde el objetivo
    this.posicionInicial = PVector.sub(posicion, objetivo.getPosicion());
    this.distanciaBase = posicionInicial.mag();
  }
  
  @Override
  void actualizar() {
    // Actualizar posición objetivo con delay
    posicionObjetivo = objetivo.getPosicion().copy();
    colorObjetivo = objetivo.getColor();
    
    // Calcular vector dirección manteniendo la orientación original
    PVector direccionOriginal = posicionInicial.copy();
    
    // Aplicar una pequeña rotación aleatoria para evitar que todos se agrupen en la misma dirección
    direccionOriginal.rotate(random(-0.02, 0.02));
    
    // Normalizar y ajustar a la distancia base
    direccionOriginal.normalize();
    direccionOriginal.mult(distanciaBase);
    
    // Calcular posición ideal basada en la distancia original
    PVector posicionIdeal = PVector.add(posicionObjetivo, direccionOriginal);
    
    // Movimiento suave hacia la posición ideal con factor de delay
    PVector direccion = PVector.sub(posicionIdeal, posicion);
    direccion.mult(0.05 / delay); // Velocidad de seguimiento reducida
    posicion.add(direccion);
    
    // Transición suave del color
    colorActual = lerpColor(colorActual, colorObjetivo, 0.1 / delay);
    
    // Rebote en los bordes
    if (posicion.x < 0 || posicion.x > width) {
      posicion.x = constrain(posicion.x, 0, width);
    }
    if (posicion.y < 0 || posicion.y > height) {
      posicion.y = constrain(posicion.y, 0, height);
    }
    if (posicion.z < -200 || posicion.z > 200) {
      posicion.z = constrain(posicion.z, -200, 200);
    }
  }
}