class ElementoBase {
  protected PVector posicion;
  protected PVector velocidad;
  protected PVector aceleracion;
  protected color colorActual;
  protected float tamano;
  protected ArrayList<ElementoBase> elementosConectados;
  
  ElementoBase(PVector posicion, float tamano, color c) {
    this.posicion = posicion.copy();
    this.tamano = tamano;
    this.colorActual = c;
    this.velocidad = new PVector(0, 0, 0);
    this.aceleracion = new PVector(random(-0.1, 0.1), random(-0.1, 0.1), random(-0.1, 0.1));
    this.elementosConectados = new ArrayList<ElementoBase>();
  }
  
  void actualizar() {
    // Física básica: actualizar velocidad y posición
    velocidad.add(aceleracion);
    velocidad.limit(3);  // Limitar velocidad máxima
    posicion.add(velocidad);
    
    // Rebote en los bordes
    if (posicion.x < 0 || posicion.x > width) {
      velocidad.x *= -1;
    }
    if (posicion.y < 0 || posicion.y > height) {
      velocidad.y *= -1;
    }
    if (posicion.z < -200 || posicion.z > 200) {
      velocidad.z *= -1;
    }
  }
  
  void mostrar() {
    pushMatrix();
    translate(posicion.x, posicion.y, posicion.z);
    noStroke();
    fill(colorActual);
    sphere(tamano);
    popMatrix();
  }
  
  void dibujarConexiones() {
    for (ElementoBase elemento : elementosConectados) {
      stroke(lerpColor(colorActual, elemento.colorActual, 0.5), 150);
      strokeWeight(1);
      line(posicion.x, posicion.y, posicion.z, 
           elemento.posicion.x, elemento.posicion.y, elemento.posicion.z);
    }
  }
  
  void conectarCon(ElementoBase elemento) {
    // Máximo 3 conexiones por elemento
    if (!elementosConectados.contains(elemento) && elementosConectados.size() < 3) {
      elementosConectados.add(elemento);
    }
  }
  
  void cambiarColor(color nuevoColor) {
    // Transición suave de color
    colorActual = lerpColor(colorActual, nuevoColor, 0.2);
  }
  
  void cambiarColor(color[] paleta) {
    color colorDestino = paleta[int(random(paleta.length))];
    cambiarColor(colorDestino);
  }
  
  PVector getPosicion() {
    return posicion.copy();
  }
  
  color getColor() {
    return colorActual;
  }
}