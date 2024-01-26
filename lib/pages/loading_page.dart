import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lortools/auto_router.gr.dart';
import 'package:lortools/bloc/assets_bloc.dart';

@RoutePage()
class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    _loadAssets();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssetsBloc, AssetsState>(
      listener: (context, state) {
        if (state is AssetsLoaded) {
          context.router.replace(const DecksRoute());
        }
      },
      builder: (context, state) {
        if (state is AssetsLoaded) {
          return const Text('Downloaded');
        } else {
          return const Text('Downloading');
        }
      },
    );
  }

  void _loadAssets() {
    context.read<AssetsBloc>().add(AssetsLoad());
  }
}
