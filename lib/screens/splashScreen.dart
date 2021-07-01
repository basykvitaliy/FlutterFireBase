import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fire/model/UserModel.dart';
import 'package:flutter_fire/screens/loginScreeen.dart';
import 'package:flutter_fire/screens/nomeScreen.dart';
import 'package:flutter_fire/screens/registerScreeen.dart';
import 'package:flutter_fire/service/AuthRepository.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  User user;
  AuthRepository authRepository = AuthRepository();

  Future<void> getUser()async{
    final userResult = await authRepository.user;
    setState(() {
      user = userResult;
    });
  }


  @override
  Widget build(BuildContext context) {
    getUser();
    return user == null
        ? LoginScreen()
        : StreamProvider<UserModel>.value(
          value: DatabaseRepository().getCurUser,
          child:HomeScreen(),
    ) ;
  }
}
