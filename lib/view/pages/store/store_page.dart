import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spense_app/constants.dart';
import 'package:spense_app/model/store.dart';
import 'package:spense_app/view/pages/dashboard/dashboard_page.dart';
import 'package:spense_app/view/pages/expanded_coupons/expanded_coupons.dart';
import 'package:spense_app/view/pages/store/components/search_bar.dart';
import 'package:spense_app/view/pages/store/components/store_card.dart';

class StorePage extends StatefulWidget {
  const StorePage({Key? key}) : super(key: key);

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    // final quizQuestionsProvider = Provider.of<QuizQuestionsProvider>(context);
    // if(quizQuestionsProvider.isLoading == true) quizQuestionsProvider.requestOnlineQuestions();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: AppBarIconButton(
            icon: Icons.arrow_back,
            onPressed: () {
              Get.back();
            },
          ),
          centerTitle: false,
          titleSpacing: 0,
          title: const SearchBar(),
          actions: [
            AppBarIconButton(
              icon: Icons.close,
              onPressed: () {},
            ),
          ],
        ),
        backgroundColor: colorPageBackground,
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(10.0),
                  sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0),
                      delegate: SliverChildBuilderDelegate(
                        _buildStoreItem,
                        childCount: demoStores.length,
                      )),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _buildStoreItem(BuildContext context, int index) {
    //Store Store = categories[index];
    return StoreCard(
        store: demoStores[index],
        onTap: () {
          Navigator.of(context).push(PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) {
                return ExpandedCoupons(index, context, animation);
              },
              transitionDuration: const Duration(milliseconds: 100),
              reverseTransitionDuration: const Duration(milliseconds: 100)));
        });
  }
}
