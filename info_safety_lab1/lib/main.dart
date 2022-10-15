import 'package:flutter/material.dart';
import 'package:info_safety_lab1/controllers/user_list_controller.dart';
import 'package:info_safety_lab1/pages/entrance_page.dart';
import 'package:info_safety_lab1/services/system_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SystemService systemService = await SystemService.init();
  runApp(App(systemService: systemService));
}

class App extends StatelessWidget {
  const App({super.key, required this.systemService});

  final SystemService systemService;

  @override
  Widget build(BuildContext context) {
    return Provider<SystemService>(
      create: (context) => systemService,
      child: ChangeNotifierProvider(
        create: (_) => UserListController(systemService),
        child: MaterialApp(
          title: 'Lab 1',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const EntrancePage(),
        ),
      ),
    );
  }
}
