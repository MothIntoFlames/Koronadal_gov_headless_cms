import 'package:wordpress_client/wordpress_client.dart';

class WPnetwork {
  final myclient = WordpressClient(
      baseUrl: Uri.parse("https://koronadal.gov.ph/wp-json/wp/v2/"),
      bootstrapper: (bootstrapper) => bootstrapper.withDebugMode(true).build());

  WP_Api() {
    myclient.initialize();
  }
}
