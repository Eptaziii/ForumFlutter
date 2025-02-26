// import 'package:flutter/material.dart';
// import 'package:forum/form/edit_message.dart';
// import 'package:forum/models/message.dart';
// import 'package:intl/intl.dart';

// class AfficherMessages extends StatefulWidget {
//   final List<Message> messages;
//   final String type;
//   final int? idUser;

//   const AfficherMessages({super.key, required this.messages, required this.type, this.idUser});

//   @override
//   State<AfficherMessages> createState() => _AfficherMessagesState();
// }

// class _AfficherMessagesState extends State<AfficherMessages> {
//   @override
//   Widget build(BuildContext context) {
//     return colMessages();
//   }

//   Column colMessages() {
//     Column col = Column(children: []);
//     for (Message message in widget.type == "Profil" ? widget.messages.where((m) => m.getUser()["@id"].toString().substring(17) == widget.idUser.toString()) : widget.messages) {
//       if (message.getParent() == null) {
//         Padding cardMessage = Padding(
//           padding: EdgeInsets.all(8),
//           child: Card(
//             child: InkWell(
//               onTap: () {
                
//               },
//               child: Column(
//                 children: [
//                   Container(
//                     height: "${message.getTitre()} - ${message.getUser()["nom"]}".length >= 40 
//                         ? 70
//                         : 40,
//                     color: Theme.of(context).primaryColor,
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           constraints: BoxConstraints(
//                             maxWidth: MediaQuery.of(context).size.width-24,
//                           ),
//                           child:Text(
//                             "${message.getTitre()} - ${message.getUser()["nom"]}",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 15
//                             ),
//                             maxLines: 3,
//                             softWrap: true,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8.0),
//                     constraints: const BoxConstraints(
//                       maxWidth: 300,
//                     ),
//                     child: Text(
//                       message.getContenu(),
//                       style: const TextStyle(fontSize: 14),
//                       maxLines: 3,
//                       softWrap: true,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ),
//                   Container(
//                     padding: const EdgeInsets.all(8.0),
//                     color: const Color.fromARGB(255, 161, 161, 161),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         if (message.getUser()["@id"].toString().substring(17) == widget.idUser.toString())
//                           Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   InkWell(
//                                     onTap: () async {
//                                       await showDialog(
//                                         context: context, 
//                                         builder: (context) {
//                                           return AlertDialog(
//                                             title: const Text("Modifier votre message"),
//                                             content: EditMessage(onModifier: () {
//                                               setState(() {
//                                                 _loadMessages();
//                                               });
//                                             },
//                                             message: message
//                                             ),
//                                           );
//                                         },
//                                       );
//                                     },
//                                     child: const Icon(Icons.edit, color: Colors.blue,),
//                                   ),
//                                   const SizedBox(width: 5,),
//                                   InkWell(
//                                     onTap: () {
                                      
//                                     },
//                                     child: const Icon(Icons.delete, color: Colors.red,),
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         Column(
//                           children: [
//                             Text(
//                               DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste()))[0].toUpperCase() + DateFormat("EEEE d MMMM yyyy", "fr_FR").format(DateTime.parse(message.getDatePoste())).substring(1),
//                               style: const TextStyle(fontSize: 14),
//                               maxLines: 3,
//                               softWrap: true,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//         col.children.add(cardMessage);
//       }
//     }
//     return col;
//   }
// }