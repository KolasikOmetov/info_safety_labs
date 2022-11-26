import 'package:flutter/material.dart';
import 'package:info_safety_lab2/controllers/entrance_controller.dart';
import 'package:info_safety_lab2/widgets/app_scafold.dart';
import 'package:provider/provider.dart';

class EntrancePage extends StatelessWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntranceController(),
      child: const _Content(),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Crypto ГОСТ 28147. Режим гаммирования.',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Expanded(
                    child: Text('''
                  ПИбд-41 Омётов Николай,
                  
                  вариант 18-5 5.	
                  Алгоритм ГОСТ 28147. Режим гаммирования.
                  его описание
                      '''),
                  ),
                  Expanded(
                    child: _ChooseFilesSection(),
                  ),
                ],
              )),
              Expanded(
                child: Column(
                  children: const [
                    Expanded(
                      child: _EncryptSection(),
                    ),
                    Expanded(
                      child: _DecryptSection(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DecryptSection extends StatelessWidget {
  const _DecryptSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      child: const Text('Decrypt'),
    );
  }
}

class _EncryptSection extends StatelessWidget {
  const _EncryptSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: TextField(
                decoration: InputDecoration(hintText: 'Password'),
              ),
            ),
            const SizedBox(
              width: 4,
            ),
            const Text('or'),
            const SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    child: const Text('From file'),
                  ),
                ],
              ),
            ),
          ],
        ),
        OutlinedButton(
          onPressed: () {},
          child: const Text('Encrypt'),
        ),
      ],
    );
  }
}

class _ChooseFilesSection extends StatelessWidget {
  const _ChooseFilesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('From'),
        const SizedBox(
          width: 4,
        ),
        Expanded(
            child: Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              child: const Text('Decrypt'),
            ),
            const Expanded(child: Text('From')),
          ],
        )),
        const SizedBox(
          width: 4,
        ),
        const Text('To'),
        const SizedBox(
          width: 4,
        ),
        Expanded(
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () {},
                child: const Text('From file'),
              ),
              const Expanded(child: Text('From')),
            ],
          ),
        ),
      ],
    );
  }
}
