class User {
  // Attributs
  int id;
  String nom;
  String prenom;
  String email;
  String role;
  String dateInscription;

  // constructeur
  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    required this.dateInscription
  }); 

  //getter

  int getId(){
    return this.id;
  }

  String getNom(){
    return this.nom;
  }

  String getPrenom(){
    return this.prenom;
  }

  String getEmail(){
    return this.email;
  }

  String getRole(){
    return this.role;
  }

  void setRole(String nvRole) {
    role = nvRole;
  }

  String getDateInscription(){
    return this.dateInscription;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"], 
      nom: map["nom"], 
      prenom: map["prenom"], 
      email: map["email"], 
      role: map["roles"][0], 
      dateInscription: map["dateInscription"],
    );
  }
}
