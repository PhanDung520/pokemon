import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/allpokemon_bloc/allpokemon_event.dart';
import 'package:pokemon_app/pages/home_page/screens/bloc/allpokemon_bloc/allpokemon_state.dart';

import '../../../../../models/pokemon/pokemon.dart';
import '../../../../../utils/firebase_reference.dart';

class AllPokeBloc extends Bloc<AllPokeEvent, AllPokeState>{
  AllPokeBloc(): super(AllInitial()){
    on<LoadAllPokemon>(_onLoadAllPokemon);
  }

  Future<void> _onLoadAllPokemon(AllPokeEvent event, Emitter emitter) async {
    emit(AllLoading());
    final listPoke = await pokeGet();
    if(listPoke.length ==0){
      return emitter(AllError());
    }else{
      return emitter(AllSuccess(listPoke: listPoke));
    }
  }

  Future<List<Pokemon>> pokeGet() async{
    List<Pokemon> listPoke =[];
    await firestore.collection('pokemons').get().then((value) => {
      for(var element in value.docs){
        listPoke.add(Pokemon(class1 : element['class'],attack: element['attack'],height : element['height'],hp : element['hp'],pokeId : element['id'],image :element['image'],name :element['name'],speed :element['speed'], weight: element['weight'],like: int.parse(element['like'].toString())))
      }
    });
    return listPoke;
  }
}