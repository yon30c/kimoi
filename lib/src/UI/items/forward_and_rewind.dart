import 'package:flutter/material.dart';
import 'package:kimoi/src/UI/items/rewind_and_forward_layout.dart';
import 'package:kimoi/src/UI/items/ripple_side.dart';
import 'package:kimoi/src/UI/items/transitions.dart';

import '../../utils/helpers/responsive.dart';

class VideoCoreForwardAndRewind extends StatelessWidget {
  const VideoCoreForwardAndRewind(
      {Key? key,
      required this.showRewind,
      required this.showForward,
      required this.forwardSeconds,
      required this.rewindSeconds,
      required this.responsive, required this.onRightTap, required this.onLeftTap})
      : super(key: key);

  final bool showRewind, showForward;
  final int rewindSeconds, forwardSeconds;
  final Responsive responsive;
  final Function onRightTap;
  final Function onLeftTap;
  @override
  Widget build(BuildContext context) {
    return VideoCoreForwardAndRewindLayout(
      onRewind: onLeftTap,
      onForward: onRightTap,
      responsive: responsive,
      rewind: CustomOpacityTransition(
        visible: showRewind,
        child: ForwardAndRewindRippleSide(
          text: "$rewindSeconds Sec",
          side: RippleSide.left,
        ),
      ),
      forward: CustomOpacityTransition(
        visible: showForward,
        child: ForwardAndRewindRippleSide(
          text: "$forwardSeconds Sec",
          side: RippleSide.right,
        ),
      ),
    );
  }
}
