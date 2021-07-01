import 'package:flutter/material.dart';

myShowDialog(BuildContext context, {String title, String content, VoidCallback ok}) async {
  showDialog(
      context: context,
      builder: (_){
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
                onPressed: ()async{
                  Navigator.pop(context);
                },
                child: Text("No")
            ),
            FlatButton(
                onPressed: ok,
                child: Text("Yes")
            ),
          ],
        );
      }
  );
}