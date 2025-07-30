import 'package:flutter/material.dart';


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