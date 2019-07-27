import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {

  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(
    this.icon,
    this.text,
    this.controller,
    this.page
  );

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 60.0,
          child: Row(
            children: <Widget>[
              Icon(
                icon,  //icon passado no custom_drawer.dart
                size: 32.2,
                color: controller.page.round() == page ? Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32.0,),
              Text(
                text, //text passado no custom_drawer.dart
                style: TextStyle(fontSize: 16.0, color: Colors.black),
              )
            ],
          ),
        ),
      ),
    );
  }
}