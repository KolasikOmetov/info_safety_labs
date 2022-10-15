import 'package:flutter/material.dart';
import 'package:info_safety_lab1/utils/utils.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({Key? key, required this.title, required this.body}) : super(key: key);

  final String title;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (_) => showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Developer:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Омётов Николай ПИбд-41',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Вариант:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '18',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Используемый режим шифрования алгоритма DES:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'CBC',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Добавление к ключу случайного значения:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Нет',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Используемый алгоритм хеширования:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'SHA',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        'Ограничения на выбираемые пароли:',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Наличие цифр, знаков препинания и знаков арифметических операций',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                );
              },
            ),
            itemBuilder: (BuildContext context) {
              return <PopupMenuEntry<String>>[
                PopupMenuItem(
                  value: 'About Program',
                  child: Text(
                    'About Program',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              ];
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Help',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () => exitProgram(context),
            child: Text(
              'Exit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
      body: body,
      resizeToAvoidBottomInset: false,
    );
  }
}
