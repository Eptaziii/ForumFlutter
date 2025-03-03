import 'package:flutter/material.dart';
import 'package:forum/api/messages.dart';
import 'package:forum/models/message.dart';

class EditMessage extends StatefulWidget {
  final VoidCallback onModifier;
  final Message message;

  const EditMessage({super.key, required this.onModifier, required this.message});

  @override
  State<EditMessage> createState() => _EditMessageState();
}

class _EditMessageState extends State<EditMessage> {
  final _formKey = GlobalKey<FormState>();
  final _titreController = TextEditingController();
  final _contenuController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _titreController.text = widget.message.getTitre();
    _contenuController.text = widget.message.getContenu();
  }

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
                        int response = await modifierMessage(
                          _titreController.text, 
                          _contenuController.text,
                          widget.message.getId()
                        );
                        if (response == 1) {
                          Navigator.pop(context);
                          widget.onModifier();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Message modifié avec succès !"), backgroundColor: Colors.blue,)
                          );
                        } else {
                          showDialog(
                            context: context, 
                            builder: (context) {
                              return const AlertDialog(
                                title: Text("Erreur"),
                                content: Text("Erreur lors de la modification du message. Veuillez réessayer plus tard !"),
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