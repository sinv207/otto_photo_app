// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'photos_bloc.dart';

class PhotosState extends Equatable {
  const PhotosState._({
    required this.status,
    required this.photos,
    required this.hasReachedMax,
    required this.favorites,
    this.error,
  });

  final BlocStatus status;
  final bool hasReachedMax;
  final List<PhotoData> photos;
  final Map<String, bool> favorites;
  final AppException? error;

  const PhotosState.initial()
      : this._(
          photos: const <PhotoData>[],
          status: BlocStatus.initial,
          hasReachedMax: false,
          favorites: const <String, bool>{},
        );

  PhotosState copyWith({
    BlocStatus? status,
    List<PhotoData>? photos,
    bool? hasReachedMax,
    Map<String, bool>? favorites,
    AppException? error,
  }) {
    return PhotosState._(
      status: status ?? this.status,
      photos: photos ?? this.photos,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      favorites: favorites ?? this.favorites,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [status, photos, favorites, hasReachedMax];
}
