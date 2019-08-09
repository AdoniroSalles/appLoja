import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:loja_virtual/datas/product_data.dart';

class CartProduct {
  //class com dados do produto q são adicionados no carrinho

  String cid; 
  String category;
  String pid; // produtct id
  int quantity;
  String size; 

  ProductData productData;

  CartProduct();

  //armazena cada produto do carrinho
  CartProduct.fromDocument(DocumentSnapshot document){
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  //pega do carrinho e manda pro banco
  Map<String, dynamic> toMap(){
    return{
      "category" : category,
      "pid"      : pid,
      "quantity" : quantity,
      "size"     : size,
      // "product"  : productData.toResumeMap()
    };
  }

}