import 'package:flutter/widgets.dart';
import 'package:kimoi/src/utils/helpers/responsive.dart';

class VideoCoreForwardAndRewindLayout extends StatelessWidget {
  const VideoCoreForwardAndRewindLayout(
      {Key? key,
      required this.rewind,
      required this.forward,
      required this.responsive, required this.onRewind, required this.onForward})
      : super(key: key);

  final Function onRewind;
  final Function onForward;
  final Widget rewind;
  final Widget forward;
  final Responsive responsive;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: GestureDetector(
        onDoubleTap: () => onRewind(),
        child: rewind)),
      SizedBox(width: responsive.width / 3),
      Expanded(child: GestureDetector(
        onDoubleTap: ()=> onForward(),
        child: forward)),
    ]);
  }
}
