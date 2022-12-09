import 'package:flutter/material.dart';

class SmsData extends StatefulWidget {
  const SmsData({super.key});

  @override
  State<SmsData> createState() => _SmsDataState();
}

class _SmsDataState extends State<SmsData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          color: Colors.greenAccent,
          child: Column(
            children: const [
              SizedBox(height: 20),
              Text("Message Data"),
            ],
          ),
        ),
      ),
    );
  }
}
