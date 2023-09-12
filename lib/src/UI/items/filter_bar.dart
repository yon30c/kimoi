import 'package:flutter/material.dart';
import 'package:kimoi/src/UI/items/filter_item.dart';

import '../shared/filter_options.dart';

class FilterBar extends StatefulWidget {
  const FilterBar({super.key});

  @override
  State<FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<FilterBar> {
  Map<int, String> estrenoOptions = {};

  int year = DateTime.now().year;

  @override
  void initState() {
    super.initState();

    for (var i = 0; i < 30; i++) {

      final estrenoEntries = {year : year.toString()};
      estrenoOptions.addEntries(  estrenoEntries.entries);
      year--;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        FilterItem(menuOptions: estrenoOptions , title: 'Estreno'),
        
        FilterItem(
          menuOptions: generosOptions,
          title: 'Genero',
        ),
        FilterItem(
          menuOptions: stateOptions,
          title: 'Estado',
        ),
        FilterItem(menuOptions: tiposOptions, title: 'Tipo'),
        FilterItem(menuOptions: languagesOptions, title: 'Idioma')
      ],
    );
  }
}
