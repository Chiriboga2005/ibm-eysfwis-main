final TextEditingController busqueda = TextEditingController();

String filtro = '';

List<Persona> filtrarPersonas(List<Persona> lista) {
  return lista.where((persona) {
    return persona.nombre.toLowerCase().contains(
      filtro.toLowerCase(),
    );
  }).toList();
}
