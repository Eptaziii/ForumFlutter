class Message {
  int id;
  String titre;
  String datePoste;
  String contenu;
  Map<String, dynamic> user;
  Map<String, dynamic>? parent;
  bool isModified;

  Message({
    required this.id, 
    required this.titre, 
    required this.datePoste, 
    required this.contenu, 
    required this.user,
    required this.parent,
    required this.isModified,
  });

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

  factory Message.fromMap(Map<String, dynamic> map) {
    return Message(
      id: map["id"], 
      titre: map["titre"], 
      datePoste: map["datePoste"], 
      contenu: map["contenu"], 
      user: map["user"], 
      parent: map["parent"],
      isModified: map["modified"],
    );
  }
}