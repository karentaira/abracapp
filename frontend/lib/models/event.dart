class Event {
  final int numero;
  final String nome;
  final String musica;
  final String categoria;

  Event({
    required this.numero,
    required this.nome,
    required this.musica,
    required this.categoria,
  });

  factory Event.fromMap(Map<dynamic, dynamic> map) {
    return Event(
      numero: map['numero'],
      nome: map['nome'],
      musica: map['musica'],
      categoria: map['categoria'],
    );
  }
}
