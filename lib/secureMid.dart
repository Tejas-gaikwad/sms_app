import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureMid {
  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static const _keyMid = 'MIDString';

  static Future setMid(String midString, BuildContext context) async {
    await _secureStorage.write(key: _keyMid, value: midString);
    log("MID is saved");
    const snackBar = SnackBar(
      content: Text('MID saved Succesfully...'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Future getMid() async {
    var res = await _secureStorage.read(
      key: _keyMid,
    );

    log("MID is retrieved ${res.toString()} ");

    return res;
  }
}
