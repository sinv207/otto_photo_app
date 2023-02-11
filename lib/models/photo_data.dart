// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class PhotoData extends Equatable {
  final String id;
  final String photoUrl;
  const PhotoData({
    required this.id,
    required this.photoUrl,
  });

  PhotoData copyWith({
    String? id,
    String? photoUrl,
  }) {
    return PhotoData(
      id: id ?? this.id,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, photoUrl];
}
