import 'package:flutter/cupertino.dart';
import 'package:koronadalgov_wp_flutter_headless_cms/models/wpapi.dart';
import 'package:wordpress_client/wordpress_client.dart';

class _ViewHomePage {
  List<MyPost> allPost = [];

  @override
  void initState() {
    super.initState();
    getWPData();
  }

  Future<void> getWPdata() async {
    final response = await wPnetwork()
        .client
        .posts
        .list(ListPostRequest(status: ContentStatus.publish));
        response.map<void>(
          onSuccess: (reponse) {
            print("test");
            
            List<MyPost> dposts = [];
            response.data.forEach(ddata) {
              print (ddata.featuredImageUrl?.);
              
            }

          }
        )
  }

  Future<void> getPostDataWp() async {
    var request = ListPostRequest(
      page: 1,
      perPage: 20,
    );

    final wpApi = WP_Api();
    final wpresponse = await wpApi.myclient.posts.list(request);
    print("here 2");
  }
}
