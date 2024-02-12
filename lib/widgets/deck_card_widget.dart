import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/models/deck.dart';

class DeckCardWidget extends StatefulWidget {
  final Deck deck;

  static const TextStyle infoTextStyle = TextStyle(fontSize: 12);

  const DeckCardWidget({Key? key, required this.deck}) : super(key: key);

  @override
  State<DeckCardWidget> createState() => _DeckCardWidgetState();
}

class _DeckCardWidgetState extends State<DeckCardWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _loadDeckToPredicted,
      onLongPress: _copyDeckCodeToClipboard,
      child: _buildDeckCard(context),
    );
  }

  Card _buildDeckCard(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDeckCards(context),
            _buildStatisticsRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Wrap(
      children: [
        _buildStatisticRowItem(Icons.emoji_events, '${widget.deck.winrate}%'),
        _buildStatisticRowItem(Icons.play_arrow, '${widget.deck.playrate}%'),
        const SizedBox(width: 8),
        _buildStatisticRowItem(Icons.groups, '${widget.deck.totalMatches}'),
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
          style: DeckCardWidget.infoTextStyle,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Widget _buildDeckCards(BuildContext context) {
    if (widget.deck.champions.isEmpty) {
      return Container();
    }

    return _buildDeckWrap();
  }

  LayoutBuilder _buildDeckWrap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            children: widget.deck.champions
                .map((champion) => _buildDeckCardImageWithPadding(
                    champion.imageUrl, constraints))
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildDeckCardImageWithPadding(
      String imageUrl, BoxConstraints constraints) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: _buildDeckCardImage(imageUrl, constraints),
    );
  }

  Widget _buildDeckCardImage(String imageUrl, BoxConstraints constraints) {
    final sizeDivider =
        widget.deck.champions.length > 3 ? widget.deck.champions.length : 3;
    final size = constraints.maxWidth / sizeDivider - 4;
    const fit = BoxFit.cover;
    const Widget placeholder = CircularProgressIndicator();
    const Widget errorWidget = Icon(Icons.error);

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: size,
        height: size,
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : placeholder,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: size,
      height: size,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, error, stackTrace) => errorWidget,
    );
  }

  Future<void> _copyDeckCodeToClipboard() async {
    await Clipboard.setData(ClipboardData(text: widget.deck.deckCode));
  }

  void _loadDeckToPredicted() {
    context.read()<DecksBloc>().add(DecksLoad([widget.deck]));
    context
        .read<PredictedCardsBloc>()
        .add(PredictedCardsLoad(widget.deck.cards));
  }
}
