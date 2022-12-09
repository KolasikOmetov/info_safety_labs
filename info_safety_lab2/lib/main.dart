import 'package:flutter/material.dart';
import 'package:info_safety_lab2/pages/entrance_page.dart';
import 'package:info_safety_lab2/services/crypto_service.dart';
import 'package:info_safety_lab2/services/system_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SystemService systemService = SystemService();
  runApp(App(systemService: systemService));
}

class App extends StatelessWidget {
  const App({super.key, required this.systemService});

  final SystemService systemService;

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => CryptoService(),
      child: Provider<SystemService>(
        create: (context) => systemService,
        child: MaterialApp(
          title: 'Lab 2',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.orange,
          ),
          home: const EntrancePage(),
        ),
      ),
    );
  }
}
