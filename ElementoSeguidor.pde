class ElementoSeguidor extends ElementoBase {
  private ElementoBase objetivo;
  private float delay;
  private PVector posicionObjetivo;
  private color colorObjetivo;
  private PVector posicionInicial;
  private float distanciaFija; // Distancia que debe mantener del objetivo
  private float factorSuavizado = 0.05; // Factor para suavizar el movimiento
  
  ElementoSeguidor(PVector posicion, float tamano, color c, ElementoBase objetivo, float delay) {
    super(posicion, tamano, c);
    this.objetivo = objetivo;
    this.delay = delay;
    this.posicionObjetivo = objetivo.getPosicion().copy();
    this.colorObjetivo = objetivo.getColor();
    
    // Calcular y guardar la distancia fija inicial
    this.posicionInicial = PVector.sub(posicion, objetivo.getPosicion());
    this.distanciaFija = posicionInicial.mag();
  }
  
  @Override
  void actualizar() {
    // Primero aplicar la física básica heredada
    super.actualizar();
    
    // Actualizar posición objetivo
    posicionObjetivo = objetivo.getPosicion().copy();
    colorObjetivo = objetivo.getColor();
    
    // Calcular vector dirección desde el objetivo hasta la posición actual
    PVector direccionActual = PVector.sub(posicion, posicionObjetivo);
    float distanciaActual = direccionActual.mag();
    
    // Solo ajustar si hay una diferencia significativa en la distancia
    if (distanciaActual > 0) {  // Evitar división por cero
      direccionActual.normalize();
      
      // Calcular la posición ideal a la distancia fija
      PVector posicionIdeal = PVector.add(posicionObjetivo, PVector.mult(direccionActual, distanciaFija));
      
      // Calcular el vector de movimiento necesario
      PVector direccionMovimiento = PVector.sub(posicionIdeal, posicion);
      
      // Aplicar suavizado basado en la distancia al punto ideal y el delay
      float factorDistancia = constrain(direccionMovimiento.mag() / distanciaFija, 0, 1);
      float factorMovimiento = factorSuavizado * (1 + factorDistancia) / delay;
      
      // Aplicar el movimiento suavizado
      direccionMovimiento.mult(factorMovimiento);
      posicion.add(direccionMovimiento);
    }
    
    // Transición suave del color
    colorActual = lerpColor(colorActual, colorObjetivo, 0.1 / delay);
    
    // Mantener dentro de los límites
    posicion.x = constrain(posicion.x, 0, width);
    posicion.y = constrain(posicion.y, 0, height);
    posicion.z = constrain(posicion.z, -200, 200);
  }
}