import 'package:flutter/material.dart';
import 'package:forum/api/users.dart';
import 'package:forum/form/edit_role.dart';
import 'package:forum/models/user.dart';
import 'package:intl/intl.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    Map arguments = ModalRoute.of(context)!.settings.arguments as Map;
    User user = arguments["user"];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 32, 30, 34),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pushReplacementNamed(context, '/liste_users');
          }, 
          icon: const Icon(Icons.arrow_back)
        ),
        title: Row(
          children: [
            Image.asset(
              'assets/images/logoForum.png',
              width: 50,
              height: 50,
            ),
            Text(
              user.getEmail(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ],
        ), 
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Informations personnelles",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 28
                  ),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Nom : ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                    children: [
                      TextSpan(text: user.getNom(), style: const TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  )
                ),
                RichText(
                  text: TextSpan(
                    text: "Prénom : ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                    children: [
                      TextSpan(text: user.getPrenom(), style: const TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  )
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Email : ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                    children: [
                      TextSpan(text: user.getEmail(), style: const TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  )
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Inscrit depuis le ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                    children: [
                      TextSpan(text: DateFormat("dd/MM/yyyy").format(DateTime.parse(user.getDateInscription())), style: const TextStyle(fontWeight: FontWeight.normal)),
                    ],
                  )
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                  text: TextSpan(
                    text: "Rôle : ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20
                    ),
                    children: [
                      TextSpan(
                        text: user.getRole() == "ROLE_ADMIN" 
                            ? "Administrateur"
                            : user.getRole() == "ROLE_BANNED"
                                ? "Bloqué"
                                : "Utilisateur", 
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: user.getRole() == "ROLE_ADMIN" 
                            ? Colors.blue
                            : user.getRole() == "ROLE_BANNED"
                                ? Colors.red
                                : null,
                        )
                      ),
                    ],
                  ),
                ),
                if (user.getRole() != "ROLE_BANNED")
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Modifier le rôle"),
                            content: EditRole(
                              onModifier: (String role) {
                                setState(() {
                                  user.setRole(role);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("${user.getNom()} ${user.getPrenom()} a maintenant un compte ${user.getRole() == "ROLE_ADMIN" ? "Administrateur" : "Utilisateur"} !"), backgroundColor: Colors.blue,)
                                );
                              }, 
                              user: user
                            ),
                          );
                        },
                      );
                    }, 
                    icon: const Icon(Icons.edit, color: Colors.blue),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            const SizedBox(width: 150, child: Divider(),),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Bloquage"),
                          content: Text("Voulez vous vraiment ${user.getRole() == "ROLE_BANNED" ? "débloquer" : "bloquer"} cet utilisateur ? "),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Non"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (user.getRole() == "ROLE_BANNED") {
                                  await modifierUtilisateur(user.getId(), "ROLE_USER");
                                  setState(() {
                                    user.setRole("ROLE_USER");
                                  });
                                } else {
                                  await modifierUtilisateur(user.getId(), "ROLE_BANNED");
                                  setState(() {
                                    user.setRole("ROLE_BANNED");
                                  });
                                }
                                Navigator.of(context).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("L'utilisateur a été ${user.getRole() == "ROLE_BANNED" ? "bloqué" : "débloqué"} avec succès !")),
                                );
                              }, 
                              child: const Text("Oui"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Icon(
                        user.getRole() != "ROLE_BANNED"
                            ? Icons.lock_outline
                            : Icons.lock_open_outlined,
                        size: 15,
                      ),
                      Text(
                        user.getRole() != "ROLE_BANNED"
                            ? "Bloquer"
                            : "Débloquer",
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context, 
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Supression"),
                          content: const Text("Voulez vous vraiment supprimer le compte de cet utilisateur ? "),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              }, 
                              child: const Text("Non"),
                            ),
                            TextButton(
                              onPressed: () async {
                                await supprimerUtilisateur(user.getId());
                                Navigator.of(context).pop();
                                Navigator.popAndPushNamed(context, '/liste_users');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("L'utilisateur a été supprimé avec succès !"), backgroundColor: Colors.red,)
                                );
                              }, 
                              child: const Text("Oui"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  style: const ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.red)
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.delete,
                        size: 15,
                      ),
                      Text(
                        "Supprimer le compte"
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/messagesUser", arguments: {"id": user.getId()});
                  }, 
                  child: const Text("Voir les messages", style: TextStyle(fontSize: 33.7),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}