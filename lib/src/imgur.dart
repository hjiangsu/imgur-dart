import 'package:dio/dio.dart';

part 'authorization.dart';
part 'image.dart';

Dio dio = Dio();

const String _imgurURL = 'https://api.imgur.com';

/// Class containing optional parameters for the Imgur instance.
class ImgurOptions {
  final Dio? dio;
  final String? callbackURL;

  ImgurOptions({this.dio, this.callbackURL});
}

/// Imgur class used to instantiate/call functions related to the library.
/// Currently, it only supports anonymous access.
class Imgur {
  final String clientId;

  ImgurOptions? options;
  Authorization? authorization;

  Imgur({required this.clientId, this.options});

  /// Perfoms a request to Imgur's endpoints.
  /// You should **not** need to call this function directly. If you need to request for a resource, use the appropriate function.
  ///
  /// The parameter `method` takes one of `GET`, `POST`
  Future<dynamic> request({required String method, required String endpoint, Map<String, dynamic>? params}) async {
    if (authorization == null || !authorization!.isInitialized) await authorize();

    String url = "$_imgurURL$endpoint";

    Map<String, String> headers = {
      "Authorization": "Client-ID $clientId",
    };

    Response? response;

    try {
      if (method == "GET") {
        response = await dio.get(
          url,
          queryParameters: params,
          options: Options(headers: headers),
        );
      } else if (method == "POST") {
        response = await dio.post(
          url,
          data: params,
          options: Options(
            contentType: Headers.formUrlEncodedContentType,
            headers: headers,
          ),
        );
      }

      return response?.data;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Authorization?> authorize() async {
    authorization = await Authorization.create(imgur: this, callbackURL: options?.callbackURL);
    return authorization;
  }

  /// Performs functions related to an image.
  ///
  /// By default, it returns back an instance of [ImgurImage].
  /// With an instance of ImgurImage, you can view information for a given image
  ///
  /// ```dart
  /// imgur.image("aMpEhCp").information["url"];
  /// ```
  dynamic image({String? id, String? url}) async {
    ImgurImage imgurImage = await ImgurImage.create(imgur: this, id: id, url: url);
    return imgurImage;
  }
}
