import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:darq/darq.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/decks_tutorial_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/bloc/preview_card_bloc.dart';
import 'package:lortools/bloc/search_cards_bloc.dart';
import 'package:lortools/bloc/cards_bloc.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/helpers/decks_tutorial_helper.dart';
import 'package:lortools/keys.dart';
import 'package:lortools/models/champion.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/pages/settings_page.dart';
import 'package:lortools/widgets/card_prediction_widget.dart';
import 'package:lortools/widgets/card_widget.dart';
import 'package:lortools/widgets/deck_app_bar.dart';
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
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late DecksTutorialHelper _decksTutorialHelper;

  @override
  void initState() {
    super.initState();

    _decksTutorialHelper = DecksTutorialHelper(context: context);

    _loadAllCardsFromAllSets();

    _addFocusListenerToSearchCardText();

    _showTutorialIfApplicable();
  }

  void _showTutorialIfApplicable() {
    context.read<DecksTutorialBloc>().add(DecksTutorialShowEvent(force: false));
  }

  void _addFocusListenerToSearchCardText() {
    _searchFocusNode.addListener(() {
      if (!_searchFocusNode.hasFocus) {
        _toggleSearchCards();
      }
    });
  }

  void _toggleSearchCards() {
    context
        .read<SearchCardsBloc>()
        .add(SearchCardsToggle(_searchController.text));
  }

  void _loadAllCardsFromAllSets() {
    context.read<CardsBloc>().add(CardsLoadFromAllSets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DecksTutorialBloc, DecksTutorialState>(
      listener: (context, state) {
        if (state is DecksTutorialActiveState) {
          _decksTutorialHelper.showTutorial();
        }
      },
      child: _buildDecksScaffold(),
    );
  }

  Scaffold _buildDecksScaffold() {
    return Scaffold(
      key: Keys.scaffoldKey,
      appBar: const DeckAppBar(),
      endDrawer: const SettingsPage(),
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
                  _buildOpponentCardsCard(),
                  _buildPredictedCardsCard(),
                  _buildCardPreview(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardLayoutWithSearch(
      String title, Widget content, List<LorCard> cards) {
    return Expanded(
      key: Keys.cardsKey,
      child: Card(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCardsTitleOrSearchBloc(title),
                _buildCardsSearchIconBloc(),
              ],
            ),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }

  Widget _buildCardsSearchIconBloc() {
    return BlocConsumer<SearchCardsBloc, SearchCardsState>(
      listener: (context, state) {
        if (state is SearchCardsInitial) {
          _searchController.clear();
        }
      },
      builder: (context, state) {
        if (state is SearchCardsInitial) {
          return GestureDetector(
            child: Icon(
              key: Keys.searchCardIconKey,
              Icons.search,
            ),
            onTap: () {
              context
                  .read<SearchCardsBloc>()
                  .add(SearchCardsToggle(_searchController.text));
            },
          );
        } else {
          return GestureDetector(
            child: const Icon(Icons.close_sharp),
            onTap: () {
              context
                  .read<SearchCardsBloc>()
                  .add(SearchCardsToggle(_searchController.text));
            },
          );
        }
      },
    );
  }

  BlocBuilder<SearchCardsBloc, SearchCardsState> _buildCardsTitleOrSearchBloc(
      String title) {
    return BlocBuilder<SearchCardsBloc, SearchCardsState>(
      builder: (context, state) {
        if (state is SearchCardsInitial) {
          return _cardsTitle(title);
        } else {
          return Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  context.read<CardsBloc>().add(FilterCardsByName(value));
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDraggableCard(BuildContext context, LorCard card,
      BoxConstraints constraints, bool showCount) {
    return Draggable<LorCard>(
      data: card,
      feedback: SizedBox(
        width: constraints.maxWidth,
        child: Opacity(
          opacity: 0.5,
          child: CardWidget(lorCard: card, showCount: showCount),
        ),
      ),
      child: GestureDetector(
        onLongPress: () => _previewCard(card),
        onSecondaryTap: () => _previewCard(card),
        child: CardWidget(lorCard: card, showCount: showCount),
      ),
    );
  }

  Widget _buildOpponentCardsCard() {
    return Expanded(
      key: Keys.opponentCardsKey,
      child: Card(
        child: Column(
          children: [
            _cardsTitle('Opponent Cards'),
            Expanded(
              child: DragTarget<LorCard>(
                onAccept: (data) {
                  var opponentCardsBloc = context.read<OpponentCardsBloc>();
                  opponentCardsBloc.add(OpponentCardsAdd(data));

                  if (data.rarity == 'Champion' &&
                      !_championsController.selectedOptions
                          .any((x) => x.value == data.cardCode)) {
                    _championsController.addSelectedOption(
                        _championsController.options.firstWhere(
                            (element) => element.value == data.cardCode));
                  }

                  context.read<PredictedCardsBloc>().add(PredictedCardsUpdate(
                      opponentCardsBloc.cards.toList()..add(data)));
                },
                builder: (context, candidateData, rejectedData) {
                  return BlocBuilder<OpponentCardsBloc, OpponentCardsState>(
                    builder: (context, state) {
                      if (state is OpponentCardsUpdated) {
                        if (state.cards.isEmpty) {
                          return _buildEmptyOpponentCards();
                        } else {
                          return ListView.builder(
                            itemCount: state.cards.length,
                            itemBuilder: (context, index) {
                              return LayoutBuilder(
                                builder: (context, constraints) {
                                  return _buildDraggableCard(context,
                                      state.cards[index], constraints, true);
                                },
                              );
                            },
                          );
                        }
                      } else {
                        return _buildEmptyOpponentCards();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding _buildEmptyOpponentCards() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Drag and drop a card from the left lists of cards here.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCards() {
    return BlocBuilder<CardsBloc, CardsState>(
      builder: (context, state) {
        if (state is CardsLoaded) {
          var decksBloc = context.read<DecksBloc>();
          if (decksBloc.state is DecksInitial) {
            decksBloc.add(DecksInitialize());
          }

          return _buildCardLayoutWithSearch(
              'Cards',
              DragTarget<LorCard>(
                onAccept: (data) {
                  var opponentCardsBloc = context.read<OpponentCardsBloc>();
                  opponentCardsBloc.add(OpponentCardsRemove(data));

                  if (data.rarity == 'Champion' &&
                      _championsController.selectedOptions
                          .any((x) => x.value == data.cardCode)) {
                    _championsController.clearSelection(
                        _championsController.options.firstWhere(
                            (element) => element.value == data.cardCode));
                  }

                  context.read<PredictedCardsBloc>().add(PredictedCardsUpdate(
                      opponentCardsBloc.cards.toList()..remove(data)));
                },
                builder: (context, candidateData, rejectedData) {
                  var uniqueCards = _getUniqueSortedCards(state.filteredCards);
                  return ListView.builder(
                    itemCount: uniqueCards.length,
                    itemBuilder: (context, index) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          return _buildDraggableCard(
                              context, uniqueCards[index], constraints, false);
                        },
                      );
                    },
                  );
                },
              ),
              state.allCards);
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildPredictedCardsCard() {
    return Expanded(
      key: Keys.predictedCardsKey,
      child: Card(
        child: Column(
          children: [
            _cardsTitle('Predicted Cards'),
            _buildPredictedCardsBloc(),
          ],
        ),
      ),
    );
  }

  BlocBuilder<PredictedCardsBloc, PredictedCardsState>
      _buildPredictedCardsBloc() {
    return BlocBuilder<PredictedCardsBloc, PredictedCardsState>(
      builder: (context, state) {
        if (state is PredictedCardsUpdated) {
          if (state.cards.isEmpty) {
            return _buildEmptyPredictedCards();
          } else {
            return _buildPredictedCards(state);
          }
        } else {
          return _buildInitialPredictedCards();
        }
      },
    );
  }

  Widget _buildPredictedCards(PredictedCardsUpdated state) {
    return Expanded(
      child: ListView.builder(
        itemCount: state.cards.length,
        itemBuilder: (context, index) {
          return LayoutBuilder(
            builder: (context, constraints) {
              var predictedCard = state.cards[index];

              return GestureDetector(
                onLongPress: () => _previewCard(predictedCard.card),
                onDoubleTap: () => _previewCard(predictedCard.card),
                child: CardPredictionWidget(lorCard: predictedCard),
              );
            },
          );
        },
      ),
    );
  }

  Padding _buildInitialPredictedCards() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'Add some cards to opponent cards and this list will be automatically updated.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Padding _buildEmptyPredictedCards() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'The selected cards are not included in any of the meta decks.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  List<LorCard> _getUniqueSortedCards(List<LorCard> cards) {
    var uniqueCards = cards.where((card) => card.collectible).toSet().toList();

    uniqueCards.sort((a, b) {
      return a.name.compareTo(b.name);
    });

    return uniqueCards;
  }

  Padding _cardsTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
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
    return BlocConsumer<CardsBloc, CardsState>(
      listener: (context, state) {
        if (state is CardsInitial) {
          _championsController.clearAllSelection();
        }
      },
      builder: (context, state) {
        if (state is CardsLoaded) {
          var champions = _getChampions(state.allCards);
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
    return BlocConsumer<CardsBloc, CardsState>(
      listener: (context, state) {
        if (state is CardsInitial) {
          _regionsController.clearAllSelection();
        }
      },
      builder: (context, state) {
        if (state is CardsLoaded) {
          var regions = _getRegions(state.allCards);
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
      key: Keys.decksKey,
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
    var decks = state.filteredDecks;

    return ListView(
        scrollDirection: Axis.horizontal,
        children: decks.map((e) => _buildDeckCard(e)).toList());
  }

  Widget _buildDeckCard(Deck deck) {
    var width = 75.0 * deck.champions.length;
    width = width < 220 ? 220 : width;

    return SizedBox(
      width: width,
      height: 120,
      child: DeckCardWidget(deck: deck),
    );
  }

  List<Champion>? _getChampions(List<LorCard> cards) {
    var regions = _regionsController.selectedOptions.map((e) => e.value ?? '');

    return cards
        .where((card) =>
            card.rarity == 'Champion' &&
            (regions.isEmpty ||
                regions.any((region) => card.regions.contains(region))))
        .map((e) => Champion(
            name: e.name,
            cardCode: e.cardCode,
            imageUrl: CardHelper.getImageUrlFromCode(e.cardCode)))
        .distinct()
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
  }

  List<String>? _getRegions(List<LorCard> cards) {
    return cards
        .where((card) => card.rarity == 'Champion')
        .expand((e) => e.regions)
        .toSet()
        .toList()
      ..sort();
  }

  void _onChampionOptionSelected(List<ValueItem<String>> selectedOptions) {
    var selectedTitles = selectedOptions.map(_valueItemToString).toList();

    context.read<DecksBloc>().add(DecksFilterByChampions(selectedTitles));
    context.read<CardsBloc>().add(CardsFilter(selectedTitles,
        _regionsController.selectedOptions.map(_valueItemToString).toList()));
  }

  void _onRegionOptionSelected(List<ValueItem<String>> selectedOptions) {
    var selectedTitles = selectedOptions.map(_valueItemToString).toList();

    context.read<DecksBloc>().add(DecksFilterByRegions(selectedTitles));
    context.read<CardsBloc>().add(CardsFilter(
        _championsController.selectedOptions.map(_valueItemToString).toList(),
        selectedTitles));
  }

  String _valueItemToString(ValueItem<String> valueItem) {
    return valueItem.value ?? '';
  }

  ValueItem<String> _championToValueItem(Champion champion) {
    return ValueItem(label: champion.name, value: champion.cardCode);
  }

  ValueItem<String> _regionToValueItem(String region) {
    return ValueItem(label: region, value: region);
  }

  Widget _buildCardPreview() {
    return Expanded(
      key: Keys.previewCardsKey,
      child: Card(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _cardsTitle('Card Preview'),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: BlocBuilder<PreviewCardBloc, PreviewCardState>(
                  builder: (context, state) {
                    if (state is PreviewCardSelectedState) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                        child: _buildCardPreviewImage(
                          card: state.card,
                        ),
                      );
                    } else {
                      return _buildEmptyPreviewCard();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildEmptyPreviewCard() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'To preview a card, long press or right-click on a card.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildCardPreviewImage({required LorCard card}) {
    const Widget placeholder = CircularProgressIndicator();
    const Widget errorWidget = Icon(Icons.error);

    if (kIsWeb) {
      return Image.network(
        CardHelper.getImageUrlFromCodeAndSet(
          code: card.cardCode,
          set: card.deckSet,
          full: false,
        ),
        loadingBuilder: (context, child, loadingProgress) =>
            loadingProgress == null ? child : placeholder,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }

    return CachedNetworkImage(
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
      imageUrl: CardHelper.getImageUrlFromCodeAndSet(
        code: card.cardCode,
        set: card.deckSet,
        full: false,
      ),
    );
  }

  _previewCard(LorCard card) {
    context.read<PreviewCardBloc>().add(PreviewCardSelectEvent(card: card));
  }
}
