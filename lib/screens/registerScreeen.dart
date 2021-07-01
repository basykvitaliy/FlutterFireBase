import 'package:flutter/material.dart';
import 'package:flutter_fire/screens/loginScreeen.dart';
import 'package:flutter_fire/screens/nomeScreen.dart';
import 'package:flutter_fire/service/AuthRepository.dart';
import 'package:flutter_fire/utils/loading.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  AuthRepository _authRepository = AuthRepository();

  final _keys = GlobalKey<FormState>();
  String _email;
  String _name;
  String _password;
  String _confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Register"),
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
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name"
                      ),
                      onChanged: (e) => _name = e,
                      validator: (e) => e.trim().isEmpty ? "Enter email" : null,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email"
                      ),
                      onChanged: (e) => _email = e,
                      validator: (e) => e.trim().isEmpty ? "Enter email" : null,
                    ),
                  ),
                  SizedBox(width: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                    child: TextFormField(

                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password"
                      ),
                      onChanged: (e) => _password = e,
                      validator: (e) => e.trim().isEmpty == null ? "Enter password" : e.length < 6 ? "пароль должен быть не менее 6 символов" : null,
                    ),
                  ),
                  SizedBox(width: 16,),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 36, vertical: 8),
                    child: TextFormField(

                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Confirm Password"
                      ),
                      onChanged: (e) => _confirmPassword = e,
                      validator: (e) => e.trim().isEmpty == null ? "Enter password" : e.length < 6 ? "пароль должен быть не менее 6 символов" : null,
                    ),
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
                            final register = await _authRepository.createUser(_email, _password, _name);
                            if(register != null){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx) => HomeScreen()));
                            }else{
                              print("error");
                            }
                          }
                        },
                        child: Text("Register", style: TextStyle(color: Colors.white, fontSize: 20),)),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Do you have account?"),
                      FlatButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen())),
                        child:Text("Sign In", style: TextStyle(fontWeight: FontWeight.bold)),),

                    ],
                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}
