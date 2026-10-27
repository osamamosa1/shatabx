import 'dart:developer' as developer;

abstract class Log {
  static void d(String message) => developer.log(message, name: 'ShatabX');

  static void i(String message) =>
      developer.log(message, name: 'ShatabX', level: 800);

  static void e(String message) =>
      developer.log(message, name: 'ShatabX', level: 1000);
}
