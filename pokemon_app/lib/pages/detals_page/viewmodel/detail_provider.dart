import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pokemon_app/models/comment.dart';
import 'package:pokemon_app/models/user.dart';
import 'package:pokemon_app/pages/detals_page/viewmodel/detail_state.dart';

import '../../../models/pokemon.dart';
import '../../../utils/utils.dart';

import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_provider.freezed.dart';


@freezed
class MyParamsUserIdPoke with _$MyParamsUserIdPoke{
  factory MyParamsUserIdPoke({
    required int userId,
    required Pokemon poke
  }) = _MyParamsUserIdPoke;
}

final likeCountProvider = StateProvider.family<int, Pokemon>((ref, poke) =>poke.like);


final addPokeToFavProvider = FutureProvider.family.autoDispose<void, MyParamsUserIdPoke>((ref, params) async {
  DocumentReference documentReference = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  Map<String, dynamic> data ={};
  //set like +1
  int newLike = params.poke.like ;
  var b = firestore.collection('pokemons').doc(params.poke.pokeId.toString()).get().then((value) => {
    newLike = int.parse(value.get('like').toString()) +1
  });
  await documentReference.set(data);
  List<Future> listF=[];
  var a = firestore.collection('pokemons').doc(params.poke.pokeId.toString()).update({
    'like': newLike.toString()
  });
  listF.add(b);
  listF.add(a);
  await Future.wait(listF);
  await firestore.collection('pokemons').doc(params.poke.pokeId.toString()).get().then((value) => {
    ref.read(likeCountProvider(params.poke).notifier).state = int.parse(value.get('like').toString())
  });
});


final removePokeFromPavProvider = FutureProvider.family.autoDispose<void, MyParamsUserIdPoke>((ref, params) async {
  DocumentReference documentReference = firestore.collection('users').doc(params.userId.toString()).collection('favourite').doc(params.poke.pokeId.toString());
  int newLike = params.poke.like ;
  var b = firestore.collection('pokemons').doc(params.poke.pokeId.toString()).get().then((value) => {
    newLike = int.parse(value.get('like').toString()) - 1
  });

  await documentReference.delete();
  List<Future> listF =[];
  var a = firestore.collection('pokemons').doc(params.poke.pokeId.toString()).update({
    'like': newLike.toString()
  });
  listF.add(b);
  listF.add(a);
  await Future.wait(listF);
  await firestore.collection('pokemons').doc(params.poke.pokeId.toString()).get().then((value) => {
    ref.read(likeCountProvider(params.poke).notifier).state = int.parse(value.get('like').toString())
  });
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
      listFa.add(Pokemon(documentSnapshot['class'], documentSnapshot['attack'], documentSnapshot['height'], documentSnapshot['hp'], documentSnapshot['id'], documentSnapshot['image'], documentSnapshot['name'], documentSnapshot['speed'], documentSnapshot['weight'],int.parse(documentSnapshot['like'].toString())));
    });
    listF.add(a);
  });
  await Future.wait(listF);
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

// add cmt, remove cmt(only user that added)
final commentProvider = StateNotifierProvider<CommentNotifier, CommentState>((ref) {
  return CommentNotifier();
});
final getListCmtProvider = StateProvider<List<Comment>>((ref) =>[]);

class CommentNotifier extends StateNotifier<CommentState>{
  CommentNotifier(): super(const CommentState.loading());
  Future<void> commentDisplay(int pokeId, WidgetRef ref) async{
    List<Comment> listCmt = [];
    await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').get().then((value) => {
      value.docs.forEach((element) {
        if(int.parse(element['cmtId']) !=999){
          listCmt.add(Comment(int.parse(element['userId']), int.parse(element['cmtId']), element['desc'], ''));
        }
      })
    });
    // get all user
    List<User> userList =[];
    await firestore.collection('users').get().then((value) => {
      value.docs.forEach((element) {
        userList.add(User(element['username'], element['password'], int.parse(element['userId']), element['name']));
      })
    });

    for(Comment cmt in listCmt){
      for(User user in userList){
        if(cmt.userId == user.userId){
          cmt.name = user.nameDisplay;
          break;
        }
      }
    }
    ref.read(getListCmtProvider.notifier).state = listCmt;
  }
  
  Future<void> addComment(int pokeId,int userId,String desc, WidgetRef ref)async{
    //get the last id
    int idLast =0;
    await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').get().then((value) => {
      value.docs.forEach((element) {
        if(int.parse(element['cmtId'])!= 999){
          idLast = int.parse(element['cmtId']);
        }
      })
    });
    if(idLast == 0){
      //error
      state = const CommentState.error();
    }
    else{
      //do add
      idLast++;
      await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').doc(idLast.toString()).set({
        'userId': userId.toString(),
        'cmtId':idLast.toString(),
        'desc': desc
      });
      ref.refresh(commentProvider.notifier).commentDisplay(pokeId, ref);
    }
  }
}

