import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/core/core.dart';
import '../../manager/manager.dart';
import 'widgets/widgets.dart';

class CitiesView extends StatelessWidget {
  const CitiesView({super.key});

  /// Opens the screen using the [CitiesCubit] of the calling screen.
  static Future<void> open(BuildContext context) {
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => BlocProvider.value(
          value: context.read<CitiesCubit>(),
          child: const CitiesView(),
        ),
      ),
    );
  }

  static const double _maxContentWidth = 560;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        AnimatedWeatherBackground(theme: themeFor(WeatherCondition.clear, DayPhase.night)),
         SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: _maxContentWidth),
              child: _CitiesContent(),
            ),
          ),
        ),
      ]),
    );
  }
}

class _CitiesContent extends StatefulWidget {
  const _CitiesContent();

  @override
  State<_CitiesContent> createState() => _CitiesContentState();
}

class _CitiesContentState extends State<_CitiesContent> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Refresh the temperatures on the cards every time the screen opens.
    context.read<CitiesCubit>().loadWeather();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() => Navigator.of(context).pop();

  void _clear() {
    _controller.clear();
    context.read<CitiesCubit>().search('');
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        spacing: AppDimensions.p16,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
            child: _TopBar(onBack: _close),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.p20),
            child: CitySearchField(
              controller: _controller,
              onChanged: context.read<CitiesCubit>().search,
              onClear: _clear,
            ),
          ),
          Expanded(
            child: ValueListenableBuilder<TextEditingValue>(
              valueListenable: _controller,
              builder: (_, value, _) => value.text.trim().isEmpty
                  ? SavedCitiesList(onCityChosen: _close)
                  : SearchResultsList(onCityChosen: _close),
            ),
          ),
        ],
      ),
    );
  }
}
class _TopBar extends StatelessWidget {
  const _TopBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(children: [
        GestureDetector(
          onTap: onBack,
          child: const GlassCard(
            radius: 99,
            padding: EdgeInsets.all(10),
            child: Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 14),
        const Text('Cities', style: AppTextStyles.titleLarge),
      ]);
}
