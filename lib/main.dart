// pubspec.yaml dependencies needed:
// flutter:
//   sdk: flutter
// sqflite: ^2.3.0
// path: ^1.8.3
// cached_network_image: ^3.3.0
// share_plus: ^7.2.1
// image_picker: ^1.0.4

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' show join;
import 'dart:async';
import 'dart:math';

void main() {
  runApp(RecetasApp());
}

class RecetasApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas Deliciosas',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: Color(0xFFFF6B35),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFF6B35),
          elevation: 0,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFF6B35),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Colors.white,
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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

// Base de datos helper
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'recetas.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE recetas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nombre TEXT NOT NULL,
        descripcion TEXT NOT NULL,
        ingredientes TEXT NOT NULL,
        instrucciones TEXT NOT NULL,
        categoria TEXT NOT NULL,
        tiempoPreparacion INTEGER NOT NULL,
        dificultad TEXT NOT NULL,
        imagen TEXT NOT NULL,
        esFavorita INTEGER NOT NULL DEFAULT 0,
        likes INTEGER NOT NULL DEFAULT 0,
        fechaCreacion INTEGER NOT NULL
      )
    ''');

    // Insertar datos de ejemplo
    await _insertarDatosEjemplo(db);
  }

  Future<void> _insertarDatosEjemplo(Database db) async {
    List<Receta> recetasEjemplo = [
      Receta(
        nombre: 'Pasta Carbonara',
        descripcion: 'Deliciosa pasta italiana con huevo, queso y panceta',
        ingredientes: '400g pasta, 200g panceta, 4 huevos, 100g queso parmesano, pimienta negra, sal',
        instrucciones: '1. Hervir la pasta\n2. Freír la panceta\n3. Batir huevos con queso\n4. Mezclar todo fuera del fuego',
        categoria: 'Pasta',
        tiempoPreparacion: 25,
        dificultad: 'Medio',
        imagen: 'https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?w=500',
        likes: 15,
      ),
      Receta(
        nombre: 'Tacos al Pastor',
        descripcion: 'Auténticos tacos mexicanos con carne marinada',
        ingredientes: '1kg cerdo, achiote, piña, cebolla, cilantro, tortillas, salsa verde',
        instrucciones: '1. Marinar la carne\n2. Asar en trompo\n3. Cortar finamente\n4. Servir en tortillas calientes',
        categoria: 'Mexicana',
        tiempoPreparacion: 45,
        dificultad: 'Difícil',
        imagen: 'https://images.unsplash.com/photo-1565299624946-b28f40a0ca4b?w=500',
        likes: 22,
      ),
      Receta(
        nombre: 'Ensalada César',
        descripcion: 'Fresca ensalada con aderezo cremoso y crutones',
        ingredientes: 'Lechuga romana, pollo a la plancha, queso parmesano, crutones, aderezo césar',
        instrucciones: '1. Lavar y cortar lechuga\n2. Preparar pollo a la plancha\n3. Hacer crutones\n4. Mezclar con aderezo',
        categoria: 'Ensaladas',
        tiempoPreparacion: 20,
        dificultad: 'Fácil',
        imagen: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
        likes: 8,
      ),
      Receta(
        nombre: 'Sushi Rolls',
        descripcion: 'Deliciosos rollos de sushi caseros',
        ingredientes: 'Arroz para sushi, nori, salmón, pepino, palta, wasabi, jengibre',
        instrucciones: '1. Preparar arroz de sushi\n2. Extender nori\n3. Agregar relleno\n4. Enrollar y cortar',
        categoria: 'Japonesa',
        tiempoPreparacion: 40,
        dificultad: 'Difícil',
        imagen: 'https://images.unsplash.com/photo-1579584425555-c3ce17fd4351?w=500',
        likes: 31,
      ),
      Receta(
        nombre: 'Pizza Margherita',
        descripcion: 'Clásica pizza italiana con albahaca fresca',
        ingredientes: 'Masa de pizza, salsa de tomate, mozzarella, albahaca fresca, aceite de oliva',
        instrucciones: '1. Extender la masa\n2. Aplicar salsa\n3. Agregar queso\n4. Hornear 12 minutos\n5. Decorar con albahaca',
        categoria: 'Italiana',
        tiempoPreparacion: 30,
        dificultad: 'Medio',
        imagen: 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500',
        likes: 18,
      ),
    ];

    for (Receta receta in recetasEjemplo) {
      await db.insert('recetas', receta.toMap());
    }
  }

  Future<int> insertarReceta(Receta receta) async {
    final db = await database;
    return await db.insert('recetas', receta.toMap());
  }

  Future<List<Receta>> obtenerRecetas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('recetas');
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> obtenerRecetasPorCategoria(String categoria) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'categoria = ?',
      whereArgs: [categoria],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> obtenerFavoritas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'esFavorita = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<List<Receta>> buscarRecetas(String query) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'recetas',
      where: 'nombre LIKE ? OR ingredientes LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
    );
    return List.generate(maps.length, (i) => Receta.fromMap(maps[i]));
  }

  Future<int> actualizarReceta(Receta receta) async {
    final db = await database;
    return await db.update(
      'recetas',
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }

  Future<int> eliminarReceta(int id) async {
    final db = await database;
    return await db.delete(
      'recetas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}

// Página principal con navegación inferior
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    RecetasListPage(),
    CategoriasPage(),
    FavoritasPage(),
    PerfilPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController.animateToPage(
              index,
              duration: Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Color(0xFFFF6B35),
          unselectedItemColor: Colors.grey[600],
          backgroundColor: Colors.white,
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Inicio',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category_outlined),
              activeIcon: Icon(Icons.category),
              label: 'Categorías',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Favoritas',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Perfil',
            ),
          ],
        ),
      ),
    );
  }
}

// Página de lista de recetas
class RecetasListPage extends StatefulWidget {
  @override
  _RecetasListPageState createState() => _RecetasListPageState();
}

class _RecetasListPageState extends State<RecetasListPage> {
  List<Receta> recetas = [];
  List<Receta> recetasFiltradas = [];
  TextEditingController _searchController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
    _searchController.addListener(_filtrarRecetas);
  }

  Future<void> _cargarRecetas() async {
    final recetasDB = await _dbHelper.obtenerRecetas();
    setState(() {
      recetas = recetasDB;
      recetasFiltradas = recetasDB;
    });
  }

  void _filtrarRecetas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      recetasFiltradas = recetas.where((receta) {
        return receta.nombre.toLowerCase().contains(query) ||
            receta.ingredientes.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recetas Deliciosas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AgregarRecetaPage()),
              ).then((_) => _cargarRecetas());
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[50],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar recetas...',
                prefixIcon: Icon(Icons.search, color: Color(0xFFFF6B35)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: recetasFiltradas.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: recetasFiltradas.length,
                    itemBuilder: (context, index) {
                      return _buildRecetaCard(recetasFiltradas[index]);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No se encontraron recetas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta con otros términos de búsqueda',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecetaCard(Receta receta) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleRecetaPage(receta: receta),
            ),
          ).then((_) => _cargarRecetas());
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35).withOpacity(0.8),
                      Color(0xFFFF8C42).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 60,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          receta.nombre,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(receta.dificultad),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          receta.dificultad,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    receta.descripcion,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 16, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        '${receta.tiempoPreparacion} min',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(width: 16),
                      Icon(Icons.category, size: 16, color: Colors.grey[500]),
                      SizedBox(width: 4),
                      Text(
                        receta.categoria,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => _toggleLike(receta),
                        child: Row(
                          children: [
                            Icon(
                              Icons.favorite,
                              size: 20,
                              color: Color(0xFFFF6B35),
                            ),
                            SizedBox(width: 4),
                            Text(
                              '${receta.likes}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFFF6B35),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String dificultad) {
    switch (dificultad.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _toggleLike(Receta receta) async {
    final recetaActualizada = receta.copyWith(
      likes: receta.likes + 1,
    );
    await _dbHelper.actualizarReceta(recetaActualizada);
    _cargarRecetas();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Página de detalle de receta
class DetalleRecetaPage extends StatefulWidget {
  final Receta receta;

  DetalleRecetaPage({required this.receta});

  @override
  _DetalleRecetaPageState createState() => _DetalleRecetaPageState();
}

class _DetalleRecetaPageState extends State<DetalleRecetaPage> {
  late Receta receta;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    receta = widget.receta;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFFF8C42),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 100,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  receta.esFavorita ? Icons.favorite : Icons.favorite_border,
                  color: Colors.white,
                ),
                onPressed: _toggleFavorito,
              ),
              IconButton(
                icon: Icon(Icons.share, color: Colors.white),
                onPressed: _compartirReceta,
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receta.nombre,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    receta.descripcion,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.access_time,
                        '${receta.tiempoPreparacion} min',
                        Colors.blue,
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.signal_cellular_alt,
                        receta.dificultad,
                        _getDifficultyColor(receta.dificultad),
                      ),
                      SizedBox(width: 12),
                      _buildInfoChip(
                        Icons.category,
                        receta.categoria,
                        Colors.purple,
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: _darLike,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: Color(0xFFFF6B35),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.favorite, color: Colors.white, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Me gusta (${receta.likes})',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  _buildSection('Ingredientes', receta.ingredientes, Icons.list),
                  SizedBox(height: 25),
                  _buildSection('Instrucciones', receta.instrucciones, Icons.list_alt),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String titulo, String contenido, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFFFF6B35), size: 24),
            SizedBox(width: 8),
            Text(
              titulo,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Text(
            contenido,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }

  Color _getDifficultyColor(String dificultad) {
    switch (dificultad.toLowerCase()) {
      case 'fácil':
        return Colors.green;
      case 'medio':
        return Colors.orange;
      case 'difícil':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> _toggleFavorito() async {
    final recetaActualizada = receta.copyWith(
      esFavorita: !receta.esFavorita,
    );
    await _dbHelper.actualizarReceta(recetaActualizada);
    setState(() {
      receta = recetaActualizada;
    });
  }

  Future<void> _darLike() async {
    final recetaActualizada = receta.copyWith(
      likes: receta.likes + 1,
    );
    await _dbHelper.actualizarReceta(recetaActualizada);
    setState(() {
      receta = recetaActualizada;
    });
  }

  void _compartirReceta() {
    // Simular compartir receta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Receta compartida!'),
        backgroundColor: Color(0xFFFF6B35),
      ),
    );
  }
}

// Página de categorías
class CategoriasPage extends StatefulWidget {
  @override
  _CategoriasPageState createState() => _CategoriasPageState();
}

class _CategoriasPageState extends State<CategoriasPage> {
  final List<Map<String, dynamic>> categorias = [
    {'nombre': 'Italiana', 'icon': Icons.local_pizza, 'color': Colors.red},
    {'nombre': 'Mexicana', 'icon': Icons.restaurant, 'color': Colors.green},
    {'nombre': 'Japonesa', 'icon': Icons.ramen_dining, 'color': Colors.pink},
    {'nombre': 'Pasta', 'icon': Icons.dining, 'color': Colors.orange},
    {'nombre': 'Ensaladas', 'icon': Icons.eco, 'color': Colors.teal},
    {'nombre': 'Postres', 'icon': Icons.cake, 'color': Colors.purple},
    {'nombre': 'Carnes', 'icon': Icons.lunch_dining, 'color': Colors.brown},
    {'nombre': 'Vegetariana', 'icon': Icons.nature, 'color': Colors.lightGreen},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categorías'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categorias.length,
          itemBuilder: (context, index) {
            return _buildCategoriaCard(categorias[index]);
          },
        ),
      ),
    );
  }

  Widget _buildCategoriaCard(Map<String, dynamic> categoria) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecetasPorCategoriaPage(
                categoria: categoria['nombre'],
              ),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                categoria['color'].withOpacity(0.8),
                categoria['color'].withOpacity(0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                categoria['icon'],
                size: 50,
                color: Colors.white,
              ),
              SizedBox(height: 12),
              Text(
                categoria['nombre'],
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de recetas por categoría
class RecetasPorCategoriaPage extends StatefulWidget {
  final String categoria;

  RecetasPorCategoriaPage({required this.categoria});

  @override
  _RecetasPorCategoriaPageState createState() => _RecetasPorCategoriaPageState();
}

class _RecetasPorCategoriaPageState extends State<RecetasPorCategoriaPage> {
  List<Receta> recetas = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarRecetasPorCategoria();
  }

  Future<void> _cargarRecetasPorCategoria() async {
    final recetasDB = await _dbHelper.obtenerRecetasPorCategoria(widget.categoria);
    setState(() {
      recetas = recetasDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.categoria}'),
      ),
      body: recetas.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: recetas.length,
              itemBuilder: (context, index) {
                return _buildRecetaCard(recetas[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.restaurant_menu,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No hay recetas en esta categoría',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecetaCard(Receta receta) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleRecetaPage(receta: receta),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B35).withOpacity(0.8),
                      Color(0xFFFF8C42).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      receta.nombre,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      receta.descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          '${receta.tiempoPreparacion} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.favorite, size: 14, color: Color(0xFFFF6B35)),
                        SizedBox(width: 4),
                        Text(
                          '${receta.likes}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFF6B35),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de favoritas
class FavoritasPage extends StatefulWidget {
  @override
  _FavoritasPageState createState() => _FavoritasPageState();
}

class _FavoritasPageState extends State<FavoritasPage> {
  List<Receta> favoritas = [];
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarFavoritas();
  }

  Future<void> _cargarFavoritas() async {
    final favoritasDB = await _dbHelper.obtenerFavoritas();
    setState(() {
      favoritas = favoritasDB;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritas'),
      ),
      body: favoritas.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: favoritas.length,
              itemBuilder: (context, index) {
                return _buildFavoritaCard(favoritas[index]);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No tienes recetas favoritas',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Marca tus recetas favoritas para verlas aquí',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritaCard(Receta receta) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetalleRecetaPage(receta: receta),
            ),
          ).then((_) => _cargarFavoritas());
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B35).withOpacity(0.8),
                      Color(0xFFFF8C42).withOpacity(0.6),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.restaurant,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            receta.nombre,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                        ),
                        Icon(
                          Icons.favorite,
                          color: Color(0xFFFF6B35),
                          size: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      receta.descripcion,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          '${receta.tiempoPreparacion} min',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(width: 16),
                        Icon(Icons.category, size: 14, color: Colors.grey[500]),
                        SizedBox(width: 4),
                        Text(
                          receta.categoria,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Página de perfil
class PerfilPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Perfil'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 60,
              backgroundColor: Color(0xFFFF6B35),
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Chef Usuario',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Amante de la cocina',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 30),
            _buildEstadistica(),
            SizedBox(height: 30),
            _buildMenuOption(
              Icons.receipt_long,
              'Mis Recetas',
              'Ver todas tus recetas creadas',
              () {},
            ),
            _buildMenuOption(
              Icons.favorite,
              'Favoritas',
              'Recetas que más te gustan',
              () {},
            ),
            _buildMenuOption(
              Icons.settings,
              'Configuración',
              'Ajustes de la aplicación',
              () {},
            ),
            _buildMenuOption(
              Icons.help_outline,
              'Ayuda',
              'Soporte y preguntas frecuentes',
              () {},
            ),
            _buildMenuOption(
              Icons.info_outline,
              'Acerca de',
              'Información de la aplicación',
              () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEstadistica() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildEstadisticaItem('Recetas', '12', Icons.restaurant_menu),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildEstadisticaItem('Favoritas', '8', Icons.favorite),
          Container(width: 1, height: 40, color: Colors.grey[300]),
          _buildEstadisticaItem('Likes', '156', Icons.thumb_up),
        ],
      ),
    );
  }

  Widget _buildEstadisticaItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Color(0xFFFF6B35), size: 24),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuOption(
    IconData icon,
    String titulo,
    String subtitulo,
    VoidCallback onTap,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFFFF6B35).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFFFF6B35)),
        ),
        title: Text(
          titulo,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        subtitle: Text(
          subtitulo,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
        onTap: onTap,
      ),
    );
  }
}

// Página para agregar nueva receta
class AgregarRecetaPage extends StatefulWidget {
  @override
  _AgregarRecetaPageState createState() => _AgregarRecetaPageState();
}

class _AgregarRecetaPageState extends State<AgregarRecetaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nombreController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _ingredientesController = TextEditingController();
  final _instruccionesController = TextEditingController();
  final _tiempoController = TextEditingController();

  String _categoriaSeleccionada = 'Italiana';
  String _dificultadSeleccionada = 'Fácil';

  final List<String> _categorias = [
    'Italiana',
    'Mexicana',
    'Japonesa',
    'Pasta',
    'Ensaladas',
    'Postres',
    'Carnes',
    'Vegetariana',
  ];

  final List<String> _dificultades = ['Fácil', 'Medio', 'Difícil'];

  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nueva Receta'),
        actions: [
          TextButton(
            onPressed: _guardarReceta,
            child: Text(
              'Guardar',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre de la receta',
                icon: Icons.restaurant_menu,
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _descripcionController,
                label: 'Descripción',
                icon: Icons.description,
                maxLines: 2,
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdown(
                      value: _categoriaSeleccionada,
                      label: 'Categoría',
                      items: _categorias,
                      onChanged: (value) {
                        setState(() {
                          _categoriaSeleccionada = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: _buildDropdown(
                      value: _dificultadSeleccionada,
                      label: 'Dificultad',
                      items: _dificultades,
                      onChanged: (value) {
                        setState(() {
                          _dificultadSeleccionada = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _tiempoController,
                label: 'Tiempo de preparación (minutos)',
                icon: Icons.access_time,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value?.isEmpty ?? true) return 'Campo requerido';
                  if (int.tryParse(value!) == null) return 'Debe ser un número';
                  return null;
                },
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _ingredientesController,
                label: 'Ingredientes',
                icon: Icons.list,
                maxLines: 4,
                hint: 'Separa cada ingrediente con una nueva línea',
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              SizedBox(height: 20),
              _buildTextField(
                controller: _instruccionesController,
                label: 'Instrucciones',
                icon: Icons.list_alt,
                maxLines: 6,
                hint: 'Describe paso a paso cómo preparar la receta',
                validator: (value) => value?.isEmpty ?? true ? 'Campo requerido' : null,
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _guardarReceta,
                  child: Text(
                    'Crear Receta',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFFFF6B35)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required String label,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFFF6B35), width: 2),
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  Future<void> _guardarReceta() async {
    if (_formKey.currentState!.validate()) {
      final nuevaReceta = Receta(
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        ingredientes: _ingredientesController.text,
        instrucciones: _instruccionesController.text,
        categoria: _categoriaSeleccionada,
        tiempoPreparacion: int.parse(_tiempoController.text),
        dificultad: _dificultadSeleccionada,
        imagen: 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
      );

      await _dbHelper.insertarReceta(nuevaReceta);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('¡Receta creada exitosamente!'),
          backgroundColor: Color(0xFFFF6B35),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _descripcionController.dispose();
    _ingredientesController.dispose();
    _instruccionesController.dispose();
    _tiempoController.dispose();
    super.dispose();
  }
}