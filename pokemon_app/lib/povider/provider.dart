import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pokemon.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'provider.freezed.dart';

final listDataProvider = StateProvider<List<User>>((ref) =>[]);
Future<void> initUser(List<User> listUser) async{
  await firestore.collection('users').get().then((value) => {
    value.docs.forEach((element) {
      User user = User(element['username'], element['password'], element['userId']);
      listUser.add(user);
    })
  });
}

final userGetProvider = Provider<List<User>>((ref) {
  List<User> listUser = [];
  initUser(listUser);
  return listUser;
});

// final userGetProvider = FutureProvider<List<User>>((ref) async {
//   List<User> listUser = [];
//   await firestore.collection('users').get().then((value) => {
//     value.docs.forEach((element) {
//       User user = User(element['username'], element['password'], element['userId']);
//       listUser.add(user);
//     })
//   });
//   return listUser;
// });

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


final pokeGetProvider = FutureProvider<List<Pokemon>>((ref) async {
  List<Pokemon> listPoke = [];
  await firestore.collection('pokemons').get().then((value) => {
    value.docs.forEach((element) {
      listPoke.add(Pokemon(element['class'], element['attack'], element['height'], element['hp'], element['id'], element['image'], element['name'], element['speed'], element['weight']));
    })
  });
  return listPoke;
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

