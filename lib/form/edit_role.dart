import 'package:flutter/material.dart';
import 'package:forum/api/users.dart';
import 'package:forum/models/user.dart';

class EditRole extends StatefulWidget {
  final Function onModifier;
  final User user;

  const EditRole({super.key, required this.onModifier, required this.user});

  @override
  State<EditRole> createState() => _EditRoleState();
}

class _EditRoleState extends State<EditRole> {
  final _formKey = GlobalKey<FormState>();
  final _roleController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _roleController.text = widget.user.getRole();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            DropdownButtonFormField(
              decoration: const InputDecoration(
                labelText: "Rôle",
                labelStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
              value: _roleController.text,
              items: const [
                DropdownMenuItem(
                  value: 'ROLE_USER',
                  child: Text("Utilisateur"),
                ),
                DropdownMenuItem(
                  value: 'ROLE_ADMIN',
                  child: Text("Administrateur"),
                ),
              ], 
              validator: (value) {
                if (value == null) {
                  return "Veuillez choisir un rôle";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _roleController.text = value.toString();
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8),
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
                    child: const Text('Annuler'),
                  ),
                  const Padding(padding: EdgeInsets.only(right: 8.0)),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await modifierUtilisateur(widget.user.getId(), _roleController.text);
                        widget.onModifier(_roleController.text);
                        Navigator.pop(context);
                      }
                    },
                    style: const ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue),
                    ),
                    child: const Text('Modifier'),
                  ),
                ],
              ),
            ),
          ],
        )
      ),
    );
  }
}