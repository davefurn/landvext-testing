import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/services/postRequests/requests/create_providus.dart';
import 'package:landvext/src/features/savings/views/wallet/model/model.dart';

class Providus extends StatefulWidget {
  const Providus({required this.id, super.key});
  final String id;

  @override
  State<Providus> createState() => _ProvidusState();
}

class _ProvidusState extends State<Providus> {
  late AccountProvidus accountProvidus;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _asyncMethod();
    });
  }

  Future<void> _asyncMethod() async {
    await PostRequestCreateProvidus.createProvidus(
      context,
      id: int.tryParse(widget.id),
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
