import 'package:flutter/material.dart';

loading(context) => showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => Center(
          child: Container(
            width: 30,
            height: 30,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
        ));
