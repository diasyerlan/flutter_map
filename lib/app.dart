import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/features/map/data/poi_repo.dart';
import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/pages/map_screen.dart';

class NearbyPointsApp extends StatelessWidget {
  const NearbyPointsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Points & Routes',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: BlocProvider(
        create: (_) => MapCubit(
          poiRepository: PoiRepository(),
        )..init(),
        child: const MapScreen(),
      ),
    );
  }
}