import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freecodecamp/ui/views/forum/forum-search/forum_search_model.dart';
import 'package:stacked/stacked.dart';

class ForumSearchView extends StatelessWidget {
  const ForumSearchView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ForumSearchModel>.reactive(
        viewModelBuilder: () => ForumSearchModel(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: TextField(
                decoration: const InputDecoration(
                    hintText: "SEARCH TOPIC...",
                    hintStyle: TextStyle(color: Colors.white),
                    fillColor: Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
                    filled: true),
                style: const TextStyle(color: Colors.white),
                onSubmitted: (value) {
                  model.checkQuery(value);
                },
              ),
              centerTitle: true,
              backgroundColor: const Color(0xFF0a0a23),
            ),
            backgroundColor: const Color.fromRGBO(0x2A, 0x2A, 0x40, 1),
            body: StreamBuilder<List<SearchModel>?>(
              stream: Stream.fromFuture(model.search(model.searchTerm)),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<SearchModel>? result = snapshot.data;

                  return Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                              itemCount: result?.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    model.goToPost(result?[index].slug,
                                        result?[index].topicId);
                                  },
                                  child: Container(
                                    height: 100,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width: 2,
                                                color: Colors.white))),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        result?[index].title as String,
                                        style: const TextStyle(
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
                    model.queryToShort
                        ? 'The query is to short'
                        : 'Type something to search',
                    style: const TextStyle(color: Colors.white),
                  ));
                }
              },
            )));
  }
}
