import 'package:flutter/material.dart';
import 'package:weather_app/core/core.dart';

class CitySearchField extends StatelessWidget {
  const CitySearchField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  static const double _height = 52;
  static const _textStyle = TextStyle(color: Colors.white, fontSize: 16, height: 1.25);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      radius: 99,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: _height,
        child: Row(
          children: [
            const Icon(Icons.search_rounded, color: Colors.white70, size: 22),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                textInputAction: TextInputAction.search,
                cursorColor: Colors.white,
                style: _textStyle,
                // "collapsed" removes all built-in padding, so the text is
                // centred by the Row and lines up with the icons.
                decoration: const InputDecoration.collapsed(
                  hintText: 'Search city',
                  hintStyle: TextStyle(color: Colors.white54, fontSize: 16, height: 1.25),
                ),
              ),
            ),
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controller,
              builder: (_, value, _) => value.text.isEmpty
                  ? const SizedBox(width: 8)
                  : GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClear,
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.close_rounded, color: Colors.white70, size: 20),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}