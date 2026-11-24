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
}
