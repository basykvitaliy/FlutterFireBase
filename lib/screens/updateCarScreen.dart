
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/model/CarModel.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';
import 'package:flutter_fire/utils/getImage.dart';
import 'package:flutter_fire/utils/loading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UpdateCarScreen extends StatefulWidget {
  const UpdateCarScreen({Key key, this.updateCarList, this.car}) : super(key: key);

  final Function updateCarList;
  final CarModel car;
  @override
  _UpdateCarScreenState createState() => _UpdateCarScreenState();
}

class _UpdateCarScreenState extends State<UpdateCarScreen> {

  final _keys = GlobalKey<FormState>();
  String brand;
  String marka;
  String description;
  String price;
  List<dynamic> images = [];
  CarModel carModel = CarModel();

  @override
  void initState() {
    super.initState();
    brand = widget.car.brand;
    marka = widget.car.model;
    description = widget.car.description;
    price = widget.car.price;
    images = widget.car.images;
    carModel = widget.car;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Car" + widget.car.brand),
        actions: [Icon(FontAwesomeIcons.car), SizedBox(width: 10,)],
      ),
      body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Form(
              key: _keys,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Enter information for your car",
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (e) => e.trim().isEmpty ? "Enter brand" : null,
                    onChanged: (e) => brand = e,
                    decoration: InputDecoration(
                        labelText: "Brand"
                    ),
                    initialValue: brand,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (e) => e.trim().isEmpty ? "Enter brand" : null,
                    onChanged: (e) => marka = e,
                    decoration: InputDecoration(
                        labelText: "Model"
                    ),
                    initialValue: marka,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (e) => e.trim().isEmpty ? "Enter brand" : null,
                    onChanged: (e) => price = e,
                    decoration: InputDecoration(
                        labelText: "Price"
                    ),
                    initialValue: price,
                  ),
                  SizedBox(height: 10,),
                  TextFormField(
                    validator: (e) => e.trim().isEmpty ? "Enter brand" : null,
                    onChanged: (e) => description = e,
                    maxLines: 5,
                    decoration: InputDecoration(
                        labelText: "Description"
                    ),
                    initialValue: description,
                  ),
                  SizedBox(height: 10,),
                  Wrap(
                      children:[
                        for(int i = 0; i < images.length; i++)
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            margin: EdgeInsets.only(left: 5),
                            width: 70,
                            height: 70,
                            child: Stack(
                              children:[
                                if(images[i] is File)
                                  Image.file(images[i], fit: BoxFit.cover,)
                                else
                                  Image.network(images[i], fit: BoxFit.cover,),

                                Align(
                                  alignment: Alignment.center,
                                  child: IconButton(
                                    icon: Icon(FontAwesomeIcons.minusCircle),
                                    onPressed: (){
                                      setState(() {
                                        images.removeAt(i);
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          ),
                        InkWell(
                          onTap: ()async{
                            final data = await showModalBottomSheet(
                                context: context,
                                builder: (_){
                                  return GetImage();
                                });
                            setState(() {
                              images.add(data);
                            });
                          },
                          child: Container(
                            width: 70,
                            height: 70,
                            child: Icon(FontAwesomeIcons.plusCircle),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey[200],
                            ),
                          ),
                        ),
                      ]
                  ),
                  SizedBox(height: 10,),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.green,
                    ),
                    child: FlatButton(

                      onPressed: ()async{
                        if(_keys.currentState.validate() && images.length > 0){
                          _keys.currentState.save();
                          loading(context);

                          carModel.brand = brand;
                          carModel.model = marka;
                          carModel.description = description;
                          carModel.price = price;
                          carModel.uid = FirebaseAuth.instance.currentUser.uid;
                          carModel.images = [];
                          for(int i = 0; i < images.length; i++){
                            if(images[i] is File){
                                String urlImage = await DatabaseRepository().uploadImage(images[i], path: "cars");
                                if(urlImage != null) carModel.images.add(urlImage);
                              }else{
                                carModel.images.add(images[i]);
                              }
                            }
                            if(images.length == carModel.images.length){
                              bool update = await DatabaseRepository().updateCar(carModel);
                              if(update){
                                widget.updateCarList();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              }
                            }
                          }
                        },

                      child: Text("Update", style: TextStyle(fontSize: 18, color: Colors.white),),),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
