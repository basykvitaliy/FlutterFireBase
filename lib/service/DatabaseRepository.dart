import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_fire/model/CarModel.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_fire/model/UserModel.dart';

class DatabaseRepository{
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("Users");
  final CollectionReference carCollection = FirebaseFirestore.instance.collection("Cars");

  Future saveUser(UserModel userModel)async{
    try{
      await userCollection.doc(userModel.id).set(userModel.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future getUser(String id)async{
    try{
      final data = await userCollection.doc(id).get();
      final user = UserModel.fromMap(data.data());
      return user;
    }catch(e){
      return false;
    }
  }

  Future updateUser(UserModel userModel)async{
    try{
      await userCollection.doc(userModel.id).update(userModel.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Future<String> uploadImage(File file, {String path})async{
    var time = DateTime.now().toString();
    var ext= Path.basename(file.path).split(".")[1].toString();
    String image = path + "_" + time + "." + ext;
    try{
      StorageReference reference = FirebaseStorage.instance.ref().child(path + "/" + image);
      StorageUploadTask uploadTask = reference.putFile(file);
      await uploadTask.onComplete;
      return await reference.getDownloadURL();
    }catch(e){
      return null;
    }
  }
  Stream<UserModel> get getCurUser{
  final user = FirebaseAuth.instance.currentUser;
    return user != null ? userCollection.doc(user.uid).snapshots().map((user) => UserModel.fromMap(user.data())) : null;
}
  Future saveCar(CarModel carModel)async{
    try{
      await carCollection.doc().set(carModel.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

  Stream<List<CarModel>> get getCar{
    return carCollection.snapshots().map((car) {
      return car.docs.map((e) => CarModel.fromMap(e.data(), id: e.id)).toList();
    });
  }

  Future carList()async{
    List<CarModel> items = [];
    await carCollection.get().then((value){
      value.docs.forEach((element) {
        items.add(CarModel.fromMap(element.data(), id: element.id));
      });
    });
    return items;
  }
  Future deleteCar(String id)async{
    try{
      await carCollection.doc(id).delete();
      return true;
    }catch(e){
      return false;
    }
  }

  Future updateCar(CarModel carModel)async{
    try{
      await carCollection.doc(carModel.id).update(carModel.toMap());
      return true;
    }catch(e){
      return false;
    }
  }

}