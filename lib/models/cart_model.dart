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
  ){
    if(user.isLoggedIn())
    _loadCartItems();
  }

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

  //decrementar produto
  void decProduct(CartProduct cartProduct){
    cartProduct.quantity--; 

    //atualiza no banco
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  //incrementar produto
  void incProduct(CartProduct cartProduct){
    cartProduct.quantity++;

    //atualiza no banco
    Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  //mostrar todos os produtos que já estão no carrinho quando for feito o login
  void _loadCartItems() async{
    
    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    //transformar cada documento q veio do firebase em um cartproduct e retornando a uma lista 
    products = query.documents.map(
      (doc) => CartProduct.fromDocument(doc)
    ).toList();

    notifyListeners();
  }
}