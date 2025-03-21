class User {
  // Attributs
  int id;
  String nom;
  String prenom;
  String email;
  String role;
  String dateInscription;
  int categorie;

  // constructeur
  User({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    required this.dateInscription,
    required this.categorie
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

  int getCategorie() {
    return categorie;
  }

  void setCategorie(int cat) {
    categorie = cat;
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map["id"], 
      nom: map["nom"], 
      prenom: map["prenom"], 
      email: map["email"], 
      role: map["roles"][0], 
      dateInscription: map["dateInscription"],
      categorie: map["categorie"]
    );
  }

  double getMoyenneMessages(int nbMessages) {
    List<String> dateInsc = dateInscription.split('/');
    double moyenne = 0;
    if ((DateTime.now().difference(DateTime(int.parse(dateInsc[2]), int.parse(dateInsc[1]), int.parse(dateInsc[0]))).inDays) != 0) {
      moyenne = nbMessages / (DateTime.now().difference(DateTime(int.parse(dateInsc[2]), int.parse(dateInsc[1]), int.parse(dateInsc[0]))).inDays);
    } else {
      moyenne = nbMessages / 1;
    }

    return moyenne;
  }

  int getMoyenneMessagesInt(int nbMessages) {
    if (getMoyenneMessages(nbMessages) < 0.7) {
      return 1;
    } else if (getMoyenneMessages(nbMessages) >= 0.7 && getMoyenneMessages(nbMessages) <= 2) {
      return 2;
    } else if (getMoyenneMessages(nbMessages) > 2) {
      return 3;
    } else {
      return 1;
    }
  }
}
