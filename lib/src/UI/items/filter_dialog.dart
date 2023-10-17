// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kimoi/src/UI/providers/animes/anime_directory_provider.dart';
import 'package:kimoi/src/UI/providers/animes/anime_filter_provider.dart';

enum Type { Anime, Ova, Especial, Pelicula, Todo, Ona, Donghua, Corto }

enum Estado { Emision, Finalizado, Todo }

final typeValueProvider = StateProvider<Type>((ref) => Type.Todo);

class FilterDialog extends ConsumerStatefulWidget {
  const FilterDialog({super.key});

  @override
  FilterDialogState createState() => FilterDialogState();
}

class FilterDialogState extends ConsumerState<FilterDialog> {
  ValueNotifier<Type> selectedValue = ValueNotifier(Type.Todo);

  @override
  void initState() {
    super.initState();
    selectedValue.value = ref.read(typeValueProvider);
  }

  void _handleRadioChange(Type value) {
    ref.read(typeValueProvider.notifier).update((state) => value);
    setState(() {
      selectedValue.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'TIPO',
              style: textStyle.titleMedium,
            ),
          ),
          RadioListTile<Type>(
            title: const Text('Todo'),
            value: Type.Todo,
            groupValue: selectedValue.value,
            onChanged: (value) => _handleRadioChange(value!),
          ),
          RadioListTile<Type>(
            title: const Text('Anime'),
            value: Type.Anime,
            groupValue: selectedValue.value,
            onChanged: (value) => _handleRadioChange(value!),
          ),
          RadioListTile(
              title: const Text('Donghua'),
              value: Type.Donghua,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('Pelicula'),
              value: Type.Pelicula,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('Especial'),
              value: Type.Especial,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('OVA'),
              value: Type.Ova,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('ONA'),
              value: Type.Ona,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('Corto'),
              value: Type.Corto,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: FilledButton(
            style: ButtonStyle(
                shape: MaterialStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
                visualDensity: VisualDensity.compact),
            onPressed: () {
              String tipo = switch (selectedValue.value) {
                Type.Anime => 'anime',
                Type.Ova => 'ova',
                Type.Corto => 'corto',
                Type.Pelicula => 'pelicula',
                Type.Donghua => 'donghua',
                Type.Especial => 'especial',
                Type.Ona => 'ona',
                Type.Todo => '',
              };

              String label = switch (selectedValue.value) {
                Type.Anime => 'Anime',
                Type.Ova => 'Ova',
                Type.Corto => 'Corto',
                Type.Pelicula => 'Pelicula',
                Type.Donghua => 'Donghua',
                Type.Especial => 'Especial',
                Type.Ona => 'Ona',
                Type.Todo => '',
              };

              ref.read(tipoProvider.notifier).update((state) => tipo);
              ref.read(labelProvider.notifier).update((state) => label);
              ref
                  .refresh(animeDirectoryProvider.notifier)
                  .getAnimes(tipo: ref.read(tipoProvider), estreno: ref.read(estrenoProvider));
              context.pop();
            },
            child: const Text('Actualizar filtros')),
      ),
    );
  }
}
