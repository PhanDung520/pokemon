import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/screens/home_page.dart';
import 'package:pokemon_app/pages/login_page/screens/login_page.dart';
import 'package:pokemon_app/utils/fetch_data_offline.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../reload_connection_page/screens/reload_screen.dart';

int? finalUserId =0;

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  ConnectivityResult connectivityResult = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  Future initConnectivity() async{
    late ConnectivityResult result;
    try{
      result = await _connectivity.checkConnectivity();
    }on PlatformException catch(e){
      print(e.toString());
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
  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedEmail = sharedPreferences.getInt('userId');
    finalUserId = obtainedEmail;
    //check first run
    await afterFirstCheck();
  }

  Future afterFirstCheck() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getBool('firstRun') == null){
      sharedPreferences.setBool('firstRun', false);
      //lan dau
    }else{
      //lan thu >1
    }
  }

  @override
  initState() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity().whenComplete(() => {
      movePage()
    });
    super.initState();
  }

  Future movePage()async{
    if(connectivityResult == ConnectivityResult.none){
      //khong co mang
      print('khong co mang');
      getValidationData().whenComplete(() async{//finalUserId == null? LoginPage(): HomePage(userId: finalUserId as int)
        Timer(Duration(seconds: 2),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
        finalUserId == null? ReloadScreen(): HomePage(userId: finalUserId as int)
        )));
      });

    }else{
      //co mang
      print('co mang');
      getValidationData().whenComplete(() async{//finalUserId == null? LoginPage(): HomePage(userId: finalUserId as int)
        Timer(Duration(seconds: 2),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
        finalUserId == null? LoginPage(): HomePage(userId: finalUserId as int)
        )));
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child:
        CircularProgressIndicator()
      ),
    );
  }
}


