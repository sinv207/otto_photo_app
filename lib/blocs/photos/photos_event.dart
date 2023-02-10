part of 'photos_bloc.dart';

abstract class PhotosEvent extends Equatable {
  const PhotosEvent();

  @override
  List<Object> get props => [];
}

class PhotosFetched extends PhotosEvent {
  @override
  List<Object> get props => [];
}

class FavoriteUpdated extends PhotosEvent {
  final String photoId;
  final bool isFavorite;

  const FavoriteUpdated(
    this.photoId,
    this.isFavorite,
  );

  @override
  List<Object> get props => [photoId, isFavorite];
}
