import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/form/add_message.dart';
import 'package:forum/form/connexion.dart';
import 'package:forum/form/inscription.dart';
import 'package:forum/main.dart';
import 'package:forum/models/message.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:forum/utils/secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<Message> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
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
        Message message = Message(
          messagesall[i]["id"], 
          messagesall[i]["titre"], 
          messagesall[i]["datePoste"], 
          messagesall[i]["contenu"], 
          messagesall[i]["user"],
          messagesall[i]["parent"],
        );
        mess.add(message);
      }
      setState(() {
        _messages = mess;
      });
    }
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
                Navigator.pushNamed(context, "/profil", arguments: {"messages": _messages});
              } else {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: const Connexion(),
                    );
                  },
                );
              }
            }, 
            icon: Icon(authProvider.isLoggedIn ? Icons.account_circle : Icons.login)
          ),
          IconButton(
            onPressed: () async {
              if (authProvider.isLoggedIn) {
                authProvider.logout();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (Route<dynamic> route) => false,
                );
              } else {
                await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: const Inscription(),
                    );
                  },
                );
              }
            }, 
            icon: authProvider.isLoggedIn ? const Icon(Icons.logout) : const FaIcon(FontAwesomeIcons.userPen)
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            colMessages()
          ],
        ),
      ),
      floatingActionButton: authProvider.isLoggedIn 
          ? FloatingActionButton(
            onPressed: () {
              showDialog(
                context: context, 
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Votre nouveau message"),
                    content: AddMessage(onAjouter: () async {
                      print("A");
                      await _loadMessages();
                    },),
                  );
                },
              );
            },
            backgroundColor: Colors.black87,
            child: const Icon(Icons.add),
          )
          : const SizedBox.shrink(),
    );
  }

  Column colMessages() {
    Column col = Column(children: []);
    for (Message message in _messages) {
      if (message.getParent() == null) {
        Padding cardMessage = Padding(
          padding: EdgeInsets.all(8),
          child: Card(
            child: InkWell(
              onTap: () {
                
              },
              child: Column(
                children: [
                  Container(
                    height: "${message.getTitre()} - ${message.getUser()["nom"]}".length >= 40 
                        ? 70
                        : 40,
                    color: Theme.of(context).primaryColor,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width-24,
                          ),
                          child:Text(
                            "${message.getTitre()} - ${message.getUser()["nom"]}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                            ),
                            maxLines: 3,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    constraints: const BoxConstraints(
                      maxWidth: 300,
                    ),
                    child: Text(
                      message.getContenu(),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 3,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    color: const Color.fromARGB(255, 161, 161, 161),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste()))[0].toUpperCase() + DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste())).substring(1),
                          style: const TextStyle(fontSize: 14),
                          maxLines: 3,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        col.children.add(cardMessage);
      }
    }
    return col;
  }
}