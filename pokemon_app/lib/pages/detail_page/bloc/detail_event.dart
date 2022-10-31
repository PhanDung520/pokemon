import 'package:equatable/equatable.dart';
import 'package:pokemon_app/models/pokemon/pokemon.dart';

abstract class DetailEvent extends Equatable{
  const DetailEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class CheckIsFavorite extends DetailEvent{
 const CheckIsFavorite({required this.pokemon, required this.userId, required this.isConnect});
 final Pokemon pokemon;
 final int userId;
 final bool isConnect;
}
class AddToFavorite extends DetailEvent{
  const AddToFavorite({required this.pokemon, required this.userId});
  final Pokemon pokemon;
  final int userId;
  @override
  // TODO: implement props
  List<Object?> get props => [pokemon, userId];
}
class RemoveFromFavorite extends DetailEvent{
  const RemoveFromFavorite({required this.pokemon, required this.userId});
  final Pokemon pokemon;
  final int userId;
  @override
  // TODO: implement props
  List<Object?> get props => [pokemon, userId];

}
class AddComment extends DetailEvent{
  const AddComment({required this.userId, required this.pokeId, required this.comment});
  final String comment;
  final int pokeId;
  final int userId;
}
class LoadComment extends DetailEvent{
  const LoadComment({required this.pokeId, required this.isConnect});
  final int pokeId;
  final bool isConnect;
}
class LoadLike extends DetailEvent{
  const LoadLike({required this.pokemon});
  final Pokemon pokemon;
}
