import 'package:otto_photo_app/models/photo_data.dart';
import 'package:otto_photo_app/services/api.dart';

import '../configs/configs.dart';
import '../utils/app_exception.dart';

class PhotosRepository {
  final ApiService apiClient;

  PhotosRepository({required this.apiClient});

  final String _photosKey = 'message';

  Future<List<PhotoData>> fetchPhotos() async {
    try {
      // Fetch photos from public api
      final ApiResponse response = await apiClient.get(photoApiUrl);

      // Check reponse status before processing data
      if (response.status == ApiStatus.success) {
        List urlList = (response.data[_photosKey] as List);

        // Convert response data to model and return as List of photo data
        return List.generate(urlList.length, (index) {
          return PhotoData(
            id: _getPhotoId(index, urlList[index]),
            photoUrl: urlList[index],
          );
        }).toList();
      } else if (response.status == ApiStatus.error) {
        // Handle for API error
        throw ApiException(response.error.errorCode);
      } else {
        throw AppException("An unexpected error occurred");
      }
    } catch (e) {
      // Handle exception error.
      rethrow;
    }
  }

  /// Demo: get random photo id
  String _getPhotoId(int index, String url) =>
      '${index}_${url.split("/").last}';
}
