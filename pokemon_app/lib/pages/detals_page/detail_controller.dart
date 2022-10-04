import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/pages/detals_page/detail_state.dart';

import '../../models/pokemon.dart';
import '../../utils/utils.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_controller.freezed.dart';


@freezed
class myParamsUserIdPoke with _$myParamsUserIdPoke{
  factory myParamsUserIdPoke({
    required int userId,
    required Pokemon poke
  }) = _myParamsUserIdPoke;
}

final addPokeToFavProvider = FutureProvider.family.autoDispose<void, myParamsUserIdPoke>((ref, params) async {
  print('add');
  DocumentReference doc_ref = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  Map<String, dynamic> data ={};
  print('pokeAdded: ${params.poke.pokeId}');

  return await doc_ref.set(data);
});


final removePokeFromPavProvider = FutureProvider.family.autoDispose<void, myParamsUserIdPoke>((ref, params) async {
  print('remove'
      '');

  DocumentReference doc_ref = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  print('pekedeleted: ${params.poke.pokeId}');
  return doc_ref.delete();
});
///////////////////////////////////////////////////////
Future<void> getListFa2(int userId, List<Pokemon> listFa) async{
  List<int> listPokeId =[];
  //getDociD
  await firestore.collection('users').doc(userId.toString()).collection('favourite').get().then((value) => {
    value.docs.forEach((element) {
      int i = int.parse(element.id);
      if(i <100){
        listPokeId.add(i);
      }
    })
  });
  List<Future> listF = [];
  //tim kiem voi poke id
  listPokeId.forEach((element)  {
    var a = firestore.collection('pokemons').doc(element.toString()).get().then((documentSnapshot){
      listFa.add(Pokemon(documentSnapshot['class'], documentSnapshot['attack'], documentSnapshot['height'], documentSnapshot['hp'], documentSnapshot['id'], documentSnapshot['image'], documentSnapshot['name'], documentSnapshot['speed'], documentSnapshot['weight']));
    });
    listF.add(a);
  });
  final result = await Future.wait(listF);
}

final fProvider3 = StateProvider<List<Pokemon>>((ref) =>[]);

final favProvider3 = FutureProvider.family<void, int>((ref, userId) async {
  List<Pokemon> listFa = [];//this is listFav
  await getListFa2(userId,listFa);
  ref.read(fProvider3.notifier).state = listFa;
});

final detailStateProvider = StateProvider.autoDispose((ref) => DetailStatus.isLoading);

class DetailController{
  Future<void> checkFavourite(Pokemon pokemon, int userId, WidgetRef ref) async{
    //get all favourite
    List<Pokemon> listFav = [];
    int count =0;
    await getListFa2(userId,listFav);
    listFav.forEach((element) {
      if(element.pokeId == pokemon.pokeId){
        //this poke is in fav
        ref.read(detailStateProvider.notifier).state = DetailStatus.isFavourite;
        count =1;
      }
    });
    if(count ==0){
      ref.read(detailStateProvider.notifier).state = DetailStatus.isNotFavourite;
    }
  }
}
