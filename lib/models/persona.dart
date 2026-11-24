class Persona {
  final int? id;
  final String nombre;
  final String sexo;
  final String correo;
  final String direccion;
  final String telefono;
  final String estadoCivil;

  Persona({
    this.id,
    required this.nombre,
    required this.sexo,
    required this.correo,
    required this.direccion,
    required this.telefono,
    required this.estadoCivil,
  });

  factory Persona.fromJson(Map<String, dynamic> json) {
    return Persona(
      id: int.tryParse(json['id']?.toString() ?? ''),
      nombre: json['nombre']?.toString() ?? '',
      sexo: json['sexo']?.toString() ?? '',
      correo: json['correo']?.toString() ?? '',
      direccion: json['direccion']?.toString() ?? '',
      telefono: json['telefono']?.toString() ?? '',
      estadoCivil: json['estadocivil']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'sexo': sexo,
      'correo': correo,
      'direccion': direccion,
      'telefono': telefono,
      'estadocivil': estadoCivil,
    };
  }
}
