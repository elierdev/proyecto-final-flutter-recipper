import 'package:flutter/material.dart';
import '../models/receta.dart';
import '../db/database_helper.dart';

class AgregarRecetaPage extends StatefulWidget {
  final Receta? receta;

  AgregarRecetaPage({this.receta});

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
  void initState() {
    super.initState();
    if (widget.receta != null) {
      _cargarDatosReceta();
    }
  }

  void _cargarDatosReceta() {
    final receta = widget.receta!;
    _nombreController.text = receta.nombre;
    _descripcionController.text = receta.descripcion;
    _ingredientesController.text = receta.ingredientes;
    _instruccionesController.text = receta.instrucciones;
    _tiempoController.text = receta.tiempoPreparacion.toString();
    _categoriaSeleccionada = receta.categoria;
    _dificultadSeleccionada = receta.dificultad;
  }

  @override
  Widget build(BuildContext context) {
    final esEdicion = widget.receta != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(esEdicion ? 'Editar Receta' : 'Nueva Receta'),
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
                    esEdicion ? 'Actualizar Receta' : 'Crear Receta',
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
      final receta = widget.receta;
      final nuevaReceta = Receta(
        id: receta?.id,
        nombre: _nombreController.text,
        descripcion: _descripcionController.text,
        ingredientes: _ingredientesController.text,
        instrucciones: _instruccionesController.text,
        categoria: _categoriaSeleccionada,
        tiempoPreparacion: int.parse(_tiempoController.text),
        dificultad: _dificultadSeleccionada,
        imagen: receta?.imagen ?? 'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=500',
        esFavorita: receta?.esFavorita ?? false,
        likes: receta?.likes ?? 0,
        fechaCreacion: receta?.fechaCreacion,
      );

      if (receta != null) {
        await _dbHelper.actualizarReceta(nuevaReceta);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Receta actualizada!'), backgroundColor: Color(0xFFFF6B35)),
        );
      } else {
        await _dbHelper.insertarReceta(nuevaReceta);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('¡Receta creada exitosamente!'), backgroundColor: Color(0xFFFF6B35)),
        );
      }

      Navigator.pop(context, true);
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
