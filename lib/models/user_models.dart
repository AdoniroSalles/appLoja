import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:scoped_model/scoped_model.dart';


//Um model é um objeto que vai guardar os estados de alguma coisa, nesse caso, armazena o estados do app
class UserModel extends Model{
  //usuario atual

  FirebaseAuth _auth = FirebaseAuth.instance;

  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map(); // dados mais importante do usuario(email, nome, endereço)

  bool isLoading = false;

  //para fazer o cadastro
  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}){  
    isLoading = true;
    notifyListeners();

    //criar usuario
    _auth.createUserWithEmailAndPassword(
      email: userData["email"],
      password: pass
    ).then((user) async{

      firebaseUser = user;

      //para poder salvar os dados
      await _saveUserData(userData);

      onSuccess();
      notifyListeners();

    }).catchError((e){
     
      onFail();
      isLoading = false;
      notifyListeners();

    });
  }

  //para fazer o login
  void signIn({@required String email, @required String pass, @required VoidCallback onSuccess, @required VoidCallback onFail}) async{
    isLoading = true;
    //para avisar que teve uma mudança 
    notifyListeners();

    _auth.signInWithEmailAndPassword(
      email: email,
      password: pass
    ).then(
      (user){
        firebaseUser = user;

        onSuccess();
        isLoading = false;
        notifyListeners();
      }
    ).catchError((e){ 
      onFail();
      isLoading = false;
      notifyListeners();

    });

  }

  void singOut() async{
    await _auth.signOut();

    userData = Map(); // reseta o mapa
    firebaseUser = null; //usuario igual a vazio 

    notifyListeners(); // estado do usuario modificado
  }

  //para recuperar senha
  void recoverPass(){


  }

  //para saber se esta logado
  bool isLoggedIn(){

    return firebaseUser != null; 
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async{

    //criando usuarios e salvando 
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> 
}