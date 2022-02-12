import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Dictionary {
  static List<String> words = [];

  Future<String> init() async {
    words =
        LineSplitter().convert(await rootBundle.loadString('dictionary.txt'));
    return "Loaded dictionary with size ${words.length}.";
  }

  List<String> getWords() {
    return words;
  }
}
