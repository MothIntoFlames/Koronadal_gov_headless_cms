import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wordpress_client/wordpress_client.dart';

import './models/posts.dart';
import './services/wpapi.dart';
import './widgets/card.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => const HomePage(),
      },
    ));

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Posts> allPosts = [];
  @override
  void initState() {
    super.initState();
    getPostDataWP();
  }

  Future<void> getPostDataWP() async {
    var request =
        ListPostRequest(page: 1, perPage: 20, status: ContentStatus.publish);

    final wpResponse = await WP_Api().myclient.posts.list(request);

// Dart 3 style
// switch (wpResponse) {
//     case WordpressSuccessResponse():
//       final data = wpResponse.data; // List<Post>
//       break;
//     case WordpressFailureResponse():
//       final error = wpResponse.error; // WordpressError
//       break;
// }

// or
// wordpress_client style
    final result = wpResponse.map(
      onSuccess: (response) {
        // print(response.message);
        // print(response.data.length.toString());
        // print(response.data[0].title?.parsedText.toString());
        return response.data;
      },
      onFailure: (response) {
        print(response.error.toString());
        return <Post>[];
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
      allPosts = wpPostsArr;
    });
  }

  List<Posts> wpPostsArr = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(170, 0, 29, 1),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.network(
            'assets/LOGO.png', // Replace with your image URL
            width: 40,
            height: 40,
            fit: BoxFit.cover,
          ),
        ),
        title: Text('City of Koronadal'),
        actions: [
          TextButton(
            onPressed: () {
              // Home
            },
            child: Text('Home', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // About
            },
            child: Text('About', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () {
              // Contact
            },
            child: Text('Contact Us', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 500,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    "assets/header_image.jpeg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "GovPh",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 25,
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.ac_unit_outlined),
                      )
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "CITY OF KORONADAL"
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 70,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(16.0),
              child: allPosts.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      shrinkWrap: true,
                      itemCount: allPosts.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (allPosts.isNotEmpty) {
                          return MyCard(post: allPosts[index]);
                        } else {
                          return LinearProgressIndicator();
                        }
                      },
                    )
                  : Center(child: CircularProgressIndicator()),
            ),
          ],
        ),
      ),
    );
  }
}
