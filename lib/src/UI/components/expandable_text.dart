

import 'package:flutter/material.dart';

class ExpandableText extends StatefulWidget {
  final String text;
  final int maxLines;
  final int minLines;

  const ExpandableText({super.key,required this.maxLines, required this.minLines, required this.text});

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _isExpanded = false;

  Widget expandableText(bool isExpanded) {
    return Text(
      widget.text,
      overflow: TextOverflow.ellipsis,
      maxLines: isExpanded ? widget.maxLines : widget.minLines,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;
    return Column(
      children: [

         Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text("Sinopsis:", style: textStyle.labelLarge?.copyWith(color: color.primary),),
            ),
             GestureDetector(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 20,
              child: widget.text.length > 40 ? 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    !_isExpanded ? "Mostrar más" : "Mostrar menos",
                    style: textStyle.labelMedium?.copyWith(
                      color: color.primary,
                    ),
                  ),
                  Icon(
                    !_isExpanded ? Icons.arrow_drop_down_rounded : Icons.arrow_drop_up_rounded,
                    color: color.primary,
                  )
                ],
              ): null
            ),
          ),
        )
          ],
        ),

        Padding(
          padding: const EdgeInsets.symmetric( horizontal : 8.0),
          // AnimatedCrossFade uses crossFadeState to determine the tansition between first and second child
          child: AnimatedExpandingContainer(
            isExpanded: _isExpanded,
            // use  true and false below instead of using _isExpanded
            // using _isExpanded will affect the animation tranisition
            expandedWidget: expandableText(true),
            unexpandedWidget: expandableText(false),
          ),
        ),
       
      ],
    );
  }
}

class AnimatedExpandingContainer extends StatelessWidget {
  const AnimatedExpandingContainer({
    super.key,
    required this.unexpandedWidget,
    required this.expandedWidget,
    required this.isExpanded,
  });

  final Widget unexpandedWidget;
  final Widget expandedWidget;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    // you can change the duration and add Curve to make more smoother tranition
    return AnimatedCrossFade(
        firstCurve: Curves.linear,
        secondCurve: Curves.linear,
        firstChild: unexpandedWidget,
        secondChild: expandedWidget,
        crossFadeState:
            !isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 200));
  }
}
