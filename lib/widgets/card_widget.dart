import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/models/lor_card.dart';

class CardWidget extends StatefulWidget {
  final LorCard lorCard;
  final bool showCount;

  const CardWidget({super.key, required this.lorCard, required this.showCount});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            CachedNetworkImage(
              imageUrl: CardHelper.getImageUrlFromCodeAndSet(
                  code: widget.lorCard.cardCode, set: widget.lorCard.deckSet),
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
                            widget.lorCard.cost.toString(),
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
                        widget.lorCard.name,
                        style: const TextStyle(
                          color: Colors.white,
                          decoration: TextDecoration.none,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    if (widget.showCount) const Spacer(),
                    if (widget.showCount)
                      Container(
                        width: 30,
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            'x${widget.lorCard.count}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
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
