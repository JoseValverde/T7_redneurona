class FondoManager {
  private PImage[] imagenes;
  private int imagenActual;
  private float opacidad;
  private float opacidadObjetivo;
  private float velocidadTransicion;
  
  FondoManager() {
    // Cargar todas las imágenes de la carpeta fondo
    File folder = new File(sketchPath("fondo"));
    File[] archivos = folder.listFiles();
    ArrayList<PImage> imagenesTemp = new ArrayList<PImage>();
    
    if (archivos != null) {
      for (File archivo : archivos) {
        String nombre = archivo.getName().toLowerCase();
        if (nombre.endsWith(".jpg") || nombre.endsWith(".jpeg") || nombre.endsWith(".png")) {
          PImage img = loadImage("fondo/" + archivo.getName());
          if (img != null) {
            // Redimensionar la imagen al tamaño de la ventana
            img.resize(width, height);
            imagenesTemp.add(img);
          }
        }
      }
    }
    
    // Convertir ArrayList a array
    imagenes = imagenesTemp.toArray(new PImage[0]);
    imagenActual = 0;
    opacidad = 255;
    opacidadObjetivo = 255;
    velocidadTransicion = 10;
  }
  
  void actualizar(float nivelGraves, boolean hayBeatGraves) {
    // Actualizar la opacidad gradualmente
    opacidad = lerp(opacidad, opacidadObjetivo, 0.1);
    
    // Cambiar de imagen cuando hay un beat de graves
    if (hayBeatGraves) {
      cambiarImagenAleatoria();
      // Iniciar transición
      opacidad = 0;
      opacidadObjetivo = 255;
    }
  }
  
  void mostrar() {
    if (imagenes != null && imagenes.length > 0) {
      // Aplicar un tinte basado en los colores de la paleta
      tint(255, opacidad);
      image(imagenes[imagenActual], 0, 0);
      noTint();
    }
  }
  
  private void cambiarImagenAleatoria() {
    if (imagenes != null && imagenes.length > 1) {
      int nuevaImagen;
      do {
        nuevaImagen = int(random(imagenes.length));
      } while (nuevaImagen == imagenActual);
      imagenActual = nuevaImagen;
    }
  }
}