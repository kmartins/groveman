/// This class handles colorizing of terminal output.
/// Colors and styles are taken from:
/// https://en.wikipedia.org/wiki/ANSI_escape_code
class AnsiColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  final String ansiEsc = '\x1B[';

  /// The foreground color.
  final int? foregroundColor;

  /// Creates a new [AnsiColor].
  AnsiColor({this.foregroundColor});

  @override
  String toString() {
    final StringBuffer sb = StringBuffer();

    if (foregroundColor != null) {
      sb.write('${ansiEsc}38;5;${foregroundColor}m');
    }

    return sb.toString();
  }

  /// Colorizes the given message.
  String call(String msg) => '$this$msg';

  /// Returns a grey color.
  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
