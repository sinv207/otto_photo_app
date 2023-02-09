// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'photos_bloc.dart';

class PhotosState extends Equatable {
  const PhotosState._({
    required this.status,
    required this.photos,
  });

  final BlocStatus status;
  final List<PhotoData> photos;

  const PhotosState.initial()
      : this._(
          photos: const <PhotoData>[],
          status: BlocStatus.initial,
        );

  PhotosState copyWith({
    BlocStatus? status,
    List<PhotoData>? photos,
  }) {
    return PhotosState._(
      status: status ?? this.status,
      photos: photos ?? this.photos,
    );
  }

  @override
  List<Object> get props => [status, photos];
}
