import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:projeto/back/checK_internet.dart';
import 'package:projeto/front/pages/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        // Se houver uma atualização disponível, inicie o fluxo de atualização flexível.
        final result = await InAppUpdate.startFlexibleUpdate();

        // Após o download da atualização, mostre uma notificação para o usuário instalar.
        if (result == AppUpdateResult.success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Atualização pronta para instalar!'),
                action: SnackBarAction(
                  label: 'Instalar',
                  onPressed: () {
                    InAppUpdate.completeFlexibleUpdate();
                  },
                ),
              ),
            );
          }
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "IdeiaOrders",
      theme: ThemeData(
        // scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodySmall: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: MediaQuery.of(context).size.height * 0.012,
          ),
          bodyMedium: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.018),
          bodyLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: MediaQuery.of(context).size.width * 0.025,
          ),
          labelSmall: TextStyle(
              fontFamily: 'Poppins-Regular',
              fontSize: MediaQuery.of(context).size.height * 0.012),
          labelMedium: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: MediaQuery.of(context).size.height * 0.018,
          ),
          labelLarge: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: MediaQuery.of(context).size.height * 0.025,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      //Tela em que inicia após compilar.
      home: const SplashPage(),
    );
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
    await sharedPreferences.setBool('editarPrevenda', false);
    await sharedPreferences.setBool('aplicarDesconto', false);
    await sharedPreferences.setBool('cadastrarCliente', false);
    await sharedPreferences.setBool('editarCliente', false);
    await sharedPreferences.setBool('criarPedido', false);
  }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Page size estimate: ${Platform.operatingSystemVersion}');
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

// void main() => runApp(const MyApp());
