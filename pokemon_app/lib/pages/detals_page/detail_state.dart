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