import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'screen/main_shell.dart';
import 'screen/splash_screen.dart';
import 'state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = await AppState.create();
  runApp(ChangeNotifierProvider<AppState>.value(value: state, child: const FoodPlanApp()));
}

class FoodPlanApp extends StatelessWidget {
  const FoodPlanApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedGreen = Color(0xFF2E7D32); // hijau utama sesuai identitas FoodPlan

    return MaterialApp(
      title: 'FoodPlan',
      debugShowCheckedModeBanner: false,
      locale: const Locale('id'),
      supportedLocales: const [Locale('id'), Locale('en')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedGreen),
        scaffoldBackgroundColor: const Color(0xFFF7F7F2),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          foregroundColor: Colors.black87,
        ),
      ),
      // Halaman awal ditentukan oleh status login: sesudah masuk/daftar
      // langsung ke MainShell, sesudah keluar kembali ke Splash.
      home: Consumer<AppState>(
        builder: (context, s, _) =>
            s.isLoggedIn ? MainShell(key: ValueKey(s.username)) : const SplashScreen(),
      ),
    );
  }
}
