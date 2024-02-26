import 'package:landvest/src/core/constants/imports.dart';

class Matured extends StatelessWidget {
  const Matured({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView.separated(
          separatorBuilder: (context, index) => const Transact(
            amount: '23,100',
            balance: '31,300',
            credit: false,
            date: '11-05-2023',
            details: 'Weekly Savings Deposit...',
          ),
          itemCount: 9,
          itemBuilder: (context, index) => const Transact(
            amount: '31,000',
            balance: '2,000',
            credit: true,
            date: '11-05-2023',
            details: 'Weekly Savings Deposit...',
          ),
        ),
      );
}
