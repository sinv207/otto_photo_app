import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/repositories/photos_repository.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';

import '../../configs/enums.dart';

part 'photos_event.dart';
part 'photos_state.dart';

class PhotosBloc extends Bloc<PhotosEvent, PhotosState> {
  final PhotosRepository repository;

  PhotosBloc({required this.repository}) : super(const PhotosState.initial()) {
    on<PhotosFetched>(
      _photosFetched,
      transformer: droppable(),
    );

    on<PhotosRefreshed>(
      _photosRefreshed,
    );

    on<FavoriteUpdated>(
      _favoriteUpdated,
    );
  }

  FutureOr<void> _photosFetched(
      PhotosFetched event, Emitter<PhotosState> emit) async {
    print('_photosFetched');
    if (state.hasReachedMax) return;
    try {
      if (state.status == BlocStatus.initial) {
        emit(state.copyWith(
          status: BlocStatus.loading,
        ));
      }

      List<PhotoData> photos = await repository.fetchPhotos();

      emit(state.copyWith(
        status: BlocStatus.success,
        photos: List.of(state.photos)..addAll(photos),
        hasReachedMax: photos.isEmpty || state.photos.length > 100,
      ));
    } catch (e) {
      print(e);
    }
  }

  Future<FutureOr<void>> _photosRefreshed(
      PhotosRefreshed event, Emitter<PhotosState> emit) async {
    try {
      emit(state.copyWith(
        status: BlocStatus.loading,
      ));

      List<PhotoData> photos = await repository.fetchPhotos();

      emit(state.copyWith(
        status: BlocStatus.success,
        photos: photos,
        hasReachedMax: false,
      ));
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> _favoriteUpdated(
      FavoriteUpdated event, Emitter<PhotosState> emit) {
    final updatedFavorites = Map.of(state.favorites);
    if (!updatedFavorites.containsKey(event.photoId)) {
      updatedFavorites.addAll(<String, bool>{
        event.photoId: event.isFavorite,
      });
    } else {
      updatedFavorites.update(event.photoId, (value) => event.isFavorite);
    }

    // print(updatedFavorites);

    emit(state.copyWith(
      status: BlocStatus.success,
      favorites: updatedFavorites,
    ));
  }
}
