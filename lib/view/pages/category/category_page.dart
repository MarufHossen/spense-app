import 'package:flutter/material.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/model/discover.dart';
import 'package:spense_app/view/pages/coupons_tab/components/discover_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
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
          title: const Text("Discover"),
          elevation: 0,
          backgroundColor: colorPrimary,
        ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0),
                      delegate: SliverChildBuilderDelegate(_buildCategoryItem,
                          childCount: discoverList.length)),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildCategoryItem(BuildContext context, int index) {
    // int level = index + 1;
    //Category category = categories[index];
    return DiscoverCard(discoverList[index]);
  }

  _categoryPressed(BuildContext context) {
    // category.id == 6
    //     ? Navigator.of(context)
    //         .push(MaterialPageRoute(builder: (_) => LeaderBoard()))
    //     : Navigator.of(context).push(MaterialPageRoute(
    //         builder: (_) => QuizPage(
    //               category: category,
    //             )));
  }
}
