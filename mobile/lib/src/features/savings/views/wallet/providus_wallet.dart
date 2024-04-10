import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/create_wallet_providus.dart';
import 'package:landvext/src/features/savings/views/wallet/model/model.dart';

class ProvidusWallet extends StatefulWidget {
  const ProvidusWallet({super.key});

  @override
  State<ProvidusWallet> createState() => _ProvidusWalletState();
}

class _ProvidusWalletState extends State<ProvidusWallet> {
  late AccountProvidus accountProvidus;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<void> _asyncMethod() async {
    await PostRequestCreateWalletProvidus.createWalletProvidus(
      context,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Bank Transfer',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: _buildLoadingIndicator(),
      );

  Widget _buildLoadingIndicator() => const Center(
        child: CircularProgressIndicator(),
      );
}
