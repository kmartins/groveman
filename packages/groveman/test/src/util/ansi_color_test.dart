import 'package:groveman/src/util/ansi_color.dart';
import 'package:test/test.dart';

void main() {
  group('AnsiColor', () {
    test(
        'given that foreground is null, '
        'when to format with ansi color, '
        'then expect result is a string without color', () {
      final ansiColor = AnsiColor();
      const message = 'Ansi Color';
      expect(ansiColor(message), message);
    });

    test(
        'given that the foreground is red, '
        'when to format with ansi color, '
        'then expect result is a string with color', () {
      final ansiColor = AnsiColor(foregroundColor: 196);
      const message = 'Ansi Color';
      expect(ansiColor(message), '\x1B[38;5;${196}m$message');
    });

    test(
        'given a number of 0 to 1, '
        'when to generate the foreground grey, '
        'then expect result is a color gray in ansi format', () {
      final ansiColor = AnsiColor.grey(0.5);
      expect(ansiColor, 244);
    });
  });
}
