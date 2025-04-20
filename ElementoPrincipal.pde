class ElementoPrincipal extends ElementoBase {
  private ArrayList<ElementoSeguidor> seguidores;
  
  ElementoPrincipal(PVector posicion, float tamano, color c) {
    super(posicion, tamano, c);
    seguidores = new ArrayList<ElementoSeguidor>();
  }
  
  void cambiarDireccion() {
    // Cambiar dirección aleatoriamente cuando hay un sonido grave
    float amplitud = 0.3;
    aceleracion = new PVector(
      random(-amplitud, amplitud), 
      random(-amplitud, amplitud), 
      random(-amplitud, amplitud)
    );
  }
  
  void generarRedNeuronal(int hijosPorNodo, int profundidad) {
    // Crear red neuronal recursivamente
    generarSeguidores(this, hijosPorNodo, profundidad, 0);
  }
  
  private void generarSeguidores(ElementoBase padre, int hijosPorNodo, int profundidadMax, int profundidadActual) {
    if (profundidadActual >= profundidadMax) return;
    
    // Calcular separación base según el nivel de profundidad
    // Más separación en los niveles superiores, menos en los niveles profundos
    float separacionBase = 100 + (profundidadMax - profundidadActual) * 50;
    
    for (int i = 0; i < hijosPorNodo; i++) {
      // Distribuir los hijos de forma más uniforme usando ángulos
      float angulo = TWO_PI / hijosPorNodo * i + random(-0.5, 0.5);
      float distancia = separacionBase + random(-20, 20);
      
      // Crear variación de posición más amplia basada en ángulos para mejor distribución espacial
      PVector variacion = new PVector(
        cos(angulo) * distancia,
        sin(angulo) * distancia,
        random(-separacionBase/2, separacionBase/2)
      );
      
      PVector posicionHijo = padre.getPosicion().copy().add(variacion);
      // Asegurar que los elementos no salgan demasiado fuera de la pantalla
      posicionHijo.x = constrain(posicionHijo.x, 50, width-50);
      posicionHijo.y = constrain(posicionHijo.y, 50, height-50);
      
      ElementoSeguidor hijo = new ElementoSeguidor(
        posicionHijo, 
        tamano * (0.8 - profundidadActual * 0.1),  // Reducción de tamaño más pronunciada según profundidad
        colorActual,
        padre,
        random(0.5, 1.5)  // Delay aleatorio
      );
      
      seguidores.add(hijo);
      padre.conectarCon(hijo);
      hijo.conectarCon(padre);
      
      // Recursivamente generar hijos para este seguidor
      generarSeguidores(hijo, hijosPorNodo, profundidadMax, profundidadActual + 1);
    }
  }
  
  @Override
  void actualizar() {
    super.actualizar();
    
    // Actualizar todos los seguidores
    for (ElementoSeguidor seguidor : seguidores) {
      seguidor.actualizar();
    }
  }
  
  @Override
  void mostrar() {
    super.mostrar();
    
    // Mostrar todos los seguidores
    for (ElementoSeguidor seguidor : seguidores) {
      seguidor.mostrar();
    }
  }
  
  @Override
  void dibujarConexiones() {
    super.dibujarConexiones();
    
    // Dibujar conexiones de todos los seguidores
    for (ElementoSeguidor seguidor : seguidores) {
      seguidor.dibujarConexiones();
    }
  }
  
  int getNumeroElementos() {
    return 1 + seguidores.size(); // El elemento principal + todos sus seguidores
  }
}