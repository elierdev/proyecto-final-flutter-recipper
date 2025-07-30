import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../db/database_helper.dart';
import 'agregar_receta_page.dart';


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
                icon: Icon(Icons.edit, color: Colors.white),
                onPressed: () async {
                  final resultado = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AgregarRecetaPage(
                        receta: receta,
                      ),
                    ),
                  );
                  if (resultado == true) {
                    final recetaActualizada = await _dbHelper.obtenerRecetas();
                    setState(() {
                      receta = recetaActualizada.firstWhere((r) => r.id == receta.id);
                    });
                  }
                },
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: _eliminarReceta,
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

  Future<void> _eliminarReceta() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Eliminar receta'),
        content: Text('¿Estás seguro de que deseas eliminar esta receta?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _dbHelper.eliminarReceta(receta.id!);
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Receta eliminada'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}