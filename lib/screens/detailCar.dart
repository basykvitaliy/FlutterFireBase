import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/model/CarModel.dart';
import 'package:flutter_fire/model/UserModel.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DetailCar extends StatefulWidget {

  DetailCar({Key key, this.carModel}) : super(key: key);

  final CarModel carModel;

  @override
  _DetailCarState createState() => _DetailCarState();
}

class _DetailCarState extends State<DetailCar> {
  UserModel userModel;

  getUser()async{
    final user = await DatabaseRepository().getUser(widget.carModel.uid);
    if(user != null){
      setState(() {
        userModel = user;
      });
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.carModel.brand),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          
          children: [
            Container(
              width: double.infinity,
              height: 300,
              child: Image(
                fit: BoxFit.cover,
                image: NetworkImage(widget.carModel.images.first),
              ),
            ),
            SizedBox(height: 10,),
            buildListTile(widget.carModel.brand, FontAwesomeIcons.carAlt),
            buildListTile(widget.carModel.model, FontAwesomeIcons.carAlt),
            buildListTile(widget.carModel.price, FontAwesomeIcons.carAlt),
            buildListTile(widget.carModel.description, FontAwesomeIcons.carAlt),
            Divider(color: Colors.blue,),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 15,),
                Text("User", style: TextStyle(fontSize: 16, color: Colors.blue),),
                SizedBox(width: 15,),
                CircleAvatar(
                  backgroundImage: NetworkImage(userModel.image),
                ),
                SizedBox(width: 15,),
                Text(userModel.email),
              ],
            ),
            Divider(color: Colors.blue,),

          ],
        ),
      ),
    );
  }

  ListTile buildListTile(String title, IconData icon) {
    return ListTile(
            leading: Icon(icon),
            title: Text(title),
          );
  }
}
