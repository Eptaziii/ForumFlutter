import 'package:flutter/material.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/utils/secure_storage.dart';

class AddMessage extends StatefulWidget {
  final VoidCallback onAjouter;

  const AddMessage({super.key, required this.onAjouter});

  @override
  State<AddMessage> createState() => _AddMessageState();
}

class _AddMessageState extends State<AddMessage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              controller: _titreController,
              decoration: const InputDecoration(
                labelText: "Titre",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer un titre";
                }
                return null;
              },
            ),
            const Padding(padding: EdgeInsets.all(8)),
            TextFormField(
              controller: _contenuController,
              decoration: const InputDecoration(
                labelText: "Message",
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Veuillez entrer un message";
                }
                return null;
              },
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.red),
                    ),
                    child: const Text("Annuler"),
                  ),
                  const SizedBox(width: 8,),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final data = await SecureStorage().readData();
                        final id = data["id"];
                        int response = await ajouterMessage(
                          _titreController.text, 
                          _contenuController.text,
                          int.parse(id.toString()),
                        );
                        if (response == 1) {
                          Navigator.pop(context);
                          widget.onAjouter();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Message envoyé avec succès !"), backgroundColor: Colors.green,)
                          );
                        } else {
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Erreur"),
                                content: Text("Erreur lors de l'envoie du message. Veuillez réessayer plus tard !"),
                              );
                            },
                          );
                        }
                      }
                    }, 
                    child: const Text("Envoyer"),
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}