class Redacteur {
  int? id; // Nullable car généré automatiquement par SQLite lors de l'insertion
  String nom;
  String prenom;
  String email;

  // Constructeur principal (avec tous les attributs, y compris l'id)
  Redacteur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur nommé 'sansId' demandé explicitement dans l'énoncé
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Convertit un objet Redacteur en Map (indispensable pour insérer dans SQLite)
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  // Recrée un objet Redacteur à partir d'un Map (récupéré depuis la base de données)
  factory Redacteur.fromMap(Map<String, dynamic> map) {
    return Redacteur(
      id: map['id'] as int?,
      nom: map['nom'] as String,
      prenom: map['prenom'] as String,
      email: map['email'] as String,
    );
  }
}