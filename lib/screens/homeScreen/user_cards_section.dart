import 'package:flutter/material.dart';
import 'package:flutter_banking_pay_responsive/components/card_widget.dart';
import 'package:flutter_banking_pay_responsive/models/card.dart';

import '../../constants.dart';

class UserCardsSection extends StatelessWidget {
  const UserCardsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200 * 1.07,
      child: ListView.separated(
        physics: const ClampingScrollPhysics(),
        separatorBuilder: (context, index) {
          return const SizedBox(width: kHalfPadding);
        },
        itemCount: myCards.length + 1,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          // checking if the index item is the last item of the list or not
          if (index == myCards.length) {
            return CardOutlineWidget(width: 320, onPress: () {});
          }
          return CardWidget(
            card: myCards[index],
            width: 320,
            onPress: () {},
          );
        },
        padding: const EdgeInsets.only(right: kHalfPadding),
      ),
    );
  }
}
