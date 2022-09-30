import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/pokemon.dart';
import '../../utils/utils.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_controller.freezed.dart';



Stream<Pokemon> getPokeByName(int pokeId) async*{
  late Pokemon poke;
  await firestore.collection('pokemons').doc(pokeId.toString()).get().then((documentSnapshot) => {
    poke = Pokemon(documentSnapshot['class'], documentSnapshot['attack'], documentSnapshot['height'], documentSnapshot['hp'], documentSnapshot['id'], documentSnapshot['image'], documentSnapshot['name'], documentSnapshot['speed'], documentSnapshot['weight'])
  });
  yield poke;
}

final pokeByIdProvider = StreamProvider.family<Pokemon, int>((ref, pokeId) {
  return getPokeByName(pokeId);
});




@freezed
class myParamsUserIdPoke with _$myParamsUserIdPoke{
  factory myParamsUserIdPoke({
    required int userId,
    required Pokemon poke
  }) = _myParamsUserIdPoke;
}

final addPokeToFavProvider = FutureProvider.family<void, myParamsUserIdPoke>((ref, params) async {
  DocumentReference doc_ref = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  Map<String, dynamic> data ={};
  return await doc_ref.set(data);
});

final removePokeFromPavProvider = FutureProvider.family<void, myParamsUserIdPoke>((ref, params) async {
  DocumentReference doc_ref = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  print('pekedeleted: ${params.poke.pokeId}');
  return doc_ref.delete();
});
