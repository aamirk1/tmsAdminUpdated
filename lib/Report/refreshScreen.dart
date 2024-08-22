import 'package:flutter/material.dart';

class Refreshscreen extends StatefulWidget {
  const Refreshscreen({super.key});

  @override
  State<Refreshscreen> createState() => _RefreshscreenState();
}

class _RefreshscreenState extends State<Refreshscreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
