import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../db/database_helper.dart';
import 'detalle_receta_page.dart';
import 'agregar_receta_page.dart';


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