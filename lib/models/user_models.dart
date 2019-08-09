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

  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);

  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);

    _loadCurrentUser();
  }
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
      (user) async{
        firebaseUser = user; 

        await _loadCurrentUser();

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
  void recoverPass({ @required String email, @required VoidCallback onSuccess, @required VoidCallback onFail}){
  
    _auth.sendPasswordResetEmail(
      email: email
    ).then(
      (user){
        onSuccess();
      }
    ).catchError((e){
      onFail();
    });

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

  Future<Null> _loadCurrentUser() async{

    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"] == null){
        DocumentSnapshot docUser = await Firestore.instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }

    notifyListeners();
  } 
}