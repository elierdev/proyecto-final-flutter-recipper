// Modelo de datos para Receta
class Receta {
  final int? id;
  final String nombre;
  final String descripcion;
  final String ingredientes;
  final String instrucciones;
  final String categoria;
  final int tiempoPreparacion;
  final String dificultad;
  final String imagen;
  final bool esFavorita;
  final int likes;
  final DateTime fechaCreacion;

  Receta({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.ingredientes,
    required this.instrucciones,
    required this.categoria,
    required this.tiempoPreparacion,
    required this.dificultad,
    required this.imagen,
    this.esFavorita = false,
    this.likes = 0,
    DateTime? fechaCreacion,
  }) : fechaCreacion = fechaCreacion ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'ingredientes': ingredientes,
      'instrucciones': instrucciones,
      'categoria': categoria,
      'tiempoPreparacion': tiempoPreparacion,
      'dificultad': dificultad,
      'imagen': imagen,
      'esFavorita': esFavorita ? 1 : 0,
      'likes': likes,
      'fechaCreacion': fechaCreacion.millisecondsSinceEpoch,
    };
  }

  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      id: map['id'],
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      ingredientes: map['ingredientes'],
      instrucciones: map['instrucciones'],
      categoria: map['categoria'],
      tiempoPreparacion: map['tiempoPreparacion'],
      dificultad: map['dificultad'],
      imagen: map['imagen'],
      esFavorita: map['esFavorita'] == 1,
      likes: map['likes'],
      fechaCreacion: DateTime.fromMillisecondsSinceEpoch(map['fechaCreacion']),
    );
  }

  Receta copyWith({
    int? id,
    String? nombre,
    String? descripcion,
    String? ingredientes,
    String? instrucciones,
    String? categoria,
    int? tiempoPreparacion,
    String? dificultad,
    String? imagen,
    bool? esFavorita,
    int? likes,
    DateTime? fechaCreacion,
  }) {
    return Receta(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      descripcion: descripcion ?? this.descripcion,
      ingredientes: ingredientes ?? this.ingredientes,
      instrucciones: instrucciones ?? this.instrucciones,
      categoria: categoria ?? this.categoria,
      tiempoPreparacion: tiempoPreparacion ?? this.tiempoPreparacion,
      dificultad: dificultad ?? this.dificultad,
      imagen: imagen ?? this.imagen,
      esFavorita: esFavorita ?? this.esFavorita,
      likes: likes ?? this.likes,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
    );
  }
}
