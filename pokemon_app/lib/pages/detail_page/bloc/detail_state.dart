import 'package:equatable/equatable.dart';

import '../../../models/comment.dart';

abstract class DetailState extends Equatable{
  const DetailState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class DetailFavoriteInitial extends DetailState{}
class DetailFavoriteLoading extends DetailState{}
class DetailFavoriteIsTrue extends DetailState{
  const DetailFavoriteIsTrue({required this.newLike});
  final int newLike;
}
class DetailFavoriteIsFalse extends DetailState{
  const DetailFavoriteIsFalse({required this.newLike});
  final int newLike;
}
class DetailFavoriteError extends DetailState{}

class DetailCommentInitial extends DetailState{}
class DetailCommentLoading extends DetailState{}
class DetailCommentSuccess extends DetailState{}
class DetailCommentError extends DetailState{}

class DetailLoadCommentInitial extends DetailState{}
class DetailLoadCommentLoading extends DetailState{}
class DetailLoadCommentSuccess extends DetailState{
  const DetailLoadCommentSuccess({required this.listCmt});
  final List<Comment> listCmt;
}
class DetailLoadCommentError extends DetailState{}
