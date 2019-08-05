import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:loja_virtual/Screens/home_screen.dart';
import 'package:loja_virtual/Screens/login_screen.dart';
import 'package:loja_virtual/models/user_models.dart';
import 'package:scoped_model/scoped_model.dart';

// void main() async{
//   QuerySnapshot snapshot = await Firestore.instance.collection("homePage").getDocuments();

//   print(snapshot.documents);

// }

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
      model: UserModel(), //tudo q estiver acesso ao usermodel, pode ser modificado dependendo do usermodel
      child: MaterialApp(
        title: "Flutter's Clothing",
        theme: ThemeData(
          primarySwatch: Colors.blue, // cor do tema
          primaryColor: Color.fromARGB(255, 4, 125, 141), // cor da barra, botão
        ),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
