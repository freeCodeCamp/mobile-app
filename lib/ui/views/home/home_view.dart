import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/news/news-bookmark/news_bookmark_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-feed/news_feed_view.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_model.dart';
import 'package:freecodecamp/ui/views/news/news-search/news_search_view.dart';
import 'package:freecodecamp/ui/widgets/nav_button_widget.dart';
import 'package:stacked/stacked.dart';

import 'home_viemmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> views = <dynamic>[
      const NewsBookmarkFeedView(),
      const NewsFeedView(),
      const NewsSearchView()
      //const ArticleSearch()
    ];
    List<Widget> titles = <Widget>[
      const Text('BOOKMARKED ARTICLES'),
      const Text('NEWSFEED'),
      const Text('SEARCH ARTICLES')
    ];
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0a0a23),
          title: titles.elementAt(viewModel.index),
          centerTitle: true,
        ),
        drawer: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Drawer(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(25),
                            child: Text(
                              'MENU',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0a0a23),
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: NavButtonWidget(
                          text: 'NEWSFEED',
                          url: 'https://www.google.com/',
                          icon: const Icon(
                            Icons.article,
                            size: 70,
                          ),
                          isWebComponent: true,
                          viewModel: viewModel,
                        ),
                      ),
                      Expanded(
                        child: NavButtonWidget(
                          text: 'FORUM',
                          url: 'https://forum.freecodecamp.org/',
                          icon: const Icon(
                            Icons.forum_outlined,
                            size: 70,
                          ),
                          isWebComponent: true,
                          viewModel: viewModel,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: NavButtonWidget(
                        text: 'PODCAST',
                        url: 'https://www.google.com/',
                        icon: const Icon(
                          Icons.podcasts_outlined,
                          size: 70,
                        ),
                        isWebComponent: true,
                        viewModel: viewModel,
                      )),
                      Expanded(
                          child: NavButtonWidget(
                        text: 'RADIO',
                        url: 'https://coderadio.freecodecamp.org/',
                        icon: const Icon(
                          Icons.radio,
                          size: 70,
                        ),
                        isWebComponent: true,
                        viewModel: viewModel,
                      )),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: NavButtonWidget(
                        text: 'DONATE',
                        url: 'https://www.freecodecamp.org/donate/',
                        icon: const Icon(
                          Icons.favorite,
                          size: 70,
                        ),
                        isWebComponent: true,
                        viewModel: viewModel,
                      )),
                      Expanded(
                        child: NavButtonWidget(
                          text: 'SETTINGS',
                          url: 'https://www.google.com/',
                          icon: const Icon(
                            Icons.settings,
                            size: 70,
                          ),
                          isWebComponent: true,
                          viewModel: viewModel,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        body: views.elementAt(viewModel.index),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color(0xFF0a0a23),
          unselectedItemColor: Colors.white,
          selectedItemColor: const Color.fromRGBO(0x99, 0xc9, 0xff, 1),
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.bookmark_outline_sharp,
                  color: Colors.white,
                ),
                label: 'Bookmarks'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.article_sharp,
                  color: Colors.white,
                ),
                label: 'Articles'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.search_sharp,
                  color: Colors.white,
                ),
                label: 'Search')
          ],
          currentIndex: viewModel.index,
          onTap: viewModel.onTapped,
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
