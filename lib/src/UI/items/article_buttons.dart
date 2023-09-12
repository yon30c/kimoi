
import 'package:flutter/material.dart';

class ArticleButtons extends StatelessWidget {
  const ArticleButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.favorite_border),
            label: const Text('Me gusta')),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.comment_rounded),
            label: const Text('Comentar')),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.share),
            label: const Text('Compartir')),
      ],
    );
  }
}
