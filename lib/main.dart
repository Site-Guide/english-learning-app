import 'package:english/utils/labels.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'color_schemes.g.dart';
// import 'firebase_options.dart';
import 'custom_color.g.dart';
import 'firebase_options.dart';
import 'ui/router.dart';
import 'ui/splash/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light(useMaterial3: true).textTheme;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: Labels.appName,
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(useMaterial3: true).copyWith(
        extensions: [darkCustomColors],
        // cardColor: Colors.black,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        colorScheme: darkColorScheme,
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: const CardTheme(clipBehavior: Clip.antiAlias),
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
        ),
        textTheme: base
            .copyWith(
              displayMedium: const TextStyle(fontWeight: FontWeight.bold),
              headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
              titleLarge: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
            .apply(
              displayColor: darkColorScheme.onSurface,
              bodyColor: darkColorScheme.onSurface,
            )
            .copyWith(
              bodySmall:
                  TextStyle(color: darkColorScheme.onSurface.withOpacity(0.75)),
            ),
      ),
      theme: ThemeData(
        scaffoldBackgroundColor: lightColorScheme.surface,
        extensions: [lightCustomColors],
        appBarTheme:  const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            statusBarColor: Colors.transparent,
          ),
        ),
        primarySwatch: Colors.orange,
        colorScheme: lightColorScheme,
        useMaterial3: true,
        dividerTheme: DividerThemeData(
          color: lightColorScheme.surfaceVariant
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
        cardTheme: const CardTheme(clipBehavior: Clip.antiAlias),
        buttonTheme: const ButtonThemeData(
          shape: StadiumBorder(),
        ),
        textTheme: base
            .copyWith(
              displayMedium: const TextStyle(fontWeight: FontWeight.bold),
              headlineLarge: const TextStyle(fontWeight: FontWeight.bold),
              titleLarge: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
              titleMedium: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            )
            .apply(
              displayColor: lightColorScheme.onSurface,
              bodyColor: lightColorScheme.onSurface,
            )
            .copyWith(
              bodySmall: TextStyle(
                color: lightColorScheme.onSurface.withOpacity(0.75),
              ),
            ),
      ),
      onGenerateRoute: AppRouter.onNavigate,
      initialRoute: SplashPage.route,
    );
  }
}


/// AKIAQKJT5KSD6L6QUXXR
/// BC/F0O6olPglJ5x3RH4eWv4rdE2P2nb4z1sQZoPfgome
/// email-smtp.ap-northeast-1.amazonaws.com





// dWI26PtrSek5IXIcDtzxio2I