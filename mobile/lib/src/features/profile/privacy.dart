import 'package:landvext/src/core/constants/imports.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  String policy = '';

  Future<String> getFileData(String path) async => rootBundle.loadString(path);
  @override
  void initState() {
    super.initState();
    getFileData('assets/doc/privacy_policy.txt')
        .then((value) => setState(() => policy = value));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: CustomAppbar(
          translate: 'Privacy Policy',
          appBar: AppBar(),
          widget: const SizedBox.shrink(),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(
            20.r,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                policy,
                style: const TextStyle(
                  color: LandColors.textColorBlack,
                ),
              ),
              100.verticalSpace,
            ],
          ),
        ),
      );
}
