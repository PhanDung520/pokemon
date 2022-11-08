import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_event.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_state.dart';
import '../../../../values/app_colors.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../../../detail_page/screens/detail_screen.dart';

class FavoritesTab extends StatefulWidget {
  const FavoritesTab({Key? key, required this.userId, required this.isConnect}) : super(key: key);
  final int userId;
  final bool isConnect;

  @override
  State<FavoritesTab> createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(builder: (context,state){
      if(state is FavoritesSuccess){
        return Container(
          padding: const EdgeInsets.all(15),
          child: GridView.count(physics: const BouncingScrollPhysics(),childAspectRatio: (MediaQuery.of(context).size.width*0.5/ 250),crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, children: List.generate(state.listPoke.length, (index) {
            return InkWell(
              onTap: () async {
                //move to details
                final result = await Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(pokemon: state.listPoke[index], userId: widget.userId,isConnect: widget.isConnect,)));
                if(result == "Returned"){
                  if(!mounted){
                    return;
                  }
                  context.read<FavoritesBloc>().add(FavoritesLoad(userId: widget.userId, isConnect: widget.isConnect));
                }
              },
              child: Container( decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ), child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                Container(alignment: Alignment.center,
                  height: 100,width: MediaQuery.of(context).size.width*0.6,child: CachedNetworkImage(
                    imageUrl: state.listPoke[index].image,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        CircularProgressIndicator(value: downloadProgress.progress),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                  ),),
                Container(margin: const EdgeInsets.only(left: 10),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
                  Text('#${state.listPoke[index].pokeId.toString()}'),
                  Text(state.listPoke[index].name, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
                  Text(state.listPoke[index].class1, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 14),)
                ],),)
              ],),
              ),
            );
          }),),
        );
      }else {
        return const Center(
        child: CircularProgressIndicator(),
      );
      }
    }, listener: (context, state){
    });
  }
}
