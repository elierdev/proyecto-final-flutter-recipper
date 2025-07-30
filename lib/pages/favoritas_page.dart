import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../db/database_helper.dart';
import 'detalle_receta_page.dart';

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