import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../manager/manager.dart';
import 'city_tile.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.onCityChosen});

  /// Called after a city is chosen (the screen closes itself here).
  final VoidCallback onCityChosen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        switch (state.searchStatus) {
          case SearchStatus.idle:
            return const _Message('Type at least 2 letters');
          case SearchStatus.loading:
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          case SearchStatus.failure:
            return _Message(state.errorMessage);
          case SearchStatus.success:
            if (state.results.isEmpty) return const _Message('No cities found');
            return ListView.builder(
              itemCount: state.results.length,
              itemBuilder: (context, index) {
                final city = state.results[index];
                return CityTile(
                  city: city,
                  onTap: () {
                    context.read<CitiesCubit>().choose(city);
                    onCityChosen();
                  },
                );
              },
            );
        }
      },
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      );
}
