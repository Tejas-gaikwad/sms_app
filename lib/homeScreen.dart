import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:sms_retriever/main.dart';
import 'package:sms_retriever/secureMid.dart';
import 'package:telephony/telephony.dart';
import 'package:http/http.dart' as http;
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';

import 'notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Telephony telephony = Telephony.instance;
  var res;
  var name;
  var midString;
  late TextEditingController midController;

  Future getMIDData() async {
    name = await SecureMid.getMid();
    setState(() {
      this.midString = name;
      // this.midController.text = name;
    });
    log(name.toString() + "            ooooooooooo");
  }

  @override
  void initState() {
    super.initState();
    getMIDData();
    telephony.listenIncomingSms(
      onNewMessage: (SmsMessage message) async {
        await NotificationUtils.showNotification(
            title: " $name    notification , ${message.body}");
        // await gotSMSApi(
        //   message.address.toString(),
        //   midString.toString(),
        //   message.body.toString(),
        //   DateTime.now().toString(),
        // );
      },
      onBackgroundMessage: backgrounMessageHandler,
      listenInBackground: true,
    );

    // midController = TextEditingController(text: midString.toString());

    midController = TextEditingController(
        // text: midString.toString(),
        );
    // super.initState();
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
      "midId": midStr,
      "senderId": senderId,
      "smsContent": smsContent,
      "smsTime": smsTime,
    };
    // "msg": encrypted.base64.toString(),
    log(data.toString());
    // encrypted = encrypter.encrypt(data.toString());
    var res = await http.post(
      Uri.parse("https://test.imoneypay.in/pgws/bingoUpiResponse"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        "senderId": senderId,
        "merchantId": midStr,
        "smsContent": smsContent,
        "smsTime": smsTime,
      }),
    );

    log("DATA is  :     $midStr, $senderId, $smsContent, $smsTime");
    // log("encryptedText :     ${encrypted.base64.toString()}");
    log("Response bddy ...............       ${res.body.toString()}");
    log("Response status ...............       ${res.statusCode.toString()}");

    print("Api end.................");

    setState(() {
      apiHit = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(midString.toString() + "   --------------------------       ");
    // print(name.toString() + "   +++++++++++++++++++++++       ");
    return Scaffold(
      body: SafeArea(
        child: Container(
          alignment: Alignment.topLeft,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: const Text(
                    "Your mid ID is : ",
                    style: TextStyle(fontSize: 30),
                  ),
                ),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Text(
                    midString == null
                        ? "No MID available"
                        : midString.toString(),
                    style: const TextStyle(
                      fontSize: 30,
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.black)),
                  child: TextField(
                    controller: midController,
                    decoration: const InputDecoration(
                      hintText: "Enter new MID",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: InkWell(
                    onTap: () async {
                      if (midController.text.isEmpty) {
                        const snackBar = SnackBar(
                          content: Text('Hey! Please enter the MID id.'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        await SecureMid.setMid(
                          midController.text,
                          context,
                        );
                        setState(() {
                          midString = midController.text;
                          midController.clear();
                        });
                      }
                      // setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.blueAccent.withOpacity(0.4),
                      height: MediaQuery.of(context).size.height * 0.04,
                      child: const Text(
                        "Save",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      border: Border.all(color: Colors.black)),
                  child: Text(apiHit == true ? "TRUE" : "FALSE"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
