part of 'preview_card_bloc.dart';

@immutable
sealed class PreviewCardState {}

final class PreviewCardInitialState extends PreviewCardState {}

final class PreviewCardSelectedState extends PreviewCardState {
  final LorCard card;

  PreviewCardSelectedState({required this.card});
}
