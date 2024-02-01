import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/auto_router.dart';
import 'package:lortools/bloc/assets_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/bloc/search_cards_bloc.dart';
import 'package:lortools/bloc/cards_bloc.dart';
import 'package:lortools/bloc/settings_bloc.dart';
import 'package:lortools/firebase_options.dart';
import 'package:lortools/repositories/decks_repository.dart';
import 'package:lortools/repositories/cards_repository.dart';
import 'package:lortools/repositories/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DecksRepository>(
          create: (context) => DecksRepository(),
        ),
        RepositoryProvider<CardsRepository>(
          create: (context) => CardsRepository(),
        ),
        RepositoryProvider<SettingsRepository>(
          create: (context) => SettingsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AssetsBloc>(
            create: (context) => AssetsBloc(
              RepositoryProvider.of<CardsRepository>(context),
              RepositoryProvider.of<DecksRepository>(context),
            ),
          ),
          BlocProvider<CardsBloc>(
            create: (context) => CardsBloc(
              RepositoryProvider.of<CardsRepository>(context),
            ),
          ),
          BlocProvider<DecksBloc>(
            create: (context) => DecksBloc(
              RepositoryProvider.of<DecksRepository>(context),
              BlocProvider.of<CardsBloc>(context),
            ),
          ),
          BlocProvider<OpponentCardsBloc>(
            create: (context) => OpponentCardsBloc(),
          ),
          BlocProvider<PredictedCardsBloc>(
            create: (context) => PredictedCardsBloc(
              BlocProvider.of<DecksBloc>(context),
            ),
          ),
          BlocProvider<SearchCardsBloc>(
            create: (context) => SearchCardsBloc(),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              settingsRepository:
                  RepositoryProvider.of<SettingsRepository>(context),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          routerConfig: _appRouter.config(),
        ),
      ),
    );
  }
}
