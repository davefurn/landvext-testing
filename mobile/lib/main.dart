import 'dart:ui' as ui;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:landvest/firebase_options.dart';
import 'package:landvest/src/core/constants/imports.dart';
import 'package:landvest/src/core/riverpod/providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Determine the user's preferred locale from the device settings
  ui.Locale? userLocale = ui.PlatformDispatcher.instance.locale;

  // Create an AppLocalizations instance
  AppLocalizations appLocalizations = AppLocalizations(userLocale);
  // Load the localized strings by calling load
  await appLocalizations.load();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(
    ProviderScope(
      child: MyApp(
        userLocale: userLocale,
      ),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({
    required this.userLocale,
    super.key,
  });
  final Locale userLocale;

  @override
  Widget build(BuildContext context, WidgetRef ref) => ScreenUtilInit(
        designSize: const Size(375, 812),
        splitScreenMode: true,
        minTextAdapt: true,
        builder: (context, _) => KeyboardDismisser(
          gestures: const [
            GestureType.onTap,
            GestureType.onVerticalDragStart,
          ],
          child: Listener(
            onPointerDown: (event) {
              //When thereis not an event during log in session for 5 mins
              //it will log the user out
              ref.read(appSessionServiceProvider.notifier).resetTimerState();
            },
            child: MaterialApp.router(
              // Returns a locale which will be used by the app
              localeResolutionCallback: (locale, supportedLocales) =>
                  // Check if the current device locale is supported
                  supportedLocales.firstWhere(
                (supportedLocale) =>
                    supportedLocale.languageCode == locale?.languageCode,
                orElse: () => supportedLocales.first,
              ),
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: [
                // List your supported locales here
                userLocale,
                const ui.Locale('en', 'US'),
              ],
              locale: userLocale,
              routerConfig: AppRouter.router,
              debugShowCheckedModeBanner: false,
              title: 'LandVest',
              theme: LandTheme.lightTheme,
            ),
          ),
        ),
      );
}
