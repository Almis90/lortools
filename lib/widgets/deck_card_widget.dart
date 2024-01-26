import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lortools/models/deck.dart';

class DeckCardWidget extends StatelessWidget {
  final Deck deck;

  static const TextStyle infoTextStyle = TextStyle(fontSize: 12);

  const DeckCardWidget({Key? key, required this.deck}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildContent(context),
            _buildStatisticsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Wrap(
      children: [
        _buildStatisticRowItem(Icons.emoji_events, '${deck.winrate}%'),
        _buildStatisticRowItem(Icons.play_arrow, '${deck.playrate}%'),
        const SizedBox(width: 8),
        _buildStatisticRowItem(Icons.groups, '${deck.totalMatches}'),
      ],
    );
  }

  Widget _buildStatisticRowItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon),
        Text(
          text,
          style: infoTextStyle,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    if (deck.champions?.isEmpty ?? true) {
      return Container();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: deck.champions!
                .map((champion) => _buildImage(champion.imageUrl, constraints))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildImage(String imageUrl, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        width: constraints.maxWidth / 3 - 4,
        height: constraints.maxWidth / 3 - 4,
        placeholder: (context, url) => const CircularProgressIndicator(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      ),
    );
  }
}
