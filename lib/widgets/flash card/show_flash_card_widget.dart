import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:freecodecamp/models/card_model.dart';
import 'package:freecodecamp/service/database_service.dart';

class ShowFlashCardWidget extends StatefulWidget {
  final DatabaseService databaseService;
  final int type;

  const ShowFlashCardWidget(
      {Key? key, required this.databaseService, required this.type})
      : super(key: key);
  @override
  _ShowFlashCardWidgetState createState() => _ShowFlashCardWidgetState();
}

class _ShowFlashCardWidgetState extends State<ShowFlashCardWidget> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: widget.databaseService.getCards(widget.type),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting ||
            snapshot.connectionState == ConnectionState.active) {
          return CardSkeleton(
            isCircularImage: false,
            isBottomLinesActive: true,
          );
        } else if (!snapshot.hasData) {
          return Center(
            child: Text('No cards available'),
          );
        } else {
          List<Map<String, dynamic>> cards = snapshot.data;
          cards.shuffle();
          SwiperController swiperController = new SwiperController();
          return Swiper(
            itemBuilder: (BuildContext context, int index) {
              CardModel card = CardModel.fromMap(cards[index]);
              if (card.known) {
                setState(() {
                  cards.removeAt(index);
                });
              }
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    height: 0.7 * height,
                    child: Card(
                      color: Color(0xFF0a0a23),
                      child: Center(
                        child: FlipCard(
                          front: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  card.front,
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
                  // SizedBox(height: 5.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        card.known = true;
                        setState(() {
                          cards.removeAt(index);
                        });
                        widget.databaseService.updateCard(card);
                        swiperController.next();
                      },
                      child: Center(
                        child: Text("I know this"),
                      ),
                    ),
                  ),
                ],
              );
            },
            itemCount: cards.length,
            controller: swiperController,
          );
        }
      },
    );
  }
}
