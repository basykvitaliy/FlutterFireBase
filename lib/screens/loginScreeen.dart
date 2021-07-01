import 'package:flutter/material.dart';
import 'package:flutter_fire/screens/registerScreeen.dart';
import 'package:flutter_fire/service/AuthRepository.dart';
import 'package:flutter_fire/utils/loading.dart';

import 'nomeScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  AuthRepository _authRepository = AuthRepository();
  final _keys = GlobalKey<FormState>();
  String _email = "";
  String _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _keys,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: "Email"
                    ),
                    onChanged: (e) => _email = e,
                    validator: (e) => e.trim().isEmpty == null ? "Enter email" : null,
                  ),
                ),
                SizedBox(height: 16,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                  child: TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password"
                    ),
                    onChanged: (e) => _password = e,
                    validator: (e) => e.isEmpty == null ? "Enter password" : e.length < 6 ? "пароль должен быть не менее 6 символов" : null,
                  ),
                ),
                SizedBox(height: 16,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Do you want to register?"),
                    FlatButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen())),
                      child:Text("Register", style: TextStyle(fontWeight: FontWeight.bold)),),

                  ],
                ),
                SizedBox(width: 26,),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                      color: Colors.lightBlue,
                      borderRadius: BorderRadius.circular(30)
                  ),
                  child: FlatButton(
                      onPressed: ()async{
                        if(_keys.currentState.validate()){
                          _keys.currentState.save();
                          loading(context);

                          final signIn = await _authRepository.signIn(_email, _password);
                          if(signIn != null){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                          }else{
                            print("error");
                          }
                        }
                      },
                      child: Text("Sign In", style: TextStyle(color: Colors.white, fontSize: 20),)),
                ),
              ],
            ),
          ),
        )
      ),
    );
  }
}
