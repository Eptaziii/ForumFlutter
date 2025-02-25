import 'package:flutter/material.dart';
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
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    _messages = arguments["messages"];
    _id = arguments["id"];
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
                                          content: EditMessage(message: message),
                                        );
                                      },
                                    );
                                  },
                                  child: const Icon(Icons.edit, color: Colors.blue,),
                                ),
                                const SizedBox(width: 5,),
                                InkWell(
                                  onTap: () {
                                    
                                  },
                                  child: const Icon(Icons.delete, color: Colors.red,),
                                ),
                              ],
                            )
                          ],
                        ),
                        Column(
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