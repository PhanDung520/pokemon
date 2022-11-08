import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/allpokemon_bloc/allpokemon_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/allpokemon_bloc/allpokemon_event.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_event.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_state.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/profile_bloc/profile_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/components/all_pokemon_tab.dart';
import 'package:pokemon_app/pages/home_page/screens/components/favorites.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../values/app_colors.dart';
import '../../login_page/screens/login_screen.dart';
import '../../reload_page/screens/reload_screen.dart';
import 'components/dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key, required this.user, required this.isConnect}) : super(key: key);
  final User user;
  final bool isConnect;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AllPokeBloc>(create: (context) => AllPokeBloc()..add(LoadAllPokemon(isConnect: widget.isConnect))),
        BlocProvider<FavoritesBloc>(create: (context) => FavoritesBloc()..add(FavoritesLoad(userId: widget.user.userId, isConnect: widget.isConnect))),
        BlocProvider<ProfileBloc>(create: (context)=> ProfileBloc())
      ],
      child: DefaultTabController(
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
                              Text(widget.user.nameDisplay, style: const TextStyle(color: AppColors.textColor),)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Row(
                            children: [
                              Text('${AppLocalizations.of(context)!.username}: '),
                              Text(widget.user.username)
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 30, top: 10),
                          child: Row(
                            children: [
                              Text('${AppLocalizations.of(context)!.password}: '),
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
                                  if(widget.isConnect){
                                    showEditDialog(context, widget.user);
                                  }else{
                                    showDoneDialog(context, 'no internet');
                                  }
                                },
                                child: Container(height: 30, width: 60,alignment: Alignment.center,
                                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                                  child: Text(AppLocalizations.of(context)!.edit),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 30, left: 10),
                              child: Container(height: 30, width: 85,alignment: Alignment.center,
                                decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(12)),
                                child: InkWell( onTap: () async{
                                  if(widget.isConnect){
                                    final SharedPreferences shared = await SharedPreferences.getInstance();
                                    shared.remove('userId');
                                    if (!mounted){
                                      return;
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
                                  }else{
                                    final SharedPreferences shared = await SharedPreferences.getInstance();
                                    shared.remove('userId');
                                    if (!mounted){
                                      return;
                                    }
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=> const ReloadScreen(isLogout: true,)));
                                  }
                                },child: Text(AppLocalizations.of(context)!.logout)),
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
            title: Text(AppLocalizations.of(context)!.pokemonapp, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
            centerTitle: true ,
            bottom: TabBar(
              indicatorWeight: 4,
              indicatorColor: AppColors.primaryColor,
              tabs: [
                Tab(
                  child: Text(AppLocalizations.of(context)!.allPokemon, style: const TextStyle(color: AppColors.textColor, fontSize: 16, fontWeight: FontWeight.w500),),
                ),
                Tab(child:
                Row(
                  children: [
                    Text(AppLocalizations.of(context)!.favorite, style: const TextStyle(fontSize: 16, color: AppColors.textColor, fontWeight: FontWeight.w500),),
                    Visibility(
                      visible: true,
                      child: Container(
                        width: 15,
                        height: 15,
                        margin: const EdgeInsets.only(bottom: 10, left: 2),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: AppColors.primaryColor
                        ),
                        child: BlocBuilder<FavoritesBloc, FavoritesState>(
                            builder: (context, state){
                              return Text(state is FavoritesSuccess? state.listPoke.length.toString(): '*', style: const TextStyle(color: Colors.white, fontSize: 11),);
                            },
                        ),
                      ),
                    )
                  ],
                ),)
              ],
            ),
          ),
          body: TabBarView(children: [
            AllPokemonTab(userId: widget.user.userId, isConnect:widget.isConnect),
            FavoritesTab(userId: widget.user.userId,isConnect: widget.isConnect),
          ],),
        ),
      ),
    );
  }
}
