import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/cities/domain/domain.dart';
import '../../../manager/manager.dart';
import 'city_tile.dart';

class SearchResultsList extends StatelessWidget {
  const SearchResultsList({super.key, required this.query, required this.onCityChosen});

  /// The text typed in the search field.
  final String query;

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
            return _Results(
              results: state.results,
              saved: state.saved,
              query: query,
              onCityChosen: onCityChosen,
            );
        }
      },
    );
  }
}

class _Results extends StatelessWidget {
  const _Results({
    required this.results,
    required this.saved,
    required this.query,
    required this.onCityChosen,
  });

  final List<CityEntity> results;
  final List<CityEntity> saved;
  final String query;
  final VoidCallback onCityChosen;

  Widget _tile(BuildContext context, CityEntity city, {bool best = false, bool last = false}) {
    return CityTile(
      city: city,
      query: query,
      best: best,
      saved: saved.contains(city),
      showDivider: !last,
      onTap: () {
        context.read<CitiesCubit>().choose(city);
        onCityChosen();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final others = results.skip(1).toList();
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      children: [
        _CountLine(count: results.length, query: query),
        _tile(context, results.first, best: true),
        if (others.isNotEmpty) const _SectionLabel('OTHER PLACES'),
        for (var i = 0; i < others.length; i++) _tile(context, others[i], last: i == others.length - 1),
      ],
    );
  }
}

class _CountLine extends StatelessWidget {
  const _CountLine({required this.count, required this.query});
  final int count;
  final String query;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 2, 6, 12),
        child: Text(
          '$count ${count == 1 ? 'result' : 'results'} for “$query”',
          style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: .6)),
        ),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(6, 16, 6, 2),
        child: Text(
          text,
          style: TextStyle(fontSize: 11, letterSpacing: 1, color: Colors.white.withValues(alpha: .5)),
        ),
      );
}

class _Message extends StatelessWidget {
  const _Message(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Center(
        child: Text(text, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white70, fontSize: 15)),
      );
}