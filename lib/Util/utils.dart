import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {

  Utils();

  void showToast(String msg){
    Fluttertoast.showToast(msg: msg, backgroundColor: Colors.grey, toastLength: Toast.LENGTH_SHORT, gravity: ToastGravity.BOTTOM);
  }
}