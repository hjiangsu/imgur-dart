part of 'imgur.dart';

/// ImgurImage class used by Imgur library.
///
/// This class should not be called directly. Rather, this class should be returned when using the Imgur library.
class ImgurImage {
  late Imgur _imgur;

  // Image information
  Map<String, dynamic>? _information;

  ImgurImage._create({required Imgur imgur}) {
    _imgur = imgur;
  }

  /// Factory function to generate the ImgurImage instance
  static Future<ImgurImage> create({required Imgur imgur, String? id, String? url}) async {
    ImgurImage imageInstance = ImgurImage._create(imgur: imgur);

    // Do initialization that requires async
    await imageInstance._initialize(id: id, url: url);

    // Return the fully initialized object
    return imageInstance;
  }

  /// Initialization function for ImgurImage class
  _initialize({String? id, String? url}) async {
    String hash = id ?? '';

    if (url != null) {
      Uri parsedUrl = Uri.parse(url);
      List<String> pathSegments = parsedUrl.pathSegments;

      try {
        hash = pathSegments[0].split('.')[0];
      } catch (err) {
        throw Exception('Imgur: error parsing url');
      }
    }

    Map<String, dynamic> imageResponse = await _imgur.request(method: "GET", endpoint: "/3/image/$hash");
    _information = imageResponse["data"];
  }

  Map<String, dynamic>? get information => _information;
}
