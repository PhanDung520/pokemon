import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/pokemon.dart';
import 'package:pokemon_app/offline/viewmodels/fetch_data_offline.dart';
import 'package:pokemon_app/utils/connection_provider.dart';
import 'package:pokemon_app/values/app_colors.dart';

import '../../../../utils/utils.dart';
import '../../../detals_page/screens/detail_page.dart';
import '../../viewmodels/home_provider.dart';

class AllPokemonTab extends ConsumerStatefulWidget {
  const AllPokemonTab({
    Key? key, required this.userId, required this.isConnect
  }) : super(key: key);
  final int userId;
  final bool isConnect;


  @override
  ConsumerState createState() => _AllPokemonTabState();
}

class _AllPokemonTabState extends ConsumerState<AllPokemonTab> {
  @override
  void initState() {
    if(widget.isConnect == true){
      pokeGet().whenComplete(() => {
        fetchDataOffline(ref)
      });//get data
    }else{
      fetchDataOffline(ref);
    }
    super.initState();
  }

  Future<void> pokeGet() async{
    List<Pokemon> listPoke =[];
    if(mounted){
      await firestore.collection('pokemons').get().then((value) => {
        for(var element in value.docs){
          listPoke.add(Pokemon(element['class'], element['attack'], element['height'], element['hp'], element['id'], element['image'], element['name'], element['speed'], element['weight'], int.parse(element['like'].toString())))
        }
      });
      ref.read(pokeGet2Provider.notifier).state = listPoke;
    }
  }
  @override
  Widget build(BuildContext context) {
    final data = ref.watch(pokeGet2Provider);
    return Container(
      padding: const EdgeInsets.all(15),
      child: GridView.count(physics: const BouncingScrollPhysics(),childAspectRatio: (MediaQuery.of(context).size.width*0.5/ 250),crossAxisCount: 2, crossAxisSpacing: 8.0, mainAxisSpacing: 8.0, children: List.generate(data.length, (index) {
        return InkWell(
          onTap: (){
            //move to details
            Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailPage(pokemon: data[index], userId: widget.userId,isConnect: ref.watch(connectivityProvider),)));
          },
          child: Container( decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ), child: Column(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
            Container(alignment: Alignment.center,
              height: 100,width: MediaQuery.of(context).size.width*0.6,child: CachedNetworkImage(
          imageUrl: data[index].image,
            progressIndicatorBuilder: (context, url, downloadProgress) =>
                CircularProgressIndicator(value: downloadProgress.progress),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),),
            Container(margin: const EdgeInsets.only(left: 10),child: Column(crossAxisAlignment: CrossAxisAlignment.start,children: [
              Text('#${data[index].pokeId.toString()}'),
              Text(data[index].name, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),),
              Text(data[index].class1, style: const TextStyle(color: AppColors.lightTextColor, fontSize: 14),)
            ],),)
          ],),
          ),
        );
      }),),
    );
  }
}

