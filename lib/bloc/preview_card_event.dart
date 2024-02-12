part of 'preview_card_bloc.dart';

@immutable
sealed class PreviewCardEvent {}

class PreviewCardSelectEvent extends PreviewCardEvent {
  final LorCard card;

  PreviewCardSelectEvent({required this.card});
}

class PreviewCardClearEvent extends PreviewCardEvent {}
