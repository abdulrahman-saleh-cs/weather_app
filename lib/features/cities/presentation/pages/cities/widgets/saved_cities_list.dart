import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/core.dart';
import '../../../manager/manager.dart';
import 'saved_city_card.dart';

class SavedCitiesList extends StatelessWidget {
  const SavedCitiesList({super.key, required this.onCityChosen});

  /// Called after a city is chosen (the screen closes itself here).
  final VoidCallback onCityChosen;

  /// Room around every card. It lives INSIDE the Dismissible, because a
  /// Dismissible clips to its own box: without this room the card shadow is
  /// cut off, and a swiped card vanishes before reaching the screen edge.
  static const _slotPadding = EdgeInsets.fromLTRB(AppDimensions.p20, 6, AppDimensions.p20, 12);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      builder: (context, state) {
        final canRemove = state.saved.length > 1;
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 20),
          itemCount: state.saved.length + 1,
          itemBuilder: (context, index) {
            if (index == 0) return _ListHeader(showHint: canRemove);

            final city = state.saved[index - 1];
            final isSelected = city == state.selected;
            final card = Padding(
              padding: _slotPadding,
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

            // The selected city cannot be swiped away.
            if (isSelected || !canRemove) return card;

            return Dismissible(
              key: ValueKey('${city.latitude},${city.longitude}'),
              direction: DismissDirection.endToStart,
              background: const Padding(
                padding: _slotPadding,
                child: _DeleteBackground(),
              ),
              onDismissed: (_) => context.read<CitiesCubit>().remove(city),
              child: card,
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
        padding: const EdgeInsets.fromLTRB(26, 0, 26, 4),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text('Saved cities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          if (showHint)
            Text('Swipe left to remove', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: .55))),
        ]),
      );
}

class _DeleteBackground extends StatelessWidget {
  const _DeleteBackground();

  @override
  Widget build(BuildContext context) => Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFE5484D),
          borderRadius: BorderRadius.circular(26),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      );
}