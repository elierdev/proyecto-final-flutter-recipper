import 'package:flutter/material.dart';
import 'recetas_por_categoria.dart';

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