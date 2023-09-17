// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';


enum Type {TV, OVA, Especial, Pelicula, Todo}
enum Estado {Emision, Finalizado, Todo}

class FilterDialog extends StatefulWidget {
  const FilterDialog({super.key});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  ValueNotifier<Type> selectedValue = ValueNotifier(Type.Todo);
  ValueNotifier<Estado> selectedValue2 = ValueNotifier(Estado.Todo);

  void _handleRadioChange(Type value) {
    setState(() {
      selectedValue.value = value;
    });
  }

    void _handleRadioChange2(Estado value) {
    setState(() {
      selectedValue2.value = value;
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
            child: Text('TIPO', style: textStyle.titleMedium,),
          ),
          RadioListTile<Type>(
            title: const Text('Todo'),
            value: Type.Todo,
            groupValue: selectedValue.value,
            onChanged: (value) => _handleRadioChange(value!),
          ),
          RadioListTile<Type>(
            title: const Text('TV'),
            value: Type.TV,
            groupValue: selectedValue.value,
            onChanged: (value) => _handleRadioChange(value!),
          ),
          RadioListTile(
              title: const Text('Pelicula'),
              value: Type.Pelicula,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('OVA'),
              value: Type.OVA,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          RadioListTile(
              title: const Text('Especial'),
              value: Type.Especial,
              groupValue: selectedValue.value,
              onChanged: (value) => _handleRadioChange(value!)),
          const Divider(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('ESTADO', style: textStyle.titleMedium,),
          ),

           RadioListTile<Estado>(
            title: const Text('Todo'),
            value: Estado.Todo,
            groupValue: selectedValue2.value,
            onChanged: (value) => _handleRadioChange2(value!),
          ),
          RadioListTile<Estado>(
            title: const Text('Emisión'),
            value: Estado.Emision,
            groupValue: selectedValue2.value,
            onChanged: (value) => _handleRadioChange2(value!),
          ),
          RadioListTile<Estado>(
              title: const Text('Finalizado'),
              value: Estado.Finalizado,
              groupValue: selectedValue2.value,
              onChanged: (value) => _handleRadioChange2(value!)),

        ],
      ),

      bottomNavigationBar: BottomAppBar(
        height: 70,
        child: FilledButton(
          style: ButtonStyle(shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), visualDensity: VisualDensity.compact),
          onPressed: () {}, child: const Text('Actualizar filtros')),
      ),
    );
  }
}
