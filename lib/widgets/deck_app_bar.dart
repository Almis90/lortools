import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lortools/bloc/app_bloc.dart';
import 'package:lortools/bloc/cards_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/bloc/preview_card_bloc.dart';
import 'package:lortools/bloc/settings_bloc.dart';
import 'package:lortools/keys.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class DeckAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DeckAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  State<DeckAppBar> createState() => _DeckAppBarState();
}

class _DeckAppBarState extends State<DeckAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Decks'),
      actions: _buildIcons(),
    );
  }

  List<Widget> _buildIcons() {
    return [
      _buildAppInfoBloc(),
      const SizedBox(width: 4),
      buildGithubIcon(),
      const SizedBox(width: 4),
      _buildDiscordIcon(),
      const SizedBox(width: 4),
      _buildResetIcon(),
      const SizedBox(width: 4),
      _buildSettingsIcon(),
      const SizedBox(width: 14),
    ];
  }

  GestureDetector _buildSettingsIcon() {
    return GestureDetector(
      child: Icon(
        key: Keys.settingsIconKey,
        Icons.settings,
      ),
      onTap: () {
        Keys.scaffoldKey.currentState?.openEndDrawer();
        context.read<SettingsBloc>().add(LoadSettingsEvent());
      },
    );
  }

  GestureDetector _buildResetIcon() {
    return GestureDetector(
      child: Icon(
        key: Keys.resetIconKey,
        Icons.restart_alt,
      ),
      onTap: () {
        context.read<CardsBloc>().add(CardsLoadFromAllSets());
        context.read<OpponentCardsBloc>().add(OpponentCardsClear());
        context.read<PredictedCardsBloc>().add(PredictedCardsClear());
        context.read<DecksBloc>().add(DecksInitialize());
        context.read<PreviewCardBloc>().add(PreviewCardClearEvent());
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
        } else {
          if (context.mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text:
                  'Could not open the url, please enter the url manually: $url',
            );
          }
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
        } else {
          if (context.mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              title: 'Error',
              text:
                  'Could not open the url, please enter the url manually: $url',
            );
          }
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
                child: _buildMasteringRuneterraLogo(),
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
            } else {
              if (context.mounted) {
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  title: 'Error',
                  text:
                      'Could not open the url, please enter the url manually: $url',
                  widget: _buildCredits(),
                );
              }
            }
          },
        ),
        const Text('For providing the meta decks.')
      ],
    );
  }

  Widget _buildMasteringRuneterraLogo() {
    const imageUrl =
        'https://masteringruneterra.com/wp-content/uploads/2022/04/MRLogo-Colored-768x307-1-300x120.png';
    const fit = BoxFit.cover;
    const width = double.infinity;
    const height = 50.0;
    const Widget placeholder = CircularProgressIndicator();
    const Widget errorWidget = Icon(Icons.error);

    if (kIsWeb) {
      return Image.network(
        imageUrl,
        fit: fit,
        width: width,
        height: height,
        loadingBuilder: (context, child, loadingProgress) => placeholder,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => placeholder,
      errorWidget: (context, url, error) => errorWidget,
    );
  }
}
