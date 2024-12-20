class Message {
  int id;
  String titre;
  String datePoste;
  String contenu;
  Map<String, dynamic> user;
  Map<String, dynamic>? parent;

  Message(
    this.id, 
    this.titre, 
    this.datePoste, 
    this.contenu, 
    this.user,
    this.parent,
  );

  int getId() {
    return id;
  }

  String getTitre() {
    return titre;
  }

  String getDatePoste() {
    return datePoste;
  }

  String getContenu() {
    return contenu;
  }

  Map<String, dynamic> getUser() {
    return user;
  }

  Map<String, dynamic>? getParent() {
    return parent;
  }
}