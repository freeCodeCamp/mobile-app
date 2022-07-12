import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/theme_map.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html_table/flutter_html_table.dart';
import 'package:freecodecamp/models/news/article_model.dart';
import 'package:freecodecamp/ui/views/news/news-article/news_article_header.dart';
import 'package:freecodecamp/ui/views/news/news-image-viewer/news_image_viewer.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HtmlHandler {
  HtmlHandler({Key? key, required this.html, required this.context});

  final String html;
  final BuildContext context;

  static List<Widget> htmlHandler(html, context, [article]) {
    var result = HtmlParser.parseHTML(html);

    List<Widget> elements = [];

    if (article is Article) {
      elements.add(Stack(children: [
        NewsArticleHeader(article: article),
        AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
        )
      ]));
    }
    for (int i = 0; i < result.children.length; i++) {
      elements.add(htmlWidgetBuilder(result.children[i].outerHtml, context));
    }
    if (article is Article) {
      elements.add(Container(height: 100));
    }
    return elements;
  }

  static void goToImageView(String imgUrl, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewsImageView(imgUrl: imgUrl)),
    );
  }

  static htmlWidgetBuilder(child, BuildContext context) {
    return Html(
      shrinkWrap: true,
      data: child,
      style: {
        'body': Style(
            fontFamily: 'Lato',
            padding: const EdgeInsets.only(left: 4, right: 4)),
        'blockquote': Style(fontSize: FontSize.rem(1.25)),
        'p': Style(
          fontSize: FontSize.rem(1.35),
          margin: const EdgeInsets.all(0),
          lineHeight: const LineHeight(1.5),
          color: Colors.white.withOpacity(0.87),
        ),
        'li': Style(
          margin: const EdgeInsets.only(top: 8),
          fontSize: FontSize.rem(1.35),
          color: Colors.white.withOpacity(0.87),
        ),
        'pre': Style(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(10),
        ),
        'tr': Style(
            border: const Border(bottom: BorderSide(color: Colors.grey)),
            backgroundColor: Colors.white),
        'th': Style(
          padding: const EdgeInsets.all(12),
          backgroundColor: const Color.fromRGBO(0xdf, 0xdf, 0xe2, 1),
          color: Colors.black,
        ),
        'td': Style(
          padding: const EdgeInsets.all(12),
          color: Colors.black,
          alignment: Alignment.topLeft,
        ),
        'figure': Style(
            width: MediaQuery.of(context).size.width, margin: EdgeInsets.zero),
        'h1': Style(
            margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
            fontSize: FontSize.rem(2.3)),
        'h2': Style(
            margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
            fontSize: FontSize.rem(2.3)),
        'h3': Style(
            margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
            fontSize: FontSize.rem(1.8)),
        'h4': Style(
            margin: const EdgeInsets.fromLTRB(2, 32, 2, 0),
            fontSize: FontSize.rem(1.8)),
        'h5': Style(margin: const EdgeInsets.fromLTRB(2, 32, 2, 0)),
        'h6': Style(margin: const EdgeInsets.fromLTRB(2, 32, 2, 0))
      },
      customRenders: {
        codeMatcher(): CustomRender.widget(widget: (code, child) {
          String? currentClass;

          bool codeLanguageIsPresent(List classNames) {
            RegExp regExp = RegExp(r'language-', caseSensitive: false);

            for (String className in classNames) {
              if (className.contains(regExp)) {
                currentClass = className;

                return true;
              }
            }

            return false;
          }

          List classes = code.tree.elementClasses;

          if (code.tree.element!.parent!.localName == 'pre') {
            return Row(
              children: [
                Expanded(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const ClampingScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width - 44),
                        child: HighlightView(code.tree.element?.text ?? '',
                            padding: const EdgeInsets.all(16),
                            language: codeLanguageIsPresent(classes)
                                ? currentClass!.split('-')[1]
                                : 'plaintext',
                            theme: themeMap['dracula']!),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }

          return Container(
            color: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            child: Text(code.tree.element!.text,
                style: TextStyle(fontSize: code.style.fontSize!.size)),
          );
        }),
        iframeYT(): CustomRender.widget(widget: (context, buildChildren) {
          double? width =
              double.tryParse(context.tree.attributes['width'] ?? '');
          double? height =
              double.tryParse(context.tree.attributes['height'] ?? '');
          return SizedBox(
            width: width ?? (height ?? 150) * 2,
            height: height ?? (width ?? 300) / 2,
            child: WebView(
              initialUrl: context.tree.attributes['src']!,
              javascriptMode: JavascriptMode.unrestricted,
              navigationDelegate: (NavigationRequest request) async {
                //no need to load any url besides the embedded youtube url when displaying embedded youtube, so prevent url loading
                if (!request.url.contains('youtube.com/embed')) {
                  return NavigationDecision.prevent;
                } else {
                  return NavigationDecision.navigate;
                }
              },
            ),
          );
        }),
        iframeOther(): CustomRender.widget(widget: (context, buildChildren) {
          double? width =
              double.tryParse(context.tree.attributes['width'] ?? '');
          double? height =
              double.tryParse(context.tree.attributes['height'] ?? '');
          return SizedBox(
            width: width ?? (height ?? 150) * 2,
            height: height ?? (width ?? 300) / 2,
            child: WebView(
              initialUrl: context.tree.attributes['src'],
              javascriptMode: JavascriptMode.unrestricted,
              //on other iframe content scrolling might be necessary, so use VerticalDragGestureRecognizer
              gestureRecognizers: {
                Factory(() => VerticalDragGestureRecognizer())
              },
            ),
          );
        }),
        imageMatcher(): CustomRender.widget(widget: (code, child) {
          var imgUrl = code.tree.attributes['src'] ?? '';

          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: imgUrl,
                  ),
                  Text(imgUrl),
                ],
              ));
        }),
        tableMatcher(): CustomRender.widget(widget: (context, child) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            // this calls the table CustomRender to render a table as normal (it uses a widget so we know widget is not null)
            child: tableRender.call().widget!.call(context, child),
          );
        }),
        bockQuoteMatcher(): CustomRender.widget(widget: (code, child) {
          return Container(
              decoration: const BoxDecoration(
                border: Border(
                  left: BorderSide(
                      color: Color.fromRGBO(0x99, 0xc9, 0xff, 1), width: 2),
                ),
              ),
              child: Row(
                children: [
                  for (var line in code.tree.element!.text.split('\n'))
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(line,
                            style: TextStyle(
                                fontSize: code.style.fontSize!.size,
                                fontFamily: 'lato')),
                      ),
                    ),
                ],
              ));
        })
      },
      onLinkTap: (String? url, RenderContext context,
          Map<String, String> attributes, dom.Element? element) {
        launchUrlString(url!);
      },
    );
  }

  static CustomRenderMatcher bockQuoteMatcher() =>
      (context) => context.tree.element?.localName == 'blockquote';

  static CustomRenderMatcher codeMatcher() =>
      (context) => context.tree.element?.localName == 'code';

  static CustomRenderMatcher tableMatcher() =>
      (context) => context.tree.element?.localName == 'table';

  static CustomRenderMatcher imageMatcher() =>
      (context) => context.tree.element?.localName == 'img';

  static CustomRenderMatcher iframeYT() => (context) =>
      context.tree.element?.attributes['src']?.contains('youtube.com/embed') ??
      false;

  static CustomRenderMatcher iframeOther() =>
      (context) => !(context.tree.element?.attributes['src']
              ?.contains('youtube.com/embed') ??
          context.tree.element?.attributes['src'] == null);

  static CustomRenderMatcher iframeNull() =>
      (context) => context.tree.element?.attributes['src'] == null;
}
