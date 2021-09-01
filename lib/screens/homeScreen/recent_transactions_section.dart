import 'package:flutter/material.dart';
import 'package:flutter_banking_pay_responsive/components/transaction_widget.dart';
import 'package:flutter_banking_pay_responsive/models/transaction.dart';

import '../../constant_text_styles.dart';
import '../../constants.dart';

class RecentTransactionsSection extends StatelessWidget {
  const RecentTransactionsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Transactions',
          style: AppTextStyle.kBodyText,
        ),
        const SizedBox(height: kHalfPadding),
        ListView.separated(
          itemCount: myTransactions.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          separatorBuilder: (context, index) {
            return const SizedBox(height: kHalfPadding);
          },
          itemBuilder: (context, index) {
            return TransactionCard(transaction: myTransactions[index]);
          },
        ),
      ],
    );
  }
}
