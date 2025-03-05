import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/form/add_message.dart';
import 'package:forum/form/connexion.dart';
import 'package:forum/form/edit_message.dart';
import 'package:forum/form/inscription.dart';
import 'package:forum/models/message.dart';
import 'package:forum/models/user.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  Message? _message;

  List<Message> _messages = [];

  User? user;
  bool messagesLoaded = false;

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
    for (int i = 1; i <= nbPageMax; i++) {
      Map<String, dynamic> messagesPage = await getMessages(i);
      List<dynamic> messagesAll = messagesPage["hydra:member"];
      for (int x = 0; x < messagesAll.length; x++) {
        Message message = Message.fromMap(messagesAll[x]);
        mess.add(message);
      }
    }
    setState(() {
      _messages = mess;
      messagesLoaded = true;
    });
  }

  void _loadMessagesEnfants(Message messageParent) async {
    List<Message> messagesEnfants = [];
    if (messageParent.getParent() != null) {
      for (Message message in _messages) {
        if (message.getId() == messageParent.getParent()!["id"]) {
          messagesEnfants.add(message);
        }
      }
    }
    for (Message message in _messages) {
      if (message.getParent() != null) {
        if (messageParent.getParent() == null) {  
          if (message.getParent()!["id"] == messageParent.getId()) {
            messagesEnfants.add(message);
          }
        } else {
          if (message.getParent()!["id"] == messagesEnfants[0].getId()) {
            messagesEnfants.add(message);
          }
        }
      }
    }
    print(messagesEnfants);
    setState(() {
      _messages.clear();
      if (messageParent.getParent() == null) {
        _messages.add(messageParent);
      }
      for (Message mess in messagesEnfants) {
        _messages.add(mess);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _message = arguments["message"];
    if (authProvider.isLoggedIn) {
      user = authProvider.user;
    }
    _loadMessagesEnfants(_message!);
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
          ]
        ), 
        actions: [
          IconButton(
            onPressed: () async {
              if (authProvider.isLoggedIn) {
                Navigator.pushNamed(context, "/profil");
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
      body: !messagesLoaded
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                      await _loadMessages();
                    },
                    type: "Réponse",
                    idParent: _message!.getId(),
                    ),
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
    int nbMessage = 0;
    for (Message message in _messages) {
      nbMessage++;
      Padding cardMessage = Padding(
        padding: EdgeInsets.all(8),
        child: Card(
          margin: nbMessage != 1 ? EdgeInsets.symmetric(horizontal: 16) : null,
          child: Column(
            children: [
              Container(
                height: "${message.getTitre()} - ${message.getUser()["nom"]}".length >= 41 
                    ? 70
                    : 40,
                color: nbMessage != 1 ? const Color.fromARGB(255, 161, 161, 161) : Theme.of(context).primaryColor,
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
                          color: nbMessage != 1 ? Colors.black : Colors.white,
                          fontSize: nbMessage != 1 ? 13 : 15,
                          fontWeight: nbMessage != 1 ? FontWeight.bold : null,
                        ),
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
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8.0),
                color: const Color.fromARGB(255, 161, 161, 161),
                child: Row(
                  mainAxisAlignment: user != null ? user!.getId().toString() == message.getUser()["@id"].toString().substring(17) || user!.role == "ROLE_ADMIN" ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end : MainAxisAlignment.end,
                  children: [
                    if (user != null)
                      if (message.getUser()["@id"].toString().substring(17) == user!.id.toString() || user!.role == "ROLE_ADMIN")
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
                                      if (nbMessage == 1) {
                                        Navigator.pop(context);
                                        Navigator.pushReplacementNamed(context, '/home');
                                      } else {
                                        setState(() {
                                          _loadMessages();
                                        });
                                      }
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
                              style: const TextStyle(fontSize: 12),
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
      );
      col.children.add(cardMessage);
      if (nbMessage == 1) {
        col.children.add(const Padding(padding: EdgeInsets.all(8), child: Divider(),));
      }
    }
    return col;
  }
}