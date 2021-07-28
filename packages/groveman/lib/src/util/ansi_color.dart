/// This class handles colorizing of terminal output.
/// Colors and styles are taken from:
/// https://en.wikipedia.org/wiki/ANSI_escape_code
class AnsiColor {
  /// ANSI Control Sequence Introducer, signals the terminal for new settings.
  final String ansiEsc = '\x1B[';

  final int? foregroundColor;

  AnsiColor({this.foregroundColor});

  @override
  String toString() {
    final StringBuffer _sb = StringBuffer();

    if (foregroundColor != null) {
      _sb.write('${ansiEsc}38;5;${foregroundColor}m');
    }

    return _sb.toString();
  }

  String call(String msg) => '${this}$msg';

  static int grey(double level) => 232 + (level.clamp(0.0, 1.0) * 23).round();
}
