import 'package:equatable/equatable.dart';

import '../../../../../models/pokemon/pokemon.dart';

abstract class FavoritesState extends Equatable{
  const FavoritesState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState{}
class FavoritesLoading extends FavoritesState{}
class FavoritesSuccess extends FavoritesState{
  const FavoritesSuccess({required this.listPoke});
  final List<Pokemon> listPoke;
  @override
  // TODO: implement props
  List<Object?> get props => listPoke;
}
class FavoritesError extends FavoritesState{}