import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sms_retriever/secureMid.dart';
import 'package:telephony/telephony.dart';
import 'homeScreen.dart';
import 'notification.dart';
import 'package:http/http.dart' as http;

backgrounMessageHandler(SmsMessage message) async {
  final name = await SecureMid.getMid();

  await NotificationUtils.showNotification(
    title: " $name    notification , ${message.body}",
  );

  // await gotSMSApi(
  //   message.address.toString(),
  //   name.toString(),
  //   message.body.toString(),
  //   DateTime.now().toString(),
  // );
}

bool apiHit = false;

gotSMSApi(
  String senderId,
  String midStr,
  String smsContent,
  String smsTime,
) async {
  print("Api call start.................");
  // final publicPem = await rootBundle.loadString('test/public.pem');
  // final publicKey = RSAKeyParser().parse(publicPem) as RSAPublicKey;
  // final primavtePem = await rootBundle.loadString('test/private.pem');
  // final privKey = RSAKeyParser().parse(primavtePem) as RSAPrivateKey;
  // final plainText = smsContent.toString();
  // Encrypter encrypter;
  // Encrypted encrypted;
  // encrypter = Encrypter(
  //   RSA(
  //     publicKey: publicKey,
  //     privateKey: privKey,
  //   ),
  // );
  // encrypted = encrypter.encrypt(plainText);

  Map data = {
    "senderid": senderId,
    "merchantid": midStr,
    "smscontent": smsContent,
    "smstime": smsTime,
  };
  // encrypted = encrypter.encrypt(data.toString());
  var res = await http.post(
    Uri.parse("https://test.imoneypay.in/pgws/bingoUpiResponse"),
    headers: {"content-type": "application/json"},
    body: jsonEncode({
      "senderId": senderId,
      "merchantId": midStr,
      "smsContent": smsContent,
      "smsTime": smsTime,
    }),
  );
  print("API End...............");
  // setState(() {
  apiHit = true;
  // });
}

var midString;

Future getMIDData() async {
  final name = await SecureMid.getMid();
  midString = name;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getMIDData();
  await NotificationUtils.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS details app',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
