import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:freecodecamp/models/card_model.dart';
import 'package:freecodecamp/service/database_service.dart';

class FlashCardListWidget extends StatefulWidget {
  final DatabaseService databaseService;
  final int type;

  const FlashCardListWidget(
      {Key? key, required this.databaseService, required this.type})
      : super(key: key);
  @override
  _FlashCardListWidgetState createState() => _FlashCardListWidgetState();
}

class _FlashCardListWidgetState extends State<FlashCardListWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.databaseService.getCards(widget.type),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return CardListSkeleton(
            isCircularImage: false,
            isBottomLinesActive: false,
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No cards available'),
          );
        } else {
          List<Map<String, dynamic>> cards = snapshot.data;
          Future editCard(int index) async {
            CardModel card = CardModel.fromMap(cards[index]);
            await showDialog(
                context: context,
                builder: (BuildContext context) {
                  int type = card.type;
                  TextEditingController frontController =
                      new TextEditingController();
                  frontController.text = card.front;
                  TextEditingController backController =
                      new TextEditingController();
                  backController.text = card.back;
                  return Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                    ),
                    child: StatefulBuilder(
                      builder: (BuildContext context,
                          void Function(void Function()) setState) {
                        return ListView(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          children: [
                            SizedBox(height: 5.0),
                            Center(
                              child: Text(
                                "Edit Card",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 50.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                minLines: 1,
                                maxLines: 5,
                                controller: frontController,
                                decoration: InputDecoration(
                                    labelText: "Enter question"),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                minLines: 1,
                                maxLines: 5,
                                controller: backController,
                                decoration:
                                    InputDecoration(labelText: "Enter answer"),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Center(
                              child: DropdownButton(
                                hint: Text("Choose type of card"),
                                value: type,
                                onChanged: (value) =>
                                    type = int.parse(value.toString()),
                                items: [
                                  DropdownMenuItem(
                                    child: Text('General'),
                                    value: 1,
                                  ),
                                  DropdownMenuItem(
                                    child: Text('Code'),
                                    value: 2,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 5.0),
                            CheckboxListTile(
                                title: Text("Known"),
                                value: card.known,
                                onChanged: (value) {
                                  setState(() {
                                    card.known = value!;
                                  });
                                }),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (type != -1 &&
                                      frontController.text != "" &&
                                      backController.text != "") {
                                    card.type = type;
                                    card.front = frontController.text;
                                    card.back = backController.text;
                                    widget.databaseService.updateCard(card);
                                    Navigator.pop(context);
                                  }
                                },
                                child: Center(
                                  child: Text("Submit"),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  );
                });
            setState(() {
              cards[index] = card.toMap();
            });
          }

          Future deleteCard(int index) async {
            setState(() {
              CardModel card = CardModel.fromMap(snapshot.data[index]);
              widget.databaseService.deleteCard(card);
              cards.removeAt(index);
            });
          }

          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: cards.length,
            itemBuilder: (BuildContext context, int index) {
              CardModel card = CardModel.fromMap(cards[index]);
              return Container(
                height: 0.25 * height,
                child: Card(
                  color: Color(0xFF0a0a23),
                  child: Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    actions: <Widget>[
                      IconSlideAction(
                        caption: 'Edit',
                        color: Colors.blue,
                        icon: Icons.edit,
                        onTap: () => editCard(index),
                      ),
                      IconSlideAction(
                        caption: 'Delete',
                        color: Colors.indigo,
                        icon: Icons.delete,
                        onTap: () => deleteCard(index),
                      ),
                    ],
                    child: Center(
                      child: FlipCard(
                        front: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                card.front,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        back: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                card.back,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
