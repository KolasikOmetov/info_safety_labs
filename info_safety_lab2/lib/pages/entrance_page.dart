import 'package:flutter/material.dart';
import 'package:info_safety_lab2/controllers/entrance_controller.dart';
import 'package:info_safety_lab2/utils/context_x.dart';
import 'package:info_safety_lab2/utils/utils.dart';
import 'package:info_safety_lab2/widgets/app_scafold.dart';
import 'package:provider/provider.dart';

class EntrancePage extends StatelessWidget {
  const EntrancePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EntranceController(context.read(), context.read()),
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
                  Режим гаммирования принимает на вход данные любого размера, а также дополнительный 64-битовый параметр — синхропосылку. В ходе работы синхропосылка преобразуется в цикле «32-З», результат делится на две части. Первая часть складывается по модулю 232 с постоянным значением 101010116. Если вторая часть равна 232-1, то её значение не меняется, иначе она складывается по модулю 232-1 с постоянным значением 101010416. Полученное объединением обеих преобразованных частей значение, называемое гаммой шифра, поступает в цикл «32-З», его результат порязрядно складывается по модулю 2 с 64-разрядным блоком входных данных. Если последний меньше 64-х разрядов, то лишние разряды полученного значения отбрасываются. Полученное значение подаётся на выход. Если ещё имеются входящие данные, то действие повторяется: составленный из 32-разрядных частей блок преобразуется по частям и так далее.
                      '''),
                  ),
                  Expanded(
                    child: _ChooseFilesSection(),
                  ),
                ],
              )),
              const Expanded(
                child: _ActionSection(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionSection extends StatelessWidget {
  const _ActionSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TextField(
            decoration: const InputDecoration(hintText: 'Password'),
            onChanged: (String text) => context.entranceController.setPassword(text),
          ),
        ),
        const SizedBox(height: 16),
        const Text('or'),
        const SizedBox(height: 16),
        Expanded(
          child: Column(
            children: [
              OutlinedButton(
                onPressed: () => context.entranceController.setPasswordPath(),
                child: const Text('From file'),
              ),
              const SizedBox(height: 16),
              Consumer<EntranceController>(
                builder: (context, state, _) {
                  return Text(state.pathPassword ?? 'File Path');
                },
              ),
            ],
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.entranceController.encrypt(
                onError: (String text) => showInfo(context, 'Error', text),
                onSuccess: (String text) => showInfo(context, 'Success', text),
              ),
              child: const Text('Encrypt'),
            ),
          ),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => context.entranceController.decrypt(
                onError: (String text) => showInfo(context, 'Error', text),
                onSuccess: (String text) => showInfo(context, 'Success', text),
              ),
              child: const Text('Decrypt'),
            ),
          ),
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
                onPressed: () => context.entranceController.setPathFrom(),
                child: const Text('Choose file'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Consumer<EntranceController>(
                  builder: (context, state, _) {
                    return Text(state.pathFrom ?? 'File Path');
                  },
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 4),
        const Text('To'),
        const SizedBox(width: 4),
        Expanded(
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () => context.entranceController.setPathTo(),
                child: const Text('Choose file path'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Consumer<EntranceController>(
                  builder: (context, state, _) {
                    return Text(state.pathTo ?? 'File Path');
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
