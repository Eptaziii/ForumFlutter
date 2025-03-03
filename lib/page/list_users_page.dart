import 'package:flutter/material.dart';
import 'package:forum/api/users.dart';
import 'package:forum/models/user.dart';
import 'package:intl/intl.dart';

class ListUsersPage extends StatefulWidget {
  const ListUsersPage({super.key});

  @override
  State<ListUsersPage> createState() => _ListUsersPageState();
}

class _ListUsersPageState extends State<ListUsersPage> {

  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final users = (await getAllUsers()) ?? [];
    setState(() {
      _users = users;
    });
  }

  @override
  Widget build(BuildContext context) {
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
            const Text(
              "Liste des Utilisateurs",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ],
        ), 
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DataTable(
                    showCheckboxColumn: false,
                    columnSpacing: 5,
                    columns: const [
                      DataColumn(label: Text("Email")),
                      DataColumn(label: Text("Rôle")),
                    ], 
                    rows: _users.map((User user) {
                      return DataRow(
                        onSelectChanged: (value) {
                          Navigator.pushNamed(context, '/user', arguments: {"user":user});
                        },
                        cells: [
                          DataCell(
                            Text(
                              user.getEmail()
                            )
                          ),
                          DataCell(
                            Text(
                              user.getRole() == "ROLE_ADMIN" 
                                  ? "Administrateur" 
                                  : user.getRole() == "ROLE_BANNED" 
                                      ? "Bloqué" 
                                      : "Utilisateur",
                              style: TextStyle(
                                color: user.getRole() == "ROLE_ADMIN"
                                    ? Colors.blue
                                    : user.getRole() == "ROLE_BANNED"
                                        ? Colors.red
                                        : null,
                              ),
                            )
                          ),
                        ]
                      );
                    }).toList(),
                  )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}