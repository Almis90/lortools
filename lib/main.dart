import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/auto_router.dart';
import 'package:lortools/bloc/assets_bloc.dart';
import 'package:lortools/bloc/decks_bloc.dart';
import 'package:lortools/bloc/opponent_cards_bloc.dart';
import 'package:lortools/bloc/predicted_cards_bloc.dart';
import 'package:lortools/bloc/search_cards_bloc.dart';
import 'package:lortools/bloc/sets_bloc.dart';
import 'package:lortools/repositories/decks_repository.dart';
import 'package:lortools/repositories/sets_repository.dart';

void main() {
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
        RepositoryProvider<SetsRepository>(
          create: (context) => SetsRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AssetsBloc>(
            create: (context) => AssetsBloc(
              RepositoryProvider.of<SetsRepository>(context),
              RepositoryProvider.of<DecksRepository>(context),
            ),
          ),
          BlocProvider<SetsBloc>(
            create: (context) => SetsBloc(
              RepositoryProvider.of<SetsRepository>(context),
            ),
          ),
          BlocProvider<DecksBloc>(
            create: (context) => DecksBloc(
              RepositoryProvider.of<DecksRepository>(context),
              BlocProvider.of<SetsBloc>(context),
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
