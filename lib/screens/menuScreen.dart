import 'package:flutter/material.dart';
import 'package:flutter_fire/model/UserModel.dart';
import 'package:flutter_fire/service/DatabaseRepository.dart';
import 'package:flutter_fire/utils/getImage.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key key}) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel>(context);
    return Container(
      color: Colors.white,
      width: 200,
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(_user.name ?? "null"),
            accountEmail: Text(_user.email ?? "null"),
            currentAccountPicture: CircleAvatar(
                backgroundImage: _user.image != null
                    ? NetworkImage(_user.image)
                    : null,
                child: Stack(
                  children: [
                    if(_user.image == null)
                      Center(
                        child: Icon(Icons.person),
                      ),
                    if(loading)
                      Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    Positioned(
                        top: 40,
                        left: 32,
                        child: IconButton(icon: Icon(Icons.camera_alt),
                            onPressed: () async {
                              final data = await showModalBottomSheet(
                                  context: context,
                                  builder: (_){
                                    return GetImage();
                                  });
                              if(data != null){
                                loading = true;
                                setState(() {});
                                String urlImage = await DatabaseRepository().uploadImage(data, path: "profil");
                                if(urlImage != null){
                                  _user.image = urlImage;
                                  bool isUpdate = await DatabaseRepository().updateUser(_user);
                                  if(isUpdate){
                                    loading = false;
                                    setState(() {});
                                  }
                                }
                              }
                            })),
                  ],
                )
            ),),

        ],
      ),
    );
  }
}
