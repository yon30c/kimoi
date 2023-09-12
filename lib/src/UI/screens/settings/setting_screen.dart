import 'package:flutter/material.dart';
import 'package:kimoi/main.dart';

class SettingScreen extends StatelessWidget {
  static const String name = 'setting-screen';

  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Configuración'),
        ),
        body: const _SettingsView());
  }
}

class _SettingsView extends StatefulWidget {
  const _SettingsView();

  @override
  State<_SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<_SettingsView> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
        showSelectedIcon: false,
        style: const ButtonStyle(
            visualDensity: VisualDensity.comfortable,
            padding:
                MaterialStatePropertyAll(EdgeInsets.symmetric(horizontal: 20))),
        onSelectionChanged: (value) {
          themeController.updateThemeMode(value.first);
          setState(() {});
        },
        segments: const [
          ButtonSegment(
              enabled: true, value: ThemeMode.light, label: Text('Claro')),
          ButtonSegment(
              enabled: true, value: ThemeMode.system, label: Text('Sistema')),
          ButtonSegment(
              enabled: true, value: ThemeMode.dark, label: Text('Oscuro')),
        ],
        selected: {
          themeController.themeMode
        });
  }
}
