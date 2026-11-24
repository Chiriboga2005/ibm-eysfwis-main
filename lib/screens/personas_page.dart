import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../services/api_service.dart';
import 'persona_form_page.dart';

class PersonasPage extends StatefulWidget {
  const PersonasPage({super.key});

  @override
  State<PersonasPage> createState() => _PersonasPageState();
}

class _PersonasPageState extends State<PersonasPage> {
  final ApiService api = ApiService();

  late Future<List<Persona>> personas;

  @override
  void initState() {
    super.initState();
    cargarPersonas();
  }

  void cargarPersonas() {
    setState(() {
      personas = api.obtenerPersonas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Personas'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Persona>>(
        future: personas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final lista = snapshot.data ?? [];

          if (lista.isEmpty) {
            return const Center(
              child: Text('No existen personas registradas'),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => cargarPersonas(),
            child: ListView.builder(
              itemCount: lista.length,
              itemBuilder: (context, index) {
                final persona = lista[index];

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                    title: Text(persona.nombre),
                    subtitle: Text(persona.correo),
                    trailing: const Icon(Icons.arrow_forward_ios),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PersonaFormPage(),
            ),
          );

          if (resultado == true) cargarPersonas();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  import 'package:flutter/material.dart';
import '../models/persona.dart';
import '../services/api_service.dart';

class PersonaFormPage extends StatefulWidget {
  const PersonaFormPage({super.key});

  @override
  State<PersonaFormPage> createState() => _PersonaFormPageState();
}

class _PersonaFormPageState extends State<PersonaFormPage> {
  final _formKey = GlobalKey<FormState>();
  final api = ApiService();

  final nombre = TextEditingController();
  final sexo = TextEditingController();
  final correo = TextEditingController();
  final direccion = TextEditingController();
  final telefono = TextEditingController();
  final estadoCivil = TextEditingController();

  bool guardando = false;

  Future<void> guardar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => guardando = true);

    try {
      final persona = Persona(
        nombre: nombre.text.trim(),
        sexo: sexo.text.trim(),
        correo: correo.text.trim(),
        direccion: direccion.text.trim(),
        telefono: telefono.text.trim(),
        estadoCivil: estadoCivil.text.trim(),
      );

      final resultado = await api.crearPersona(persona);

      if (!mounted) return;

      if (resultado) {
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo registrar')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      if (mounted) setState(() => guardando = false);
    }
  }

  Widget campo(String titulo, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: titulo,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Ingrese $titulo';
          }
          return null;
        },
      ),
    );
  }

  @override
  void dispose() {
    nombre.dispose();
    sexo.dispose();
    correo.dispose();
    direccion.dispose();
    telefono.dispose();
    estadoCivil.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar persona')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              campo('Nombre completo', nombre),
              campo('Sexo', sexo),
              campo('Correo electrónico', correo),
              campo('Dirección', direccion),
              campo('Teléfono', telefono),
              campo('Estado civil', estadoCivil),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: guardando ? null : guardar,
                child: Text(
                  guardando ? 'Guardando...' : 'Registrar persona',
                ),
              ),
            ],
          ),
        
        ),
        return Card(
  elevation: 3,
  margin: const EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  ),
  child: ListTile(
    leading: const CircleAvatar(
      backgroundColor: Colors.blue,
      child: Icon(
        Icons.person,
        color: Colors.white,
      ),
    ),
    title: Text(
      persona.nombre,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
    ),
    subtitle: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(persona.correo),
        Text('Teléfono: ${persona.telefono}'),
      ],
    ),
    isThreeLine: true,
  ),
);
      ),
    );
  }
}
}
