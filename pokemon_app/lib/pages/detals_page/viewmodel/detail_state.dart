import 'package:freezed_annotation/freezed_annotation.dart';
part 'detail_state.freezed.dart';

enum DetailStatus{
  isFavourite,
  isNotFavourite,
  isLoading
}

class DetailState{
  DetailStatus status;

  DetailState(this.status);

  DetailState copyWith({required DetailStatus status}){
    return DetailState(status);
  }
}

@freezed
class CommentState with _$CommentState{
  const factory CommentState.loading() = _Loading;

  const factory CommentState.error() = _Error;

  const factory CommentState.done() = _Done;

}
