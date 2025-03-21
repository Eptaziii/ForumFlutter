class CategorieUser {
  // Attributs
  int id;
  String libelle;

  // Constructeur
  CategorieUser({
    required this.id,
    required this.libelle
  });

  int getId() {
    return id;
  }

  String getLibelle() {
    return libelle;
  }

  factory CategorieUser.fromMap(Map<String, dynamic> map) {
    return CategorieUser(
      id: map["id"], 
      libelle: map["libelle"]
    );
  }
}