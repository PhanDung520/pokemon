import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/tabs/all_pokemon_tab.dart';
import 'package:pokemon_app/pages/home_page/tabs/favourties.dart';
import 'package:pokemon_app/values/app_colors.dart';

import '../../models/user.dart';
import '../../povider/provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({
    Key? key, required this.userId
  }) : super(key: key);
  final int userId;


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favValue = ref.watch(favProvider(userId));
    int num =0;
    favValue.when(data: (data){num=data.length;}, error: (e, stack){}, loading: (){});
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
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
                        margin: EdgeInsets.only(bottom: 10, left: 2),
                        alignment: Alignment.center,
                        child: Text(num.toString(), style: TextStyle(color: Colors.white, fontSize: 11),),
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
          AllPokemonTab(userId: userId,),
          FavourtiesTab(userId: userId,),
        ],),
      ),

    );
  }
}