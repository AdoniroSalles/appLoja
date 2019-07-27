import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/Screens/category_screen.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  CategoryTile(
    this.snapshot
  );

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        radius: 22.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ), //icone da esquerda
      title: Text(snapshot.data["title"]),
      trailing: Icon(Icons.keyboard_arrow_right), // seta na direita
      onTap: (){
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoryScreen(snapshot),  
          )
        );
      },
    );
  }
}