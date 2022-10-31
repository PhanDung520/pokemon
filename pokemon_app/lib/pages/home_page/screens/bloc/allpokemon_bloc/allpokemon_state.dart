import 'package:equatable/equatable.dart';

import '../../../../../models/pokemon/pokemon.dart';

abstract class AllPokeState extends Equatable{
  const AllPokeState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AllInitial extends AllPokeState{}
class AllLoading extends AllPokeState{}
class AllSuccess extends AllPokeState{
  const AllSuccess({required this.listPoke});
  final List<Pokemon> listPoke;
  @override
  // TODO: implement props
  List<Object?> get props => [listPoke];
}
class AllError extends AllPokeState{}