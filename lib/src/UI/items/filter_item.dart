import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/providers.dart';

class FilterItem extends ConsumerStatefulWidget {
  const FilterItem({super.key, required this.menuOptions, required this.title});

  final Map<int, String> menuOptions;
  final String title;

  @override
  FilterItemState createState() => FilterItemState();
}

class FilterItemState extends ConsumerState<FilterItem> {
  int? selectedFilter;

  void parameters(String title, int value) {
    switch (title) {
      case 'Estado':
        break;
      case 'Tipo':
        ref.read(tipoProvider.notifier).update((state) => value);
        break;
      case 'Estreno':
        ref.read(estrenoProvider.notifier).update((state) => value);
        break;
      case 'Genero':
        ref.read(generoProvider.notifier).update((state) => value);
        break;
      case 'Idioma':
        ref.read(idiomaProvider.notifier).update((state) => value);
        break;
      default:
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    return PopupMenuButton<int>(
      icon: ChoiceChip(
        label: Text(widget.menuOptions[selectedFilter] ?? widget.title),
        selected: selectedFilter == null ? false : true,
        selectedColor: color.secondaryContainer,
        labelStyle: TextStyle(color: color.onPrimaryContainer),
      ),
      itemBuilder: (context) {
        return widget.menuOptions.entries
            .map((e) => PopupMenuItem(value: e.key, child: Text(e.value)))
            .toList();
      },
      onSelected: (value) {
        setState(() {
          selectedFilter = value;
        });
        parameters(widget.title, value);

        ref.refresh(animeDirectoryProvider.notifier).getAnimes(
            estreno: ref.read(estrenoProvider),
            estado: ref.read(estadoProvider),
            tipo: ref.read(tipoProvider),
            genero: ref.read(generoProvider),
            idioma: ref.read(idiomaProvider));
      },
    );
  }
}
