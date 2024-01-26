import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/models/set.dart';

class CardWidget extends StatefulWidget {
  final LorCard lorCard;

  const CardWidget({super.key, required this.lorCard});

  @override
  State<CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<CardWidget> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: CardHelper.getImageUrlFromCodeAndSet(
              widget.lorCard.cardCode, widget.lorCard.deckSet, true),
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
          child: Row(
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
                      widget.lorCard.cost?.toString() ?? '0',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
              Text(
                widget.lorCard.name ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
