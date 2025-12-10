import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> hasInternetConnection() async {
  // Verifica se está em Wi-Fi, dados móveis ou nenhum
  final connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false; // Sem nenhuma rede
  }

  // Verifica se realmente há acesso à internet
  return await InternetConnection().hasInternetAccess;
}
