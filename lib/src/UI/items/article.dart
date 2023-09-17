
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:kimoi/src/infrastructure/models/article_info.dart';

import '../services/webview/webview.dart';

class Article extends StatefulWidget {
  final ArticleInfo articleInfo;
  final bool loading;

  const Article({super.key, required this.articleInfo, required this.loading});

  @override
  State<Article> createState() => _ArticleState();
}

class _ArticleState extends State<Article> {

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => browser.openUrlRequest(
            urlRequest: URLRequest(url: Uri.parse(widget.articleInfo.url)),
            options: options),
        child: Card(
          clipBehavior: Clip.antiAlias,
          color: color.background,
          child: (widget.loading)
              ? const SizedBox(
                  height: 300,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ))
              : Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      FadeInImage(
                        image: NetworkImage(widget.articleInfo.imageUrl),
                        placeholder: const AssetImage("assets/loading4.gif"),
                        height: 207,
                        placeholderFit: BoxFit.contain,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FilledButton(
                          onPressed: () {},
                          style: const ButtonStyle(
                              visualDensity: VisualDensity.compact),
                          child: Text(
                            widget.articleInfo.category,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    child: Text(
                      widget.articleInfo.description,
                      style: textStyle.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            browser.openUrlRequest(
                                urlRequest: URLRequest(
                                    url: Uri.parse(widget.articleInfo.url)),
                                options: options);
                          },
                          icon: const Icon(Icons.remove_red_eye),
                          label: const Text('Ver más')),
                      TextButton.icon(
                          onPressed: () {
                            
                          },
                          icon: const Icon(Icons.share_outlined),
                          label: const Text('Compartir')),
                    ],
                  )
                ]),
        ),
      ),
    );
  }


}
