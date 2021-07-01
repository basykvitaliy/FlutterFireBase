import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImage extends StatelessWidget {
  GetImage({Key key}) : super(key: key);

  final picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8),
      color: Colors.blue,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Photo to profil", style: TextStyle(color: Colors.white,  fontSize: 18),),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: CircleAvatar(
                    radius: 25,
                    child: IconButton(icon: Icon(Icons.camera_alt),
                    onPressed: ()async{
                      final result = await picker.getImage(source: ImageSource.camera);
                      Navigator.pop(context, File(result.path));
                    },),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: CircleAvatar(
                    radius: 25,
                    child: IconButton(icon: Icon(Icons.image),
                      onPressed: ()async{
                        final result = await picker.getImage(source: ImageSource.gallery);
                        Navigator.pop(context, File(result.path));
                      },),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
