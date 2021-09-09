import 'package:flutter/material.dart';
import 'package:freecodecamp/models/forum-search-model.dart';

import 'forum-postview.dart';

class ForumSearch extends StatefulWidget {
  _ForumSearchState createState() => _ForumSearchState();
}

class _ForumSearchState extends State<ForumSearch> {
  String _term = '';
  bool queryToShort = false;
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: TextField(
            decoration: InputDecoration(
                hintText: "SEARCH TOPIC...",
                hintStyle: TextStyle(color: Colors.white),
                fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                filled: true),
            style: TextStyle(color: Colors.white),
            onSubmitted: (value) {
              if (value.length <= 2) {
                setState(() {
                  queryToShort = true;
                });
              } else {
                setState(() {
                  _term = value;
                  queryToShort = false;
                });
              }
            },
          ),
          centerTitle: true,
          backgroundColor: Color(0xFF0a0a23),
        ),
        backgroundColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
        body: StreamBuilder<List<SearchResult>?>(
          stream: Stream.fromFuture(SearchModel.search(_term)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SearchResult>? result = snapshot.data;

              return Column(
                children: [
                  Expanded(
                      child: ListView.builder(
                          itemCount: result?.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ForumPostView(
                                              refPostId: result?[index]
                                                  .topicId
                                                  .toString() as String,
                                              refSlug:
                                                  result?[index].slug as String,
                                            )));
                              },
                              child: Container(
                                height: 100,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 2, color: Colors.white))),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    result?[index].title as String,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          }))
                ],
              );
            } else {
              return Center(
                  child: Text(
                queryToShort
                    ? 'The query is to short'
                    : 'Type something to search',
                style: TextStyle(color: Colors.white),
              ));
            }
          },
        ));
  }
}
