import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:loja_virtual/datas/cart_product.dart';
import 'package:loja_virtual/models/user_models.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model{

  UserModel user;

  List<CartProduct> products =[];

  String cupomCode;
  int discountPercentage = 0;

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

  //seta valor de desconto
  void setCoupon(String couponCode, int discountPercentage){
    this.cupomCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  //atualiza os valores
  void updatePrice(){
    notifyListeners();
  }

  //retorna ao valor do subtotal
  double getProductsPrice(){
    double price = 0.0;
    for(CartProduct c in products){
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }

    return price;

  }

  //retorna ao valor da entrega
  double getShipPrice(){
    //foi colocado um valor fixo pois não estava funcionando corretamente o calculo de frete
    return 9.99;

  }

  //retorna ao desconto
  double getDiscount(){
    return getProductsPrice() * discountPercentage/100 ;
  } 

  //finalizar pedido
  Future<String> finishOrder() async{

    if(products.length == 0) return null;
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();

    //adicionando informação do pedido e pegando o id do pedido. 
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
      {
        "clienteId" : user.firebaseUser.uid,
        "products"  : products.map((cartProduct) =>  cartProduct.toMap()).toList(),
        "shipPrice" : shipPrice,
        "productsPrice" : productsPrice ,
        "discount"  : discount,
        "totalPrice": productsPrice - discount + shipPrice,
        "status"    : 1
      }
    );

    //salavando o id da lista de pedido ao usuario
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("orders").document(refOrder.documentID).setData(
      {
        "orderId" : refOrder.documentID
      }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents){
      doc.reference.delete();
    }

    products.clear();
    discountPercentage = 0;
    cupomCode = null;
    isLoading = false;
    
    notifyListeners();

    return refOrder.documentID;
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