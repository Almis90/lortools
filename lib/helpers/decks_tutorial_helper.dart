import 'package:flutter/material.dart';
import 'package:lortools/keys.dart';
import 'package:lortools/widgets/tutorial_card_widget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DecksTutorialHelper {
  final BuildContext context;
  TutorialCoachMark? _tutorialCoachMark;

  DecksTutorialHelper({required this.context});

  Future<void> showTutorial() async {
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
      identify: 'settingsIconKey',
      keyTarget: Keys.settingsIconKey,
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
      identify: 'resetIconKey',
      keyTarget: Keys.resetIconKey,
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
      identify: 'cardsKey',
      keyTarget: Keys.cardsKey,
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
      identify: 'searchCardIconKey',
      keyTarget: Keys.searchCardIconKey,
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
      identify: 'opponentCardsKey',
      keyTarget: Keys.opponentCardsKey,
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
      identify: 'predictedCardsKey',
      keyTarget: Keys.predictedCardsKey,
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
