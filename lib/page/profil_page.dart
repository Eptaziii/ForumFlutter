import 'package:flutter/material.dart';
import 'package:forum/api/catgorieUsers.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/api/users.dart';
import 'package:forum/models/categorieUser.dart';
import 'package:forum/models/message.dart';
import 'package:forum/models/user.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  const Profile({super.key, required this.title});
  final String title;

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  List<Message> _messages = [];
  String _categorie = "";
  double _moyenneMessages = 0;

  late User _user;

  Map<String, String> allData = {};
  bool userLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {

    List<CategorieUser> cats = (await getAllCategories()) ?? [];

    _user = Provider.of<AuthProvider>(context, listen: false).user!;
    
    await _loadMessages();

    setState(() {
      _moyenneMessages = _user.getMoyenneMessages(_messages.length);

      int m = _user.getMoyenneMessagesInt(_messages.length);
      print(m);
      
      for (CategorieUser cat in cats) {
        if (cat.getId() == m) {
          _categorie = cat.getLibelle();
        }
      }


      allData = {
        "Nom": _user.nom,
        "Prénom": _user.prenom,
        "Email": _user.email,
        "Rôle": _user.role,
        "Date d'inscription": _user.dateInscription,
        "Catégorie": _categorie,
        "Messages/Jours": _moyenneMessages.toStringAsFixed(5)
      };
      userLoaded = true;
    });
  }

  Future<void> _loadMessages() async {
    _messages.clear();
    List<Message> mess = [];
    Map<String, dynamic> messages = await getMessages(1);
    int nbPageMax = int.parse(messages["hydra:view"]["hydra:last"].toString().substring(25));
    for (int x = 1; x <= nbPageMax; x++) {
      Map<String, dynamic> messagesPage = await getMessages(x);
      List<dynamic> messagesall = messagesPage["hydra:member"];
      for (int i = 0; i < messagesall.length; i++) {
        Message message = Message.fromMap(messagesall[i]);
        mess.add(message);
      }
      mess = mess.where((m) => m.getUser()["@id"].toString().substring(17) == _user.getId().toString()).toList();
      setState(() {
        _messages = mess;
      });
    }
  }

  Column _createProfile() {
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    Column profile = Column(children: [],);
    
    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    Row titre = Row(mainAxisAlignment: MainAxisAlignment.center,children: [],);
    Text p = const Text(
      "Profil",
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold
      ),
    );
    titre.children.add(p);
    profile.children.add(titre);

    // ignore: prefer_const_constructors, prefer_const_literals_to_create_immutables
    Column col = Column(children: []);
    for (int i = 0; i < allData.length; i++) {
      Row info = Row(
        children: [
          Text.rich(
            TextSpan(
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 19
              ),
              text: "${allData.keys.toList()[i]} : ",
              children: [
                TextSpan(
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    color: allData.values.toList()[i] == "ROLE_ADMIN" 
                        ? Colors.blue
                        : allData.values.toList()[i] == "ROLE_USER" || allData.values.toList()[i] == "Actif"
                            ? Colors.green
                            : allData.values.toList()[i] == "ROLE_BANNED"
                                ? Colors.red
                                : allData.values.toList()[i] == "En sommeil" 
                                    ? Colors.purple
                                    : allData.values.toList()[i] == "Hyper Actif"
                                        ? Colors.orange
                                        : Colors.black,
                  ),
                  text: allData.values.toList()[i] == "ROLE_ADMIN" 
                      ? "Administrateur" 
                      : allData.values.toList()[i] == "ROLE_USER"
                          ? "Utilisateur"
                          : allData.values.toList()[i] == "ROLE_BANNED"
                              ? "Bloqué"
                              : allData.values.toList()[i],
                ),
              ]
            ),
          ),
        ],
      );
      col.children.add(info);
      col.children.add(const SizedBox(height: 10));
    }
    Padding infos = Padding(padding: const EdgeInsets.only(left: 8), child: col,);
    profile.children.add(infos);

    return profile;
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 30, 34),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logoForum.png',
              width: 50,
              height: 50,
            ),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 25,
              ),
            ),
          ]
        ), 
        actions: [
          IconButton(
            onPressed: () async {
              if (authProvider.isLoggedIn) {
                authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
              }
            }, 
            icon: const Icon(Icons.logout)
          ),
        ],
      ),
      body: Center(
        child: !userLoaded
            ? const CircularProgressIndicator()
            : Column(
              children: [
                const Padding(padding: EdgeInsets.all(16)),
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Card(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      side: BorderSide(
                        color: Colors.black
                      ),
                    ),
                    child: _createProfile(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, "/messagesUser", arguments: {"messages": _messages, "id": _user.id});
                    }, 
                    child: const Text("Voir vos messages", style: TextStyle(fontSize: 30),),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () async {
                      await supprimerUtilisateur(_user.getId());
                      Provider.of<AuthProvider>(context, listen: false).logout();
                      await SecureStorage().deleteCredentials();
                      await SecureStorage().deleteToken();
                      Navigator.pop(context);
                    }, 
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red)
                    ),
                    child: const Text("Supprimer votre compte", style: TextStyle(fontSize: 26),),
                  ),
                )
              ],
            ),
      ),
    );
  }
}