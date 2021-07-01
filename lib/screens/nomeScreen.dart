import 'dart:ffi';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/model/CarModel.dart';
import 'package:flutter_fire/model/UserModel.dart';
import 'package:flutter_fire/screens/addCarScreen.dart';
import 'package:flutter_fire/screens/detailCar.dart';
import 'package:flutter_fire/screens/loginScreeen.dart';
import 'package:flutter_fire/screens/menuScreen.dart';
import 'package:flutter_fire/screens/updateCarScreen.dart';
import 'package:flutter_fire/service/AuthRepository.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';
import 'package:flutter_fire/utils/loading.dart';
import 'package:flutter_fire/utils/myDialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  AuthRepository authRepository = AuthRepository();
  DatabaseRepository databaseRepository = DatabaseRepository();
  final _keys = GlobalKey<ScaffoldState>();

  List<CarModel> carList = [];

  @override
  void initState() {
    super.initState();
    _updateCarList();
  }

  void _updateCarList()async{
      List<CarModel> result = await databaseRepository.carList();
      if(result != null){
        carList = result;
      }
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      key: _keys,
      drawer: MenuScreen(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Nome"),
        actions: [
          InkWell(
            onTap: (){
              _keys.currentState.openDrawer();
            },
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(right: 8),
                  // child: CircleAvatar(
                  //   radius: 18,
                  //   backgroundImage: userModel.image != null ? NetworkImage(userModel.image) : NetworkImage(""),
                  //   child:userModel.image != null ? Container() : Icon(Icons.person),
                  // ),
                ),
                //Text(userModel.name),
                IconButton(icon: Icon(FontAwesomeIcons.powerOff),
                    onPressed: ()async{
                  await myShowDialog(context, ok: ()async{
                      await authRepository.signOut();
                      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
                      setState(() {});
                  }, title: "Exit", content: "Do you want exit?");
                }),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: carList.length,
            itemBuilder: (context, index){
          return Card(
            child: ListTile(
              leading: Container(
                child: Image(
                  image: NetworkImage(carList[index].images.first),
                ),
              ),
              title: Row(
                children: [
                  Text(carList[index].brand),
                  SizedBox(width: 10,),
                  Text("${carList[index].model}"),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("price: ${carList[index].price}"),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(FontAwesomeIcons.solidThumbsUp, color: Colors.grey,),
                        iconSize: 20,
                        onPressed: ()async{
                          if(carList[index].like.contains(user.uid)){
                            carList[index].like.remove(user.uid);
                          }else if(carList[index].disLike.contains(user.uid)){
                            carList[index].disLike.remove(user.uid);
                            carList[index].like.add(user.uid);
                          }else{
                            carList[index].like.add(user.uid);
                          }
                          await DatabaseRepository().updateCar(carList[index]);
                        },
                      ),
                      Text(carList[index].like.length.toString()),
                      IconButton(
                        icon: Icon(FontAwesomeIcons.solidThumbsDown, color: Colors.grey,),
                        iconSize: 20,
                        onPressed: ()async{
                          if(carList[index].disLike.contains(user.uid)){
                            carList[index].disLike.remove(user.uid);
                          }else if(carList[index].like.contains(user.uid)){
                            carList[index].like.remove(user.uid);
                            carList[index].disLike.add(user.uid);
                          }else{
                            carList[index].disLike.add(user.uid);
                          }
                          await DatabaseRepository().updateCar(carList[index]);
                        },
                      ),
                      Text(carList[index].disLike.length.toString()),
                    ],
                  )
                ],
              ),
              trailing: carList[index].uid == FirebaseAuth.instance.currentUser.uid ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.delete),
                    iconSize: 20,
                    onPressed: ()async{
                      myShowDialog(
                          context,
                          title: "Delete?",
                          content: "Do you want delte&" + carList[index].brand,
                          ok: ()async{
                            loading(context);
                            bool delete = await DatabaseRepository().deleteCar(carList[index].id);
                            if(delete != null){
                              setState(() {
                                _updateCarList();
                              });

                              Navigator.pop(context);
                              Navigator.pop(context);
                            }
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.edit),
                    iconSize: 20,
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateCarScreen(updateCarList: _updateCarList, car: carList[index],)));
                    },
                  ),
                ],
              ): null,
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => DetailCar(carModel: carList[index],)));
              },
            ),
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddCarScreen(updateCarList: _updateCarList,)));
        },
      ),
    );
  }




}
