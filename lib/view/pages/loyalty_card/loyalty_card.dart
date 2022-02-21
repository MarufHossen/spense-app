import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spense_app/view/pages/loyalty_card/widgets/transaction_widget.dart';

class LoyaltyCard extends StatefulWidget {
  const LoyaltyCard({Key? key}) : super(key: key);

  @override
  _LoyaltyCardState createState() => _LoyaltyCardState();
}

class _LoyaltyCardState extends State<LoyaltyCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final PageController _pageController = PageController();
  late Animation<double> _rotation;
  final cards = 4;

  bool _isCardDetailsOpened() => _controller.isCompleted;

  void _openCloseCard() {
    if (_controller.isCompleted) {
      _controller.reverse();
    } else if (_controller.isDismissed) {
      _controller.forward();
    }
  }

  int _getCardIndex() {
    return _pageController.hasClients ? _pageController.page!.round() : 0;
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIOverlays([]);

    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 320));
    _rotation = Tween(begin: 0.0, end: 90.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.linear));
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const double contentPadding = 32;

    return Stack(
      children: [
        Positioned(
          top: screenSize.height * .17,
          left: screenSize.width * .415,
          right: 0,
          height: 200,
          child: AnimatedBuilder(
            animation: _pageController,
            builder: (context, child) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: _controller.value > 0.5 ? 0 : 1,
                    child: SizedBox(
                      width: 100,
                      child: Row(
                        children: List.generate(cards, (i) {
                          final selected = _getCardIndex() == i;
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: selected ? Colors.black : Colors.black54,
                              shape: BoxShape.circle,
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Positioned(
          top: screenSize.height * .02,
          left: 0,
          right: 0,
          height: 200,
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return PageView.builder(
                itemCount: cards,
                controller: _pageController,
                clipBehavior: Clip.none,
                physics: _isCardDetailsOpened()
                    ? NeverScrollableScrollPhysics()
                    : BouncingScrollPhysics(),
                itemBuilder: (context, i) {
                  if (_getCardIndex() != i) return _Card();
                  return Transform.rotate(
                    angle: _rotation.value * math.pi / 180,
                    alignment: Alignment.lerp(
                      Alignment.center,
                      Alignment(-.7, -.6),
                      _controller.value,
                    ),
                    child: _Card(),
                  );
                },
              );
            },
          ),
        ),
        AnimatedBuilder(
          animation: _controller,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Transactions',
                    style: Theme.of(context)
                        .textTheme
                        .headline6!
                        .copyWith(color: Colors.black54),
                  ),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.sort_sharp, color: Colors.black54),
                    onPressed: () {},
                  )
                ],
              ),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: todayTransactions.length,
                  physics: const BouncingScrollPhysics(),
                  separatorBuilder: (_, i) {
                    return Divider(
                      color: Colors.black.withOpacity(.3),
                      indent: 34 * 2.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: TransactionWidget(todayTransactions[index]),
                    );
                  },
                ),
              ),
            ],
          ),
          builder: (context, child) {
            final topPadding = screenSize.height * .30;
            return Positioned(
              top: topPadding + (200 * _controller.value),
              bottom: 0,
              left: contentPadding,
              right: contentPadding,
              child: Opacity(
                opacity: 1 - _controller.value,
                child: child,
              ),
            );
          },
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.black54,
        );

    return Container(
      width: MediaQuery.of(context).size.width * .85,
      height: 190,
      padding: const EdgeInsets.all(32),
      margin: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
          color: Colors.amber,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 16,
            )
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Loyalty Card'.toUpperCase(), style: textStyle),
              const SizedBox(height: 6),
              Text('Platinum'.toUpperCase(), style: textStyle),
            ],
          ),
          const Spacer(),
          Text(
            '•••• •••• •••• 5040',
            style: textStyle.copyWith(
              wordSpacing: 10,
              letterSpacing: 6,
            ),
          )
        ],
      ),
    );
  }
}

class Transaction {
  final String title;
  final String description;
  final double amount;
  final DateTime date;
  final String iconUrl;

  Transaction({
    required this.title,
    required this.description,
    required this.amount,
    required this.date,
    required this.iconUrl,
  });

  String getTime() => '${date.hour.toString().padLeft(2, '0')}:'
      '${date.minute.toString().padLeft(2, '0')} '
      '${date.hour >= 0 && date.hour <= 12 ? 'AM' : 'PM'}';
}

List<Transaction> todayTransactions = [
  Transaction(
      title: 'Mc Donalds',
      description: 'Food & Beverage',
      amount: 500.00,
      date: DateTime.now(),
      iconUrl:
          'https://upload.wikimedia.org/wikipedia/commons/a/ab/Apple-logo.png'),
  Transaction(
      title: 'Burger King',
      description: 'Food & Beverage',
      amount: 450.00,
      date: DateTime.now(),
      iconUrl:
          'https://www.designbust.com/download/1016/png/google_logo_png_transparent512.png'),
  Transaction(
    title: 'Nike',
    description: 'Clothes',
    amount: 200.00,
    iconUrl: '',
    date: DateTime(2021, 06, 30),
  ),
  Transaction(
    title: 'New Yorker',
    description: 'Clothes',
    amount: 150.00,
    iconUrl: '',
    date: DateTime(2021, 06, 30),
  ),
  Transaction(
    title: 'Zara',
    description: '',
    amount: 50.00,
    iconUrl: 'Clothes',
    date: DateTime(2021, 06, 30),
  ),
  Transaction(
    title: 'iDeal',
    description: 'Electronics',
    amount: 900.00,
    iconUrl: '',
    date: DateTime(2021, 06, 30),
  ),
];
