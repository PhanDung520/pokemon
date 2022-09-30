import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/pokemon.dart';
import '../../models/user.dart';
import '../../utils/utils.dart';


Stream<List<Pokemon>> getListFa(int userId) async*{
  List<Pokemon> listFa = [];
  List<int> listPokeId =[];
  //getDociD
  await firestore.collection('users').doc(userId.toString()).collection('favourite').get().then((value) => {
    value.docs.forEach((element) {
      int i = int.parse(element.id);
      if(i <100){
        print('docId: $i');
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
  yield listFa;
}

final favProvider = StreamProvider.family.autoDispose<List<Pokemon>, int>((ref, userId) {
  return getListFa(userId);
});

final pokeGetProvider = FutureProvider<List<Pokemon>>((ref) async {
  List<Pokemon> listPoke = [];
  await firestore.collection('pokemons').get().then((value) => {
    value.docs.forEach((element) {
      listPoke.add(Pokemon(element['class'], element['attack'], element['height'], element['hp'], element['id'], element['image'], element['name'], element['speed'], element['weight']));
    })
  });
  return listPoke;
});