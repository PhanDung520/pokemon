import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable{
  const FavoritesEvent();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FavoritesLoad extends FavoritesEvent{
  const FavoritesLoad({required this.userId, required this.isConnect});
  final int userId;
  final bool isConnect;
  @override
  // TODO: implement props
  List<Object?> get props => [userId];
}