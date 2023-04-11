import 'package:dotenv/dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:imgur/imgur.dart';

DotEnv env = DotEnv(includePlatformEnvironment: true)..load();

void main() {
  group('image', () {
    test('can obtain image information from an id', () async {
      final Imgur imgur = Imgur(clientId: env['CLIENT_ID']!);

      ImgurImage image = await imgur.image(id: 'FiTU7no');
      print(image.information!["link"]);
    });

    test('can obtain image information from an url', () async {
      final Imgur imgur = Imgur(clientId: env['CLIENT_ID']!);

      ImgurImage image = await imgur.image(url: 'https://i.imgur.com/FiTU7no.jpeg');
      print(image.information!["link"]);
    });
  });
}
