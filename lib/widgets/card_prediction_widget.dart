import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/models/lor_card.dart';

class CardPredictionWidget extends StatefulWidget {
  final PredictLorCard lorCard;

  const CardPredictionWidget({super.key, required this.lorCard});

  @override
  State<CardPredictionWidget> createState() => _CardPredictionWidgetState();
}

class _CardPredictionWidgetState extends State<CardPredictionWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: CardHelper.getImageUrlFromCodeAndSet(
                  code: widget.lorCard.card.cardCode,
                  set: widget.lorCard.card.deckSet),
              fit: BoxFit.cover,
              width: double.infinity,
              height: 50,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: 50,
                color: Colors.black,
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Container(
              width: double.infinity,
              height: 50,
              color: Colors.black.withOpacity(0.25),
            ),
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: constraints.maxWidth,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 25.0,
                        height: 25.0,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            widget.lorCard.card.cost.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              decoration: TextDecoration.none,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        widget.lorCard.card.name,
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 70,
                      color: Colors.orange,
                      child: Center(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Text(
                                  '#1: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${widget.lorCard.percentages.elementAtOrNull(0)?.toStringAsFixed(2) ?? ''}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  '#2: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${widget.lorCard.percentages.elementAtOrNull(1)?.toStringAsFixed(2) ?? 0}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                const Text(
                                  '#3: ',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                                Text(
                                  '${widget.lorCard.percentages.elementAtOrNull(2)?.toStringAsFixed(2) ?? 0}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}