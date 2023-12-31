import 'package:flutter/material.dart';

class CustomOpacityTransition extends StatelessWidget {
  const CustomOpacityTransition({
    Key? key,
    this.visible,
    this.child,
  }) : super(key: key);

  final bool? visible;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      curve: Curves.ease,
      duration: const Duration(milliseconds: 300),
      opacity: visible! ? 1 : 0,
      child: child!,
    );
  }
}