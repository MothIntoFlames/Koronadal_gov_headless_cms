import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wordpress_client/wordpress_client.dart';

void main() {
  runApp(MyApp());
}

//class MyApp extends StatelessWidget {
// @override
// Widget build(BuildContext context) {
//   return MaterialApp(
//   title: 'Flutter WordPress App',
//    theme: ThemeData(
//      primarySwatch: Colors.blue,
///    ),
//     home: HomePage(),
//    );
//  }
//}

//class Post {
// final String title;
// final String content;

// Post({required this.title, required this.content});

// factory Post.fromJson(Map<String, dynamic> json) {
//   return Post(
//     title: json['title']['rendered'],
//  content: json['content']['rendered'],
//  );
// }
//}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String wordpressUrl = 'https://koronadal.gov.ph/wp-json/wp/v2//posts';
  late List<Post> myPosts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {

    var request = ListPostRequest(page: 1, perPage: 20, status: ContentStatus.publish);

    final wpResponse - await WP_Api().myclient.posts.list(request);



    final result = wpResponse.map(
      onSuccess: (response) {

        return response.data;
      },
      onFailure:(response) {
        print(response.error.toString());
        return <Posts> [];
      },
    );

    List<Posts> wpPostsArr = [];
    result.forEach((element) {
      Posts dposts = Posts(
        id: element.id.toString(),
        title: element.title?.parsedText.toString() ?? "",
        content: element.content?.parsedText.toString() ?? "",
      );
      wpPostsArr.add(dposts);

    });

    setState(() {
      allposts = wpPostsArr;
    });
    //final response = await http.get(Uri.parse(wordpressUrl));

    //if (response.statusCode == 200) {
    //  List<dynamic> data = json.decode(response.body);
     // setState(() {
     //   posts = data.map((post) => Post.fromJson(post)).toList();
    //  });
   // } else {
   //   throw Exception('Failed to load posts');
   // }
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter WordPress App'),
      ),
      body: posts != null
          ? ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(posts[index].title),
                  subtitle: Text(posts[index].content),
                  // Customize the display of other post information as needed
                );
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
