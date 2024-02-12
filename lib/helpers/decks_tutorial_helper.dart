import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/bloc/decks_tutorial_bloc.dart';
import 'package:lortools/keys.dart';
import 'package:lortools/repositories/decks_tutorial_repository.dart';
import 'package:lortools/widgets/tutorial_card_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DecksTutorialHelper {
  final BuildContext context;
  TutorialCoachMark? _tutorialCoachMark;

  DecksTutorialHelper({required this.context});

  Future<void> showTutorial() async {
    final step = await context.read<DecksTutorialRepository>().getStep();

    await Future.delayed(const Duration(seconds: 1));
    _tutorialCoachMark = TutorialCoachMark(
      focusAnimationDuration: const Duration(milliseconds: 400),
      unFocusAnimationDuration: const Duration(milliseconds: 300),
      onSkip: () {
        context.read<DecksTutorialBloc>().add(DecksTutorialSkipEvent());

        return true;
      },
      initialFocus: step,
      targets: [
        _settingsTargetFocus(),
        _resetIconTargetFocus(),
        _decksTargetFocus(),
        _cardsTargetFocus(),
        _searchCardTargetFocus(),
        _opponentCardsTargetFocus(),
        _predictedCardsTargetFocus(),
        _previewCardsTargetFocus(),
      ],
    );

    if (context.mounted) {
      _tutorialCoachMark?.show(context: context);
    }
  }

  TargetFocus _settingsTargetFocus() {
    return TargetFocus(
      identify: 'settingsIconKey',
      keyTarget: Keys.settingsIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.skip();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialSkipEvent());
                },
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
      identify: 'resetIconKey',
      keyTarget: Keys.resetIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
                nextText: 'Next',
                previousText: 'Previous',
                text: "Undo everything and start from scratch.");
          },
        ),
      ],
    );
  }

  TargetFocus _decksTargetFocus() {
    return TargetFocus(
      identify: 'decksKey',
      keyTarget: Keys.decksKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
                nextText: 'Next',
                previousText: 'Previous',
                text:
                    "Possible decks based on filtering options. The trophy icon is winrate, the play icon is playrate and the people icon is total matches. Long press/click or right click to copy the deck to clipboard.");
          },
        ),
      ],
    );
  }

  TargetFocus _cardsTargetFocus() {
    return TargetFocus(
      identify: 'cardsKey',
      keyTarget: Keys.cardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
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
      identify: 'searchCardIconKey',
      keyTarget: Keys.searchCardIconKey,
      contents: [
        TargetContent(
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
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
      identify: 'opponentCardsKey',
      keyTarget: Keys.opponentCardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
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
      identify: 'predictedCardsKey',
      keyTarget: Keys.predictedCardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.next();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialNextEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
                nextText: 'Next',
                previousText: 'Previous',
                text:
                    "List of predicted cards that the opponent might have, there is a separate percentage for each copy of the card.");
          },
        ),
      ],
    );
  }

  TargetFocus _previewCardsTargetFocus() {
    return TargetFocus(
      identify: 'previewCardsTargetFocus',
      keyTarget: Keys.previewCardsKey,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return TutorialCardWidget(
                onNext: () {
                  controller.skip();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialFinishEvent());
                },
                onPrevious: () {
                  controller.previous();
                  context
                      .read<DecksTutorialBloc>()
                      .add(DecksTutorialPreviousEvent());
                },
                nextText: 'Finish',
                previousText: 'Previous',
                text:
                    "Long press or right-click on a card and it will appear here.");
          },
        ),
      ],
    );
  }
}
