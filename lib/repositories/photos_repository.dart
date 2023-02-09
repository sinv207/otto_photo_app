import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/services/api.dart';

import '../utils/app_exception.dart';

class PhotosRepository {
  final ApiService apiClient;

  PhotosRepository({required this.apiClient});

  Future<List<PhotoData>> fetchPhotos() async {
    try {
      final ApiResponse response =
          await apiClient.get('/api/breeds/image/random/18');
      if (response.status == ApiStatus.success) {
        return (response.data['message'] as List)
            .map((e) => PhotoData(id: '', photoUrl: e))
            .toList();
      } else if (response.status == ApiStatus.error) {
        // Handle for API error
        throw ApiException(response.error.errorCode);
      } else {
        throw AppException('Mistake from API');
      }
    } catch (e) {
      // Handle exception error.
      print(e);
      rethrow;
    }
  }
}
