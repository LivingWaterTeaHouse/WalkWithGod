import 'package:flutter/material.dart';
import '../providers/article/article_provider.dart';
// import '../model/slide.dart';

class ArticleParagraph extends StatelessWidget {
  Paragraph _paragraph;

  ArticleParagraph(Paragraph paragraph) {
    this._paragraph = paragraph;
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      padding: const EdgeInsets.only(top: 20.0),
      width: MediaQuery.of(context).size.width * 160 / 188,
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(top: 10.0),
              //   child: Icon(
              //     Icons.label_outline,
              //     color: Colors.amber[200],
              //     size: 24.0,
              //     semanticLabel: 'Subtitle Icon',
              //   ),
              // ),
              _paragraph.subtitle == null
                  ? Container(
                      width: 200,
                      child: Text(
                        _paragraph.body,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    )
                  : Text(
                      _paragraph.subtitle,
                      style: Theme.of(context).textTheme.subtitle1,
                    )
            ],
          ),
        ),
        Text(_paragraph.body, style: Theme.of(context).textTheme.bodyText1),
      ]),
    );
  }
}
