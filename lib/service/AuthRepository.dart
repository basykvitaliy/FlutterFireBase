import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_fire/model/UserModel.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';

class AuthRepository{
  FirebaseAuth auth = FirebaseAuth.instance;

  Future<User> get user async{
    final user = FirebaseAuth.instance.currentUser;
    return user;
  }

  Future signOut()async{
    try{
      return auth.signOut();
    }catch(e){
      return null;
    }
  }

  Future<User> createUser(String email, String password, String name) async {
    try {
      var result = await auth.createUserWithEmailAndPassword(email: email, password: password);
      if(result.user != null){
       await DatabaseRepository().saveUser(UserModel(id: auth.currentUser.uid, email: auth.currentUser.email, name: name));
      }
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }

  // Sign In with email and password

  Future<User> signIn(String email, String password) async {
    try {
      var result = await auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    } catch (e) {
      print(e.toString());
    }
  }
}