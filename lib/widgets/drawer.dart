import 'package:flutter/material.dart';

import 'article/article-feed.dart';
import 'broswerview.dart';
import 'forum/forum-category-feed.dart';

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super();
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(25),
                        child: Text(
                          'MENU',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0a0a23),
                              fontSize: 24),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: navButton(
                          'NEWSFEED',
                          ArticleApp(),
                          Icon(
                            Icons.article,
                            size: 70,
                          ),
                          context)),
                  Expanded(
                      child: navButton(
                    'FORUM',
                    ForumCategoryView(),
                    Icon(
                      Icons.forum_outlined,
                      size: 70,
                    ),
                    context,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: navButton(
                          'PODCAST',
                          'https://www.google.com/',
                          Icon(
                            Icons.podcasts_outlined,
                            size: 70,
                          ),
                          context)),
                  Expanded(
                      child: navButton(
                    'RADIO',
                    'https://coderadio.freecodecamp.org/',
                    Icon(
                      Icons.radio,
                      size: 70,
                    ),
                    context,
                  )),
                ],
              ),
              Row(
                children: [
                  Expanded(
                      child: navButton(
                    'DONATE',
                    'https://www.freecodecamp.org/donate/',
                    Icon(
                      Icons.favorite,
                      size: 70,
                    ),
                    context,
                  )),
                  Expanded(
                    child: navButton(
                      'SETTINGS',
                      'https://www.google.com/',
                      Icon(
                        Icons.settings,
                        size: 70,
                      ),
                      context,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell navButton(String name, dynamic url, Icon icon, context) => InkWell(
        onTap: () {
          navigate(Widget view) {
            Navigator.pop(context);
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => view));
          }

          navigateUrl(String url) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Browserview(url: url)));
          }

          switch (name) {
            case 'NEWSFEED':
              {
                navigate(url);
              }
              break;
            case 'FORUM':
              {
                navigate(url);
              }
              break;
            case 'PODCAST':
              {
                navigateUrl(url);
              }
              break;
            case 'RADIO':
              {
                navigateUrl(url);
              }
              break;
            case 'DONATE':
              {
                navigateUrl(url);
              }
              break;
            case 'SETTINGS':
              {
                navigateUrl(url);
              }
              break;
            default:
              {
                Navigator.pop(context);
              }
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            width: 160,
            decoration: BoxDecoration(
                color: Color.fromRGBO(0xD0, 0xD0, 0xD5, 1),
                border: Border.all(color: Colors.black, width: 3)),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: icon,
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ))
                  ],
                )
              ],
            ),
          ),
        ),
      );
}
