import 'package:flutter/material.dart';

class ReloadScreen extends StatelessWidget {
  const ReloadScreen({Key? key, required this.isLogout}) : super(key: key);
  final bool isLogout;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Reload screen'),
      ),
    );
  }
}
