import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  final List<Color> tileColors = [
    Colors.green,
    Colors.blue,
    Colors.purple,
    Colors.pink,
    Colors.indigo,
    Colors.lightBlue,
    Colors.amber,
    Colors.deepOrange,
    Colors.red,
    Colors.brown
  ];

  @override
  Widget build(BuildContext context) {
    // final quizQuestionsProvider = Provider.of<QuizQuestionsProvider>(context);
    // if(quizQuestionsProvider.isLoading == true) quizQuestionsProvider.requestOnlineQuestions();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Store"),
          elevation: 0,
        ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0),
                      delegate: SliverChildBuilderDelegate(
                        _buildStoreItem,
                        childCount: 20,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildStoreItem(BuildContext context, int index) {
    //Store Store = categories[index];
    return Container(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: "http://via.placeholder.com/350x150",
            placeholder: (context, url) => const CircularProgressIndicator(),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ],
      ),
    );
  }

  _storeLevelPressed(BuildContext context) {
    // Store.id == 6
    //     ? Navigator.of(context)
    //         .push(MaterialPageRoute(builder: (_) => LeaderBoard()))
    //     : Navigator.of(context).push(MaterialPageRoute(
    //         builder: (_) => QuizPage(
    //               Store: Store,
    //             )));
  }
}
