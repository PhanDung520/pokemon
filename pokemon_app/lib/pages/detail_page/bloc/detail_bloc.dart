import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/models/pokemon/pokemon.dart';
import 'package:pokemon_app/offline/fetch_data_offline.dart';
import 'package:pokemon_app/pages/detail_page/bloc/detail_event.dart';
import 'package:pokemon_app/pages/detail_page/bloc/detail_state.dart';

import '../../../models/comment.dart';
import '../../../models/user.dart';
import '../../../utils/firebase_reference.dart';

class DetailFavoriteBloc extends Bloc<DetailEvent, DetailState>{
  DetailFavoriteBloc(): super(DetailFavoriteInitial()){
    on<CheckIsFavorite>(_onCheckIsFavorite);
    on<AddToFavorite>(_onAddToFavorite);
    on<RemoveFromFavorite>(_onRemoveFromFavorite);
  }
  Future<void> _onCheckIsFavorite(CheckIsFavorite event, Emitter emitter) async {
    emit(DetailFavoriteLoading());
    if(event.isConnect){
      await checkFavourite(event.pokemon, event.userId);
    }else {
      final listFavorite = await fetchFavoriteOffline(event.userId, [], false);
      int count =0;
      for(Pokemon pokemonF in listFavorite){
        if(pokemonF.pokeId == event.userId){
          count =1;
        }
      }
      if(count ==1){
        emitter(DetailFavoriteIsTrue(newLike: event.pokemon.like));
      }else{
        emitter(DetailFavoriteIsFalse(newLike: event.pokemon.like));
      }
    }
  }

  Future<void> _onAddToFavorite(AddToFavorite event, Emitter emitter) async {
    emit(DetailFavoriteLoading());
    await addPokemonToFavorite(event.pokemon, event.userId);
  }

  Future<void> _onRemoveFromFavorite(RemoveFromFavorite event, Emitter emitter) async {
    emit(DetailFavoriteLoading());
    await removePokemonFromFavorite(event.pokemon, event.userId);
  }
  Future<void> addPokemonToFavorite(Pokemon pokemon, int userId) async {
    DocumentReference documentReference = firestore.collection('users').doc(userId.toString()).collection('favourite').doc(pokemon.pokeId.toString());
    Map<String, dynamic> data ={};
    //set like +1
    int newLike = pokemon.like ;
    await documentReference.set(data);
    var b = firestore.collection('pokemons').doc(pokemon.pokeId.toString()).get().then((value) => {
      newLike = int.parse(value.get('like').toString()) +1
    }).then((value) => {
      firestore.collection('pokemons').doc(pokemon.pokeId.toString()).update({
        'like': newLike.toString()
      })
    });
    List<Future> listF=[];

    listF.add(b);
    await Future.wait(listF);
    await checkFavourite(pokemon, userId);
  }


  Future<void> removePokemonFromFavorite(Pokemon pokemon,int userId) async{
    DocumentReference documentReference = firestore.collection('users').doc(userId.toString()).collection('favourite').doc(pokemon.pokeId.toString());
    int newLike = pokemon.like ;

    await documentReference.delete();
    var b = firestore.collection('pokemons').doc(pokemon.pokeId.toString()).get().then((value) => {
      newLike = int.parse(value.get('like').toString()) - 1
    }).then((value) => {
      firestore.collection('pokemons').doc(pokemon.pokeId.toString()).update({
        'like': newLike.toString()
      })

    });
    List<Future> listF =[];
    listF.add(b);
    // listF.add(a);
    await Future.wait(listF);
    await checkFavourite(pokemon, userId);
  }

  Future<void> checkFavourite(Pokemon pokemon, int userId) async{
    //get all favourite
    List<int> listFavId = [];
    int count =0;
    await firestore.collection('users').doc(userId.toString()).collection('favourite').get().then((value) => {
      for(var element in value.docs){
        listFavId.add(int.parse(element.id))
      }
    });
    for(int id in listFavId){
      if(pokemon.pokeId == id){
        count = 1;
      }
    }
    await firestore.collection('pokemons').doc(pokemon.pokeId.toString()).get().then((value) => {
      //count new like
      if(count == 1){
        emit(DetailFavoriteIsTrue(newLike: int.parse(value.get('like').toString())))
      }else{
        emit(DetailFavoriteIsFalse(newLike: int.parse(value.get('like').toString())))
        }
      }
    );
  }
}



class DetailLoadCommentBloc extends Bloc<DetailEvent, DetailState>{
  DetailLoadCommentBloc(): super(DetailLoadCommentInitial()){
    on<LoadComment>(_onLoadComment);
  }

  Future<void> _onLoadComment(LoadComment event, Emitter emitter) async {
    emit(DetailLoadCommentLoading());
    if(event.isConnect){
      await commentDisplay(event.pokeId);
    }else{
      emitter(const DetailLoadCommentSuccess(listCmt: []));
    }
  }

  Future<List<Comment>> commentDisplay(int pokeId) async{
    List<Comment> listCmt = [];
    await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').get().then((value) => {
      for(var element in value.docs){
        if(int.parse(element['cmtId']) !=999){
          listCmt.add(Comment(int.parse(element['userId']), int.parse(element['cmtId']), element['desc'], ''))
        }
      }
    });
    // get all user
    List<User> userList =[];
    await firestore.collection('users').get().then((value) => {
      for(var element in value.docs){
        userList.add(User(username:element['username'], password: element['password'],userId: int.parse(element['userId']), nameDisplay: element['name']))
      }
    });

    for(Comment cmt in listCmt){
      for(User user in userList){
        if(cmt.userId == user.userId){
          cmt.name = user.nameDisplay;
          break;
        }
      }
    }
    emit(DetailLoadCommentSuccess(listCmt: listCmt));
    return listCmt;
    //ref.read(getListCmtProvider.notifier).state = listCmt;
  }
}

class DetailAddCommentBloc extends Bloc<DetailEvent, DetailState>{
  DetailAddCommentBloc(): super(DetailCommentInitial()){
    on<AddComment>(_onAddComment);
  }
  Future<void> _onAddComment(AddComment event, Emitter emitter) async {
    emit(DetailCommentLoading());
    await addComment(event.pokeId, event.userId, event.comment);
  }


  Future<void> addComment(int pokeId,int userId,String desc)async{
    //get the last id
    int idLast =0;
    await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').get().then((value) => {
      for(var element in value.docs){
        if(int.parse(element['cmtId'])!= 999){
          idLast = int.parse(element['cmtId'])
        }
      }
    });
    if(idLast == 0){
      //error
      emit(DetailCommentError());
    }
    else{
      //do add
      idLast++;
      await firestore.collection('pokemons').doc(pokeId.toString()).collection('cmt').doc(idLast.toString()).set({
        'userId': userId.toString(),
        'cmtId':idLast.toString(),
        'desc': desc
      });
      //refresh lại comment
      emit(DetailCommentSuccess());
    }
  }
}

