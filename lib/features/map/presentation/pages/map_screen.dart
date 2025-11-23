import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:maps_app/features/map/presentation/cubit/map_cubit.dart';
import 'package:maps_app/features/map/presentation/cubit/map_state.dart';
import 'package:maps_app/features/map/presentation/widgets/map_widget.dart';
import 'package:maps_app/features/map/presentation/widgets/poi_bottom_sheet.dart';
import 'package:maps_app/features/map/presentation/widgets/zoom_controls.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MapCubit, MapState>(
      builder: (BuildContext context, MapState state) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Nearby Points & Routes'),
          ),
          body: Stack(
            children: <Widget>[
              MapWidget(state: state),
              Positioned(
                right: 16,
                top: 16,
                child: ZoomControls(
                  onZoomIn: () {
                    context.read<MapCubit>().zoomIn();
                  },
                  onZoomOut: () {
                    context.read<MapCubit>().zoomOut();
                  },
                  onMyLocation: () {
                    context.read<MapCubit>().zoomToUserLocation();
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: PoiBottomSheet(
                  state: state,
                  onBuildRoute: () {
                    context.read<MapCubit>().buildRoute();
                  },
                  onClearRoute: () {
                    context.read<MapCubit>().clearRoute();
                  },
                ),
              ),
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (state.errorMessage != null &&
                  state.errorMessage!.isNotEmpty)
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 120,
                  child: Material(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 4,
                    shadowColor: Colors.black26,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              state.errorMessage!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onErrorContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}