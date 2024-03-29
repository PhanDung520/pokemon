import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/splash_page/splash_screen.dart';
import 'package:pokemon_app/utils/connection_provider.dart';

class ReloadScreen extends ConsumerStatefulWidget {
  const ReloadScreen({
    Key? key, required this.isLogout
  }) : super(key: key);
  final bool isLogout;

  @override
  ConsumerState createState() => _ReloadScreenState();
}

class _ReloadScreenState extends ConsumerState<ReloadScreen> {
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
    return _updateConnectionStatus(result);
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
                    ref.read(connectivityProvider.notifier).state = true;
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>const SplashScreen()));
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
