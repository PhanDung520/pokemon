import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/home_page/screens/home_screen.dart';
import 'package:pokemon_app/pages/login_page/screens/login_screen.dart';
import 'package:pokemon_app/pages/reload_page/screens/reload_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

User? finalUserId;

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
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
  Future getValidationData() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var obtainedUser = sharedPreferences.getString('user');
    if(obtainedUser!= null){
      finalUserId = User.fromJson(jsonDecode(obtainedUser));
    }
    //check first run
    await afterFirstCheck();
  }

  Future afterFirstCheck() async{
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if(sharedPreferences.getBool('firstRun') == null){
      sharedPreferences.setBool('firstRun', false);
      //lan dau
      // ref.read(isFirstRunProvider.notifier).state = true;
    }else{
      //lan thu >1
      // ref.read(isFirstRunProvider.notifier).state = false;
    }
  }
  Future movePage()async{
    if(connectivityResult == ConnectivityResult.none){
      //khong co mang
      getValidationData().whenComplete(() async{//finalUserId == null? LoginPage(): HomePage(userId: finalUserId as int)
        Timer(const Duration(seconds: 2),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
        finalUserId == null? const ReloadScreen(isLogout: false,): HomeScreen(user: finalUserId as User, isConnect: false,)
        )));
      });
    }else{
      //co mang
      getValidationData().whenComplete(() async{//finalUserId == null? LoginPage(): HomePage(userId: finalUserId as int)
        Timer(const Duration(seconds: 2),()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>
        finalUserId == null? const LoginScreen(): HomeScreen(user: finalUserId as User, isConnect: true,)
        )));
      });
    }
  }
  @override
  void initState() {
    // TODO: implement initState
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    initConnectivity().whenComplete(() => {
      movePage()
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
