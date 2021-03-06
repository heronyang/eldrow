import 'dictionary.dart';

class PositionLetter {
  final int position;
  final String letter;
  const PositionLetter(this.position, this.letter);
}

List<String> solve(
    Dictionary dictionary,
    List<PositionLetter> correctLetterCorrectSpot,
    List<PositionLetter> correctLetterIncorrectSpot,
    List<String> incorrectLetter) {
  List<String> answers = [];
  for (var i = 0; i < dictionary.getWords().length; i++) {
    String candidate = dictionary.getWords()[i];

    bool correctCandidate = true;

    // Case: correct letter correct spot.
    for (var j = 0; j < correctLetterCorrectSpot.length; j++) {
      var pl = correctLetterCorrectSpot[j];
      if (candidate[pl.position] != pl.letter) {
        correctCandidate = false;
        break;
      }
    }

    if (!correctCandidate) {
      continue;
    }

    // Case: correct letter incorrect spot.
    for (var j = 0; j < correctLetterIncorrectSpot.length; j++) {
      var pl = correctLetterIncorrectSpot[j];
      if (!(candidate.contains(pl.letter) &&
          candidate[pl.position] != pl.letter)) {
        correctCandidate = false;
        break;
      }
    }

    if (!correctCandidate) {
      continue;
    }

    // Case: incorrect letter.
    for (var j = 0; j < incorrectLetter.length; j++) {
      if (candidate.contains(incorrectLetter[j])) {
        correctCandidate = false;
        break;
      }
    }

    if (correctCandidate) {
      answers.add(candidate);
    }
  }
  return answers;
}
