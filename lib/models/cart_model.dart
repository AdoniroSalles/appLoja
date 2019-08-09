import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_models.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;

  List<CartProduct> products =[];

  bool isLoading = false;

  CartModel(
    this.user
  );

  static CartModel of(BuildContext context) => ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct){
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").add(cartProduct.toMap()).then(
      (doc){
        cartProduct.cid = doc.documentID; // pega o id do firbase e salva do cartProduct
      }
    );

    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct){

    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).delete();

    products.remove(cartProduct);
    
    notifyListeners();
  }
}