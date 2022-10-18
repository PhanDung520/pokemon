import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/screens/tabs/all_pokemon_tab.dart';
import 'package:pokemon_app/pages/home_page/screens/tabs/dialog.dart';
import 'package:pokemon_app/pages/home_page/screens/tabs/favourties.dart';
import 'package:pokemon_app/pages/login_page/screens/login_page.dart';
import 'package:pokemon_app/pages/login_page/viewmodels/login_controller.dart';
import 'package:pokemon_app/pages/reload_connection_page/screens/reload_screen.dart';
import 'package:pokemon_app/utils/connection_provider.dart';

import 'package:pokemon_app/values/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../detals_page/viewmodel/detail_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key, required this.userId, required this.isConnect
  }) : super(key: key);
  final int userId;
  final bool isConnect;


  @override
  ConsumerState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    ref.watch(favProvider3(widget.userId));
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            InkWell(onTap: (){
              showModalBottomSheet(isScrollControlled: true,context: context, builder: (context){
                return Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: InkWell(child: const Icon(Icons.close), onTap: (){
                          Navigator.pop(context);
                        },),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 20),
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 30,),
                            Text(ref.watch(userLoginProvider).nameDisplay, style: const TextStyle(color: AppColors.textColor),)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10),
                        child: Row(
                          children: [
                            const Text('Username: '),
                            Container(
                              child: Text(
                                ref.watch(userLoginProvider).name
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30, top: 10),
                        child: Row(
                          children: [
                            const Text('Password: '),
                            const Text('***********')
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 30, right: 10),
                            child: InkWell(
                              onTap:(){
                                if(ref.watch(connectivityProvider)){
                                  showEditDialog(context, ref, widget.userId);
                                }else{
                                  showDoneDialog(context, 'no internet');
                                }
                              },
                              child: Container(height: 30, width: 60,alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                              child: const Text('Edit'),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 30, left: 10),
                            child: Container(height: 30, width: 60,alignment: Alignment.center,
                              decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                              child: InkWell( onTap: () async{
                                if(ref.watch(connectivityProvider)){
                                  final SharedPreferences shared = await SharedPreferences.getInstance();
                                  shared.remove('userId');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginPage()));
                                }else{
                                  final SharedPreferences shared = await SharedPreferences.getInstance();
                                  shared.remove('userId');
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> const ReloadScreen(isLogout: true,)));
                                }
                              },child: const Text('Logout')),
                            ),
                          )
                        ],
                      )
                  ],),
                );
              });
            },child: Container(height: 40, width: 40, alignment: Alignment.center, margin: const EdgeInsetsDirectional.only(end: 20),child: const Icon(Icons.person, color: Colors.black38,)))
          ],
          backgroundColor: Colors.white,
          title: const Text('Pokemon App', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
          centerTitle: true ,
          bottom: TabBar(
            indicatorWeight: 4,
            indicatorColor: AppColors.primaryColor,
            tabs: [
              const Tab(
                child: Text('All Pokemon', style: TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),),
              ),
              Tab(child:
              Row(
                children: [
                  const Text('Favourites', style: TextStyle(fontSize: 16, color: AppColors.textColor, fontWeight: FontWeight.w500),),
                  Visibility(
                    visible: true,
                    child: Container(
                      width: 15,
                      height: 15,
                      margin: const EdgeInsets.only(bottom: 10, left: 2),
                      alignment: Alignment.center,
                      child: Text(ref.watch(fProvider3).length.toString(), style: const TextStyle(color: Colors.white, fontSize: 11),),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColors.primaryColor
                      ),
                    ),
                  )
                ],
              ),)
            ],
          ),
        ),
        body: TabBarView(children: [
          AllPokemonTab(userId: widget.userId, isConnect:ref.watch(connectivityProvider)),
          FavourtiesTab(userId: widget.userId,),
        ],),
      ),
    );
  }
}