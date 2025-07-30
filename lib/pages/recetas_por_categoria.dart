import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../db/database_helper.dart';
import 'detalle_receta_page.dart';

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
