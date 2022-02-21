import 'package:flutter/material.dart';
import 'package:spense_app/view/pages/loyalty_card/loyalty_card.dart';

class TransactionWidget extends StatelessWidget {
  const TransactionWidget(this.transaction);

  final Transaction transaction;

  @override
  Widget build(BuildContext context) {
    final headerStyle = Theme.of(context).textTheme.bodyText1!.copyWith(
          color: Colors.black54,
        );
    final captionStyle = Theme.of(context).textTheme.bodyText2!.copyWith(
          color: Colors.grey.withOpacity(.6),
        );

    return SizedBox(
      height: 54,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 54,
            height: 54,
            margin: EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.account_balance_wallet,
                color: Colors.black.withOpacity(.4)),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(transaction.title, style: headerStyle),
              SizedBox(height: 4),
              Text(transaction.description, style: captionStyle),
            ],
          ),
          Spacer(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('- ${transaction.amount} USD', style: headerStyle),
              SizedBox(height: 4),
              Text(transaction.getTime(), style: captionStyle),
            ],
          ),
        ],
      ),
    );
  }
}
