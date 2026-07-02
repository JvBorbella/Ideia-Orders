import 'dart:io';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:projeto/back/save_list.dart';
import 'package:projeto/front/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Define font family constant for maintainability
const String kFontFamilyPoppins = 'Poppins';

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;
  const MyApp({super.key, this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Verifique se há uma atualização quando a tela inicial é carregada
    checkForUpdate();
  }

  Future<void> checkForUpdate() async {
    try {
      // Verifica a disponibilidade da atualização.
      // O método `checkForUpdate()` é a forma mais simples de começar.
      AppUpdateInfo appUpdateInfo = await InAppUpdate.checkForUpdate();

      if (appUpdateInfo.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        if (appUpdateInfo.immediateUpdateAllowed) {
          // Inicia o fluxo de atualização imediata (bloqueante).
          // O sistema gerencia o download, instalação e reinicialização.
          await InAppUpdate.performImmediateUpdate();
        }
      }
    } catch (e) {
      // Se algo der errado, a chamada vai lançar uma exceção.
      debugPrint('Falha ao verificar a atualização: $e');
    }
  }

  // Future<bool> checkConnection() async {
  //   final hasInternet = await hasInternetConnection();
  //   if (!hasInternet) {
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              //TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            },
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontFamily: kFontFamilyPoppins,
                fontSize: 16),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, // cor base do tema claro
            surface: const Color(0xfff8f9fe),
            primary: const Color(0xff00568e),
            secondary: const Color(0xff42b9f0),
            onSecondary: const Color(0xff00568e),
            tertiary: const Color(0xffA6A6A6),
            brightness: Brightness.light,
          ),
        ),
        dark: ThemeData(
          pageTransitionsTheme: const PageTransitionsTheme(
            builders: {
              TargetPlatform.android: ZoomPageTransitionsBuilder(),
              //TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            },
          ),
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
                fontFamily: kFontFamilyPoppins,
                fontSize: 16),
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(
                0, 255, 255, 255), // cor base do tema escuro
            surface: const Color(0xff001515),
            primary: const Color.fromARGB(255, 27, 110, 148),
            secondary: const Color.fromARGB(255, 27, 110, 148),
            onSecondary: const Color(0xff42b9f0),
            tertiary: const Color.fromARGB(255, 109, 108, 108),
            brightness: Brightness.dark,
          ),
        ),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: "IdeiaOrders",
              theme: theme,
              darkTheme: darkTheme,
              home: const SplashPage(),
            ));
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> clearCache() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  await limparLista('orders');
  await sharedPreferences.setBool('editarPrevenda', false);
  await sharedPreferences.setBool('aplicarDesconto', false);
  await sharedPreferences.setBool('cadastrarCliente', false);
  await sharedPreferences.setBool('editarCliente', false);
  await sharedPreferences.setBool('criarPedido', false);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  // HttpOverrides.global = MyHttpOverrides();

  await Hive.initFlutter();
  // Hive.registerAdapter(OrderModelAdapter());
  await Hive.openBox('app_data'); // Abrimos uma box genérica para configurações e listas

  // await Hive.openBox<OrderModel>('orders');
  runApp(MyApp(savedThemeMode: savedThemeMode));
}
