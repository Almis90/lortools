import 'package:auto_route/auto_route.dart';
import 'package:darq/darq.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lortools/bloc/app_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/bloc/search_cards_bloc.dart';
import 'package:lortools/bloc/cards_bloc.dart';
import 'package:lortools/bloc/settings_bloc.dart';
import 'package:lortools/helpers/card_helper.dart';
import 'package:lortools/models/champion.dart';
import 'package:lortools/models/deck.dart';
import 'package:lortools/models/lor_card.dart';
import 'package:lortools/pages/settings_page.dart';
import 'package:lortools/widgets/card_prediction_widget.dart';
import 'package:lortools/widgets/card_widget.dart';
import 'package:lortools/widgets/deck_card_widget.dart';
import 'package:lortools/widgets/tutorial_card_widget.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:url_launcher/url_launcher.dart';

@RoutePage()
class DecksPage extends StatefulWidget {
  const DecksPage({super.key});

  @override
  State<DecksPage> createState() => _DecksPageState();
}

class _DecksPageState extends State<DecksPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey _resetIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey();
  final GlobalKey _searchCardIconKey = GlobalKey();
  final GlobalKey _cardsKey = GlobalKey();
  final GlobalKey _opponentCardsKey = GlobalKey();
  final GlobalKey _predictedCardsKey = GlobalKey();

  final MultiSelectController<String> _championsController =
      MultiSelectController<String>();
  final MultiSelectController<String> _regionsController =
      MultiSelectController<String>();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  TutorialCoachMark? _tutorialCoachMark;

  @override
  void initState() {
    super.initState();

    _loadAllCardsFromAllSets();

    _addFocusListenerToSearchCardText();

    _showTutorial();
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
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Decks'),
        actions: _buildIcons(context),
      ),
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
                  const Spacer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildIcons(BuildContext context) {
    return [
      _buildAppInfoBloc(),
      const SizedBox(width: 4),
      buildGithubIcon(),
      const SizedBox(width: 4),
      _buildDiscordIcon(),
      const SizedBox(width: 4),
      _buildResetIcon(context),
      const SizedBox(width: 4),
      _buildSettingsIcon(context),
      const SizedBox(width: 14),
    ];
  }

  GestureDetector _buildSettingsIcon(BuildContext context) {
    return GestureDetector(
      child: Icon(
        key: _settingsIconKey,
        Icons.settings,
      ),
      onTap: () {
        _scaffoldKey.currentState?.openEndDrawer();
        context.read<SettingsBloc>().add(LoadSettingsEvent());
      },
    );
  }

  GestureDetector _buildResetIcon(BuildContext context) {
    return GestureDetector(
      child: Icon(
        key: _resetIconKey,
        Icons.restart_alt,
      ),
      onTap: () {
        _championsController.clearAllSelection();
        _regionsController.clearAllSelection();
        _searchController.clear();
        context.read<CardsBloc>().add(CardsLoadFromAllSets());
        context.read<OpponentCardsBloc>().add(OpponentCardsClear());
        context.read<PredictedCardsBloc>().add(PredictedCardsClear());
        context.read<DecksBloc>().add(DecksInitialize());
      },
    );
  }

  GestureDetector _buildDiscordIcon() {
    return GestureDetector(
      child: const Icon(
        Icons.discord,
      ),
      onTap: () async {
        final url = Uri.parse('https://discord.gg/757eAnZx4d');

        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
    );
  }

  GestureDetector buildGithubIcon() {
    return GestureDetector(
      child: const FaIcon(
        FontAwesomeIcons.github,
      ),
      onTap: () async {
        final url = Uri.parse('https://github.com/Almis90/lortools');

        if (await canLaunchUrl(url)) {
          await launchUrl(url);
        }
      },
    );
  }

  BlocConsumer<AppBloc, AppState> _buildAppInfoBloc() {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {
        if (state is AppPackageInfoLoadedState) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            title: 'App Version',
            text: 'v${state.version} (${state.buildNumber})',
            widget: _buildCredits(),
          );
        }
      },
      buildWhen: (previous, current) {
        return current is AppInitial;
      },
      builder: (context, state) {
        return GestureDetector(
          onTap: _showInfoDialog,
          child: const Icon(
            Icons.info_outline,
          ),
        );
      },
    );
  }

  void _showInfoDialog() {
    context.read<AppBloc>().add(AppPackageInfoLoadEvent());
  }

  Column _buildCredits() {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Credits',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration: TextDecoration.underline,
              fontSize: 16,
            ),
          ),
        ),
        GestureDetector(
          child: Column(
            children: [
              Container(
                width: 150,
                color: Colors.black,
                child: Image.network(
                    'https://masteringruneterra.com/wp-content/uploads/2022/04/MRLogo-Colored-768x307-1-300x120.png'),
              ),
              const Text(
                'https://masteringruneterra.com',
                style: TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ],
          ),
          onTap: () async {
            final url = Uri.parse('https://masteringruneterra.com');

            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          },
        ),
        const Text('For providing the meta decks.')
      ],
    );
  }

  Widget _buildCardLayoutWithSearch(
      String title, Widget content, List<LorCard> cards) {
    return Expanded(
      key: _cardsKey,
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

  BlocBuilder<SearchCardsBloc, SearchCardsState> _buildCardsSearchIconBloc() {
    return BlocBuilder<SearchCardsBloc, SearchCardsState>(
      builder: (context, state) {
        if (state is SearchCardsInitial) {
          return GestureDetector(
            child: Icon(
              key: _searchCardIconKey,
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
      child: CardWidget(lorCard: card, showCount: showCount),
    );
  }

  Widget _buildOpponentCardsCard() {
    return Expanded(
      key: _opponentCardsKey,
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
      key: _predictedCardsKey,
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

  ListView _buildPredictedCards(PredictedCardsUpdated state) {
    return ListView.builder(
      itemCount: state.cards.length,
      itemBuilder: (context, index) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return CardPredictionWidget(lorCard: state.cards[index]);
          },
        );
      },
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
    return BlocBuilder<CardsBloc, CardsState>(
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
    return BlocBuilder<CardsBloc, CardsState>(
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

  Future<void> _showTutorial() async {
    await Future.delayed(const Duration(seconds: 1));
    _tutorialCoachMark = TutorialCoachMark(
      focusAnimationDuration: const Duration(milliseconds: 400),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      targets: [
        _settingsTargetFocus(),
        _resetIconTargetFocus(),
        _cardsTargetFocus(),
        _searchCardTargetFocus(),
        _opponentCardsTargetFocus(),
        _predictedCardsTargetFocus(),
      ],
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  TargetFocus _settingsTargetFocus() {
    return TargetFocus(
      identify: '_settingsIconKey',
      keyTarget: _settingsIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.next,
                onPrevious: controller.skip,
                nextText: 'Next',
                previousText: 'Skip',
                text: "From here you can change your region, format and more.");
          },
        ),
      ],
    );
  }

  TargetFocus _resetIconTargetFocus() {
    return TargetFocus(
      identify: '_resetIconKey',
      keyTarget: _resetIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.next,
                onPrevious: controller.previous,
                nextText: 'Next',
                previousText: 'Previous',
                text: "Undo everything and start from scratch.");
          },
        ),
      ],
    );
  }

  TargetFocus _cardsTargetFocus() {
    return TargetFocus(
      identify: '_cardsKey',
      keyTarget: _cardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.next,
                onPrevious: controller.previous,
                nextText: 'Next',
                previousText: 'Previous',
                text:
                    "Find opponent cards here and move them to opponent cards.");
          },
        ),
      ],
    );
  }

  TargetFocus _searchCardTargetFocus() {
    return TargetFocus(
      identify: '_searchCardIconKey',
      keyTarget: _searchCardIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.next,
                onPrevious: controller.previous,
                nextText: 'Next',
                previousText: 'Previous',
                text: "Find a card by using its name.");
          },
        ),
      ],
    );
  }

  TargetFocus _opponentCardsTargetFocus() {
    return TargetFocus(
      identify: '_opponentCardsKey',
      keyTarget: _opponentCardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.next,
                onPrevious: controller.previous,
                nextText: 'Next',
                previousText: 'Previous',
                text:
                    "List of confirmed opponent cards that have been played or revealed.");
          },
        ),
      ],
    );
  }

  TargetFocus _predictedCardsTargetFocus() {
    return TargetFocus(
      identify: '_predictedCardsKey',
      keyTarget: _predictedCardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: controller.skip,
                onPrevious: controller.previous,
                nextText: 'Finish',
                previousText: 'Previous',
                text:
                    "List of predicted cards that the opponent might have, there is a separate percentage for each copy of the card.");
          },
        ),
      ],
    );
  }
}
