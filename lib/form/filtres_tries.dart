import 'package:flutter/material.dart';
import 'package:forum/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class FiltresTries extends StatefulWidget {
  final String trie;
  final bool filterMessage;
  final bool filterUser;
  final Function onChanged;

  const FiltresTries({super.key, required this.trie, required this.filterMessage, required this.filterUser, required this.onChanged});

  @override
  State<FiltresTries> createState() => _FiltresTriesState();
}

class _FiltresTriesState extends State<FiltresTries> {
  String _trie = "";
  bool _filterMessage = false;
  bool _filterUser = false;
  bool dataLoaded = false;

  @override
  Widget build(BuildContext context) {
    if(!dataLoaded) {
      _trie = widget.trie;
      _filterMessage = widget.filterMessage;
      _filterUser = widget.filterUser;
      dataLoaded = true;
    }
    final authProvider = Provider.of<AuthProvider>(context);
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          const Text("Filtrer par : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 8),
          Column(
            children: [
              CheckboxListTile(
                title: const Text("Messages"),
                value: _filterMessage, 
                onChanged: (value) {
                  setState(() {
                    _filterMessage = value!;
                    widget.onChanged(_trie, _filterMessage, _filterUser);
                  });
                },
              ),
              CheckboxListTile(
                title: const Text("Utilisateurs"),
                value: _filterUser, 
                onChanged: (value) {
                  setState(() {
                    _filterUser = value!;
                    widget.onChanged(_trie, _filterMessage, _filterUser);
                  });
                },
                enabled: authProvider.isLoggedIn,
              ),
            ],
          ),
          const Divider(),
          const Text("Trier par : ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
          const SizedBox(height: 8),
          Column(
            children: [
              RadioListTile(
                title: const Text("Les plus récents"),
                value: "Plus récents", 
                groupValue: _trie, 
                onChanged: (value) {
                  setState(() {
                    _trie = value!;
                    widget.onChanged(_trie, _filterMessage, _filterUser);
                  });
                },
              ),
              RadioListTile(
                title: const Text("Les plus anciens"),
                value: "Plus anciens", 
                groupValue: _trie, 
                onChanged: (value) {
                  setState(() {
                    _trie = value!;
                    widget.onChanged(_trie, _filterMessage, _filterUser);
                  });
                },
              ),
            ],
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
                  child: const Text("Fermer"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}