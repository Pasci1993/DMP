class Redacteur {
  final int? id;
  final String nom;
  final String email;

  Redacteur({this.id, required this.nom, required this.email});

  Map<String, dynamic> toMap() => {'id': id, 'nom': nom, 'email': email};

  factory Redacteur.fromMap(Map<String, dynamic> map) =>
      Redacteur(id: map['id'], nom: map['nom'], email: map['email']);
}
