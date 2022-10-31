import 'package:equatable/equatable.dart';

abstract class AllPokeEvent extends Equatable{
  const AllPokeEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadAllPokemon extends AllPokeEvent{
  const LoadAllPokemon({required this.isConnect});
  final bool isConnect;
}