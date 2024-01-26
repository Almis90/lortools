import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/sets_bloc.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/helpers/string_extensions.dart';
import 'package:lortools/models/champion.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/decks.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/models/set.dart';
import 'package:lortools/widgets/card_widget.dart';
import 'package:lortools/widgets/deck_card_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';

@RoutePage()
class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  final MultiSelectController<String> _championsController =
      MultiSelectController<String>();
  final MultiSelectController<String> _regionsController =
      MultiSelectController<String>();
  final MultiSelectController<String> _cardsController =
      MultiSelectController<String>();

  @override
  void initState() {
    super.initState();
    initializeDecks();
  }

  void initializeDecks() {
    context.read<DecksBloc>().add(DecksLoad());
    context.read<SetsBloc>().add(LoadAllCardsFromAllSets());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decks'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildDeckFilter(),
            _buildDecks(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCards(),
                  _buildOpponentCards(context),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLayout(String title, Widget content) {
    return Expanded(
      child: Card(
        child: Column(
          children: [
            _cardsTitle(title),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableCard(
      BuildContext context, LorCard card, BoxConstraints constraints) {
    return Draggable<LorCard>(
      data: card,
      feedback: SizedBox(
        width: constraints.maxWidth,
        child: Opacity(
          opacity: 0.5,
          child: CardWidget(lorCard: card),
        ),
      ),
      child: CardWidget(lorCard: card),
    );
  }

  Widget _buildOpponentCards(BuildContext context) {
    return _buildCardLayout(
      'Opponent Cards',
      DragTarget<LorCard>(
        onAccept: (data) {
          context.read<OpponentCardsBloc>().add(OpponentCardsAdd(data));
        },
        builder: (context, candidateData, rejectedData) {
          return BlocBuilder<OpponentCardsBloc, OpponentCardsState>(
            builder: (context, state) {
              if (state is OpponentCardsUpdated) {
                return ListView.builder(
                  itemCount: state.cards.length,
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return _buildDraggableCard(
                            context, state.cards[index], constraints);
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildCards() {
    return _buildCardLayout(
      'Cards',
      DragTarget<LorCard>(
        onAccept: (data) {
          context.read<OpponentCardsBloc>().add(OpponentCardsRemove(data));
        },
        builder: (context, candidateData, rejectedData) {
          return BlocBuilder<SetsBloc, SetsState>(
            builder: (context, state) {
              if (state is CardsLoaded) {
                var uniqueCards = _getUniqueSortedCards(state.cards);
                return ListView.builder(
                  itemCount: uniqueCards.length,
                  itemBuilder: (context, index) {
                    return LayoutBuilder(
                      builder: (context, constraints) {
                        return _buildDraggableCard(
                            context, uniqueCards[index], constraints);
                      },
                    );
                  },
                );
              } else {
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  List<LorCard> _getUniqueSortedCards(List<LorCard> cards) {
    // Filter for collectible cards and remove duplicates based on cardCode
    var uniqueCards = cards.where((card) => card.collectible).toSet().toList();

    // Sorting logic
    uniqueCards.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    return uniqueCards;
  }

  Padding _cardsTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(title),
    );
  }

  Widget _buildDeckFilter() {
    return Row(
      children: [
        Expanded(child: _buildChampionDropdown()),
        const SizedBox(width: 8),
        Expanded(child: _buildRegionDropdown()),
      ],
    );
  }

  Widget _buildChampionDropdown() {
    return BlocBuilder<DecksBloc, DecksState>(
      builder: (context, state) {
        if (state is DecksLoaded) {
          var champions = _getChampions(state);
          var dropdownItems =
              champions?.map(_championToValueItem).toList() ?? [];

          return MultiSelectDropDown<String>(
            hint: 'Select champions',
            controller: _championsController,
            onOptionSelected: _onChampionOptionSelected,
            searchEnabled: true,
            options: dropdownItems,
            selectionType: SelectionType.multi,
            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
            dropdownHeight: 300,
            optionTextStyle: const TextStyle(fontSize: 16),
            selectedOptionIcon: const Icon(Icons.check_circle),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildRegionDropdown() {
    return BlocBuilder<DecksBloc, DecksState>(
      builder: (context, state) {
        if (state is DecksLoaded) {
          var regions = _getRegions(state);
          var dropdownItems = regions?.map(_regionToValueItem).toList() ?? [];

          return MultiSelectDropDown<String>(
            hint: 'Select regions',
            controller: _regionsController,
            onOptionSelected: _onRegionOptionSelected,
            searchEnabled: true,
            options: dropdownItems,
            selectionType: SelectionType.multi,
            chipConfig: const ChipConfig(wrapType: WrapType.wrap),
            dropdownHeight: 300,
            optionTextStyle: const TextStyle(fontSize: 16),
            selectedOptionIcon: const Icon(Icons.check_circle),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildDecks() {
    return SizedBox(
      height: 120,
      child: BlocBuilder<DecksBloc, DecksState>(
        builder: (context, state) {
          if (state is DecksLoaded) {
            return _buildDecksLoaded(state);
          } else {
            return Container();
          }
        },
      ),
    );
  }

  ListView _buildDecksLoaded(DecksLoaded state) {
    var decks =
        state.filteredDecks.stats?.seven?.europe?.map(_deckStateServerToDeck) ??
            [];

    return ListView(
        scrollDirection: Axis.horizontal,
        children: decks.map((e) => _buildDeckCard(e)).toList());
  }

  Widget _buildDeckCard(Deck deck) {
    return SizedBox(
      width: 220,
      height: 120,
      child: DeckCardWidget(deck: deck),
    );
  }

  List<Champion>? _getChampions(DecksLoaded state) {
    if (state.decks.stats?.seven?.europe == null) {
      return null;
    }

    return state.decks.stats!.seven!.europe!
        .expand<Champion>((deckStat) =>
            deckStat.assets?.champions?.map((championData) => Champion(
                title: championData[0],
                imageUrl: CardHelper.getImageUrlFromCode(championData[1]))) ??
            const Iterable.empty())
        .toSet()
        .toList()
      ..sort((a, b) => a.title.compareTo(b.title));
  }

  List<String>? _getRegions(DecksLoaded state) {
    if (state.decks.stats?.seven?.europe == null) {
      return null;
    }

    return state.decks.stats!.seven!.europe!
        .expand<String>((deckStat) =>
            deckStat.assets?.champions
                ?.map((champion) => champion[2].toTitleCase()) ??
            const Iterable.empty())
        .toSet()
        .toList()
      ..sort();
  }

  void _onChampionOptionSelected(List<ValueItem<String>> selectedOptions) {
    var selectedTitles = selectedOptions.map(_valueItemToString).toList();

    context.read<DecksBloc>().add(DecksFilter(selectedTitles,
        _regionsController.selectedOptions.map(_valueItemToString).toList()));
  }

  void _onRegionOptionSelected(List<ValueItem<String>> selectedOptions) {
    var selectedTitles = selectedOptions.map(_valueItemToString).toList();

    context.read<DecksBloc>().add(DecksFilter(
        _championsController.selectedOptions.map(_valueItemToString).toList(),
        selectedTitles));
  }

  String _valueItemToString(ValueItem<String> valueItem) {
    return valueItem.value ?? '';
  }

  ValueItem<String> _championToValueItem(Champion champion) {
    return ValueItem(label: champion.title, value: champion.title);
  }

  ValueItem<String> _regionToValueItem(String region) {
    return ValueItem(label: region, value: region);
  }

  Champion _listStringToChampion(List<String> championInfo) {
    return Champion(
      title: championInfo[0],
      imageUrl: CardHelper.getImageUrlFromCode(championInfo[1]),
    );
  }

  Deck _deckStateServerToDeck(DeckStatsServer deckStatsServer) {
    return Deck(
        winrate: deckStatsServer.winrate ?? 0,
        playrate: deckStatsServer.playrate ?? 0,
        totalMatches: deckStatsServer.totalMatches ?? 0,
        champions: deckStatsServer.assets?.champions
                ?.map(_listStringToChampion)
                .toList() ??
            []);
  }
}
