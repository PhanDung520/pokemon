import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/home_page/tabs/all_pokemon_tab.dart';
import 'package:pokemon_app/pages/home_page/tabs/favourties.dart';
import 'package:pokemon_app/values/app_colors.dart';

import '../detals_page/detail_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    Key? key, required this.userId
  }) : super(key: key);
  final int userId;


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
                return Container(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height,
                    child: Center(child:
                      Text('Profile tab'),),);
              });
            },child: Container(height: 40, width: 40, alignment: Alignment.center, margin: EdgeInsetsDirectional.only(end: 20),child: Icon(Icons.person, color: Colors.black38,)))
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
          AllPokemonTab(userId: widget.userId,),
          FavourtiesTab(userId: widget.userId,),
        ],),
      ),
    );
  }
}
