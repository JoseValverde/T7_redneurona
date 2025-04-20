class ElementoPrincipal extends ElementoBase {
  private ArrayList<ElementoSeguidor> seguidores;
  private ArrayList<ElementoSeguidor> ultimoNivel; // Lista para almacenar los elementos del último nivel
  
  ElementoPrincipal(PVector posicion, float tamano, color c) {
    super(posicion, tamano, c);
    seguidores = new ArrayList<ElementoSeguidor>();
    ultimoNivel = new ArrayList<ElementoSeguidor>(); // Inicializar la lista de último nivel
  }
  
  void cambiarDireccion() {
    // Cambiar dirección aleatoriamente cuando hay un sonido grave
    float amplitud = 0.15; // Reducir la amplitud de 0.3 a 0.15 para movimientos más suaves
    aceleracion = new PVector(
      random(-amplitud, amplitud), 
      random(-amplitud, amplitud), 
      random(-amplitud, amplitud)
    );
  }
  
  void generarRedNeuronal(int hijosPorNodo, int profundidad) {
    // Limpiar la lista de elementos de último nivel si existe previamente
    ultimoNivel.clear();
    
    // Crear red neuronal recursivamente
    generarSeguidores(this, hijosPorNodo, profundidad, 0);
    
    // Después de generar toda la red, conectar los elementos del último nivel entre sí
    conectarUltimoNivel();
  }
  
  private void conectarUltimoNivel() {
    // Si hay menos de 2 elementos en el último nivel, no hay nada que conectar
    if (ultimoNivel.size() < 2) return;
    
    // Conectar cada elemento con algunos otros elementos del mismo nivel
    for (int i = 0; i < ultimoNivel.size(); i++) {
      ElementoSeguidor actual = ultimoNivel.get(i);
      
      // Conectar con el siguiente (con cierre circular al final)
      int siguienteIndex = (i + 1) % ultimoNivel.size();
      ElementoSeguidor siguiente = ultimoNivel.get(siguienteIndex);
      
      actual.conectarCon(siguiente);
      siguiente.conectarCon(actual);
      
      // Conectar con un elemento aleatorio diferente (para crear más conexiones)
      if (ultimoNivel.size() > 2) {
        int aleatorioIndex;
        do {
          aleatorioIndex = int(random(ultimoNivel.size()));
        } while (aleatorioIndex == i || aleatorioIndex == siguienteIndex);
        
        ElementoSeguidor aleatorio = ultimoNivel.get(aleatorioIndex);
        actual.conectarCon(aleatorio);
        aleatorio.conectarCon(actual);
      }
    }
  }
  
  private void generarSeguidores(ElementoBase padre, int hijosPorNodo, int profundidadMax, int profundidadActual) {
    if (profundidadActual >= profundidadMax) return;
    
    // Calcular separación base según el nivel de profundidad
    // Más separación en los niveles superiores, menos en los niveles profundos
    float separacionBase = 200 + (profundidadMax - profundidadActual) * 50;
    
    // Flag para saber si estamos en el último nivel de profundidad
    boolean esUltimoNivel = (profundidadActual == profundidadMax - 1);
    
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
      
      // Si es el último nivel, añadir el elemento a la lista de último nivel
      if (esUltimoNivel) {
        ultimoNivel.add(hijo);
      }
      
      // Recursivamente generar hijos para este seguidor
      generarSeguidores(hijo, hijosPorNodo, profundidadMax, profundidadActual + 1);
    }
  }
  
  // Método para aplicar impulso aleatorio a todos los elementos cuando hay un beat agudo
  void aplicarImpulsoATodos(float intensidad) {
    // Aplicar impulso al elemento principal
    aplicarImpulsoAleatorio(intensidad);
    
    // Aplicar impulso a todos los seguidores
    for (ElementoSeguidor seguidor : seguidores) {
      seguidor.aplicarImpulsoAleatorio(intensidad);
    }
  }
  
  @Override
  void actualizar() {
    // Calcular vector hacia el centro
    PVector centro = new PVector(width/2, height/2, 0);
    PVector direccionCentro = PVector.sub(centro, posicion);
    
    // Aplicar fuerza hacia el centro con intensidad proporcional a la distancia
    float distancia = direccionCentro.mag();
    direccionCentro.normalize();
    direccionCentro.mult(distancia * 0.001); // Factor de atracción suave
    
    // Añadir la fuerza de atracción a la aceleración
    aceleracion.add(direccionCentro);
    
    // Crear lista con todos los elementos para el distanciamiento
    ArrayList<ElementoBase> todosElementos = new ArrayList<ElementoBase>();
    todosElementos.add(this);
    todosElementos.addAll(seguidores);
    
    // Aplicar distanciamiento al elemento principal
    mantenerDistancia(todosElementos);
    
    // Llamar al método actualizar de la clase padre
    super.actualizar();
    
    // Actualizar todos los seguidores y aplicar distanciamiento
    for (ElementoSeguidor seguidor : seguidores) {
      seguidor.mantenerDistancia(todosElementos);
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