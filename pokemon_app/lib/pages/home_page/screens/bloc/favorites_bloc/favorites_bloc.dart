import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_event.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/favorites_bloc/favorites_state.dart';

import '../../../../../models/pokemon/pokemon.dart';
import '../../../../../offline/fetch_data_offline.dart';
import '../../../../../utils/firebase_reference.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState>{
  FavoritesBloc(): super(FavoritesInitial()){
    on<FavoritesLoad>(_onFavoritesLoad);
  }

  Future<void> _onFavoritesLoad(FavoritesLoad event, Emitter emitter) async {
   emit(FavoritesLoading());
   final listFav = await getListFavorite(event.userId, event.isConnect);
   return emitter(FavoritesSuccess(listPoke: listFav));
  }
  Future<List<Pokemon>> getListFavorite(int userId, bool isConnect) async{
    if(isConnect){
      List<int> listPokeId =[];
      List<Pokemon> listFa =[];
      //getDociD
      await firestore.collection('users').doc(userId.toString()).collection('favourite').get().then((value) => {
        value.docs.forEach((element) {
          int i = int.parse(element.id);
          if(i <100){
            listPokeId.add(i);
          }
        }
        )
      });
      List<Future> listF = [];
      //tim kiem voi poke id
      for (var element in listPokeId) {
        var a = firestore.collection('pokemons').doc(element.toString()).get().then((documentSnapshot){
          listFa.add(Pokemon(class1: documentSnapshot['class'], attack: documentSnapshot['attack'], height: documentSnapshot['height'], hp: documentSnapshot['hp'],pokeId: documentSnapshot['id'], image: documentSnapshot['image'], name: documentSnapshot['name'], speed: documentSnapshot['speed'],weight :documentSnapshot['weight'], like: int.parse(documentSnapshot['like'].toString())));
        });
        listF.add(a);
      }
      await Future.wait(listF);
      await fetchFavoriteOffline(userId, listFa, isConnect);
      return listFa;
    }else{
      return await fetchFavoriteOffline(userId, [], isConnect);
    }
  }
}