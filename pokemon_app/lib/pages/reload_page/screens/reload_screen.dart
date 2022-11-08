import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/pages/login_page/screens/login_screen.dart';


class ReloadScreen extends StatefulWidget {
  const ReloadScreen({Key? key, required this.isLogout}) : super(key: key);
  final bool isLogout;

  @override
  State<ReloadScreen> createState() => _ReloadScreenState();
}

class _ReloadScreenState extends State<ReloadScreen> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future initConnectivity() async{
    late ConnectivityResult result;
    try{
      result = await _connectivity.checkConnectivity();
    }on PlatformException catch(e){
      debugPrint(e.toString());
      return;
    }
    if(!mounted){
      return Future.value(null);
    }
    return await _updateConnectionStatus(result);
  }
  Future _updateConnectionStatus(ConnectivityResult result) async{
    setState((){
      connectivityResult = result;
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _connectivitySubscription.cancel();
  }
  @override
  void initState() {
    initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(widget.isLogout ==false?AppLocalizations.of(context)!.reload1:AppLocalizations.of(context)!.reload2,),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              height: 40,
              width: 90,
              decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(12)
              ),
              child: InkWell(
                onTap: (){
                  if(connectivityResult != ConnectivityResult.none){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const LoginScreen()));
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:const [
                    Icon(Icons.refresh),
                    Text('Reload')
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
