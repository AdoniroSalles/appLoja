import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loja_virtual/datas/product_data.dart';
import 'package:loja_virtual/tiles/products_tile.dart';

class CategoryScreen extends StatelessWidget {

  final DocumentSnapshot snapshot;

  /* 
    DocumentSnapshot: uma fotografia de apenas um documento
    QuerySnapshot   : fotografia de mais de um documento
  */
  CategoryScreen(
    this.snapshot
  );

  @override
  Widget build(BuildContext context) {
    //cria tabs para poder visualizar o produto em grade ou em listas 
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(snapshot.data["title"]),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              Tab( icon: Icon(Icons.grid_on),),
              Tab( icon: Icon(Icons.list),)
            ],
          ),
        ),
        body: FutureBuilder<QuerySnapshot>(
          future: Firestore.instance.collection("products").document(snapshot.documentID).collection("itens").getDocuments(),
          builder: (context, snapshot){
            if(!snapshot.hasData)
              return Center(child: CircularProgressIndicator(),);
            else
              return TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                //vai colocando mais produtos conforme for rolando a tela
                GridView.builder(
                  padding: EdgeInsets.all(4.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder : (context, index){
                    return ProductTile("grid", ProductData.fromDocument(snapshot.data.documents[index]));
                  },
                ),
                ListView.builder(
                  padding: EdgeInsets.all(4.0),
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index){
                    return ProductTile("List", ProductData.fromDocument(snapshot.data.documents[index]));
                  },
                )
              ],
            );
          } ,
        ),     
      ),
    );
  }
}