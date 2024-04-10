import 'package:landvext/src/core/constants/imports.dart';
import 'package:landvext/src/core/functions/global_expired.dart';

class AppErrorWidget extends StatefulWidget {
  const AppErrorWidget({
    super.key,
    this.errorData,
    this.retry,
    this.errorCode,
  });
  final dynamic errorData;
  final Widget? retry;
  final int? errorCode;

  @override
  State<AppErrorWidget> createState() => _AppErrorWidgetState();
}

class _AppErrorWidgetState extends State<AppErrorWidget> {
  String error = 'Something went wrong';
  @override
  void initState() {
    super.initState();

    if (widget.errorData != null) {
      try {
        if (widget.errorData!.containsKey('messages')) {
          error = widget.errorData!['error']['message'];
        } else {
          error = widget.errorData!['message']['errors'];
        }
      } on Exception catch (_) {
        error = 'Something went wrong';
      }
    }
    if (widget.errorCode == 401) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        GlobalFunctions.expiredSession(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(error),
          if (widget.retry != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                20.verticalSpace,
                widget.retry!,
              ],
            ),
        ],
      );
}
