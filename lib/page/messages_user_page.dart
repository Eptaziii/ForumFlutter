import 'package:flutter/material.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/form/edit_message.dart';
import 'package:forum/models/message.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagesUser extends StatefulWidget {
  final String title;

  const MessagesUser({super.key, required this.title});

  @override
  State<MessagesUser> createState() => _MessagesUserState();
}

class _MessagesUserState extends State<MessagesUser> {
  List<Message> _messages = [];
  String _id = "";

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
        Message message = Message.fromMap(messagesall[i]);
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
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _id = arguments["id"].toString();
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
          ],
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
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            colMessages(),
          ],
        ),
      ),
    );
  }

  Column colMessages() {
    Column col = Column(children: []);
    for (Message message in _messages.where((m) => m.getUser()["@id"].toString().substring(17) == _id)) {
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await showDialog(
                                      context: context, 
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text("Modifier votre message"),
                                          content: EditMessage(onModifier: () {
                                            setState(() {
                                              _loadMessages();
                                            });
                                          },
                                          message: message
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.blue,),
                                ),
                                const SizedBox(width: 5,),
                                InkWell(
                                  onTap: () async {
                                    int response = await supprimerMessage(message.getId());
                                    if (response == 1) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Votre message a été supprimé avec succès !"), backgroundColor: Colors.red,)
                                      );
                                      setState(() {
                                        _loadMessages();
                                      });
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Une erreur est survenue"), backgroundColor: Colors.red,)
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.delete, color: Colors.red,),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                if(message.isModified)
                                  ...[
                                    Text(
                                      "Modifié",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                    const SizedBox(width: 8)
                                  ],
                                Text(
                                  DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste()))[0].toUpperCase() + DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste())).substring(1),
                                  style: const TextStyle(fontSize: 14),
                                  maxLines: 3,
                                  softWrap: true,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            )
                          ],
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