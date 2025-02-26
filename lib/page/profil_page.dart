import 'package:flutter/material.dart';
import 'package:forum/api/users.dart';
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

  late User _user;

  Map<String, String> allData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    _user = Provider.of<AuthProvider>(context, listen: false).user!;
    setState(() {
      allData = {
        "Nom": _user.nom,
        "Prénom": _user.prenom,
        "Email": _user.email,
        "Rôle": _user.role,
        "Date d'inscription": _user.dateInscription,
      };
    });
  }

  Column _createProfile() {
    Column profile = Column(children: [],);
    
    Row titre = Row(children: [], mainAxisAlignment: MainAxisAlignment.center,);
    Text p = const Text(
      "Profil",
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold
      ),
    );
    titre.children.add(p);
    profile.children.add(titre);

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
                        : allData.values.toList()[i] == "ROLE_USER"
                            ? Colors.green
                            : allData.values.toList()[i] == "ROLE_BANNED"
                                ? Colors.red
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
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(16)),
            SizedBox(
              height: 250,
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
                  int response = await supprimerUtilisateur(_user.getId());
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