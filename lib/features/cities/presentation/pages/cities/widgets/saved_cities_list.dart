import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../manager/manager.dart';
import 'saved_city_card.dart';
import 'swipe_to_delete.dart';

class SavedCitiesList extends StatelessWidget {
  const SavedCitiesList({super.key, required this.onCityChosen});

  /// Called after a city is chosen (the screen closes itself here).
  final VoidCallback onCityChosen;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        final canRemove = state.saved.length > 1;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 24),
          itemCount: state.saved.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _ListHeader(showHint: canRemove);

            final city = state.saved[index - 1];
            final isSelected = city == state.selected;

            // The selected city cannot be removed, so it is not swipeable.
            return SwipeToDelete(
              key: ValueKey('${city.latitude},${city.longitude}'),
              enabled: canRemove && !isSelected,
              onDelete: () => context.read<CitiesCubit>().remove(city),
              child: SavedCityCard(
                city: city,
                weather: state.weather[city],
                selected: isSelected,
                onTap: () {
                  context.read<CitiesCubit>().choose(city);
                  onCityChosen();
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _ListHeader extends StatelessWidget {
  const _ListHeader({required this.showHint});
  final bool showHint;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(26, 0, 26, 8),
    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      const Text('Saved cities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
      if (showHint)
        Text('Swipe left to remove', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55))),
    ]),
  );
}