//Classe para armazenar os dados do produtos
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData{
  String category;
  String id;
  String title;
  String description;
  double price;
  List images;
  List sizes;

  //converto os dados do documento nos dados da classe
  ProductData.fromDocument(DocumentSnapshot snapshot){
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"];
    images = snapshot.data["images"];
    sizes = snapshot.data["size"];
  }

  //resumo do produto
  Map<String, dynamic> toResumeMap(){
    return {
      "title" : title,
      "description" : description,
      "price" : price
    };
  }
}