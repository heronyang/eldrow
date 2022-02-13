import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dictionary.dart';
import 'wordle_solver.dart';

void main() {
  runApp(const Eldrow());
}

class Eldrow extends StatelessWidget {
  const Eldrow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ELDROW - Wordle Solver',
      home: const MainPage(title: 'ELDROW'),
      theme: new ThemeData(
        primarySwatch: Colors.grey,
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            ),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<TextEditingController> _greenControllers =
      List.generate(5, (i) => TextEditingController());

  // Dimension: position -> guess #.
  final List<List<TextEditingController>> _yellowControllers =
      List.generate(5, (i) => List.generate(4, (j) => TextEditingController()));

  final List<TextEditingController> _greyControllers =
      List.generate(20, (i) => TextEditingController());

  var _dictionary = Dictionary();

  String _message = "Loading...";
  String _answer = "...";

  @override
  void dispose() {
    for (int i = 0; i < _greenControllers.length; i++) {
      _greenControllers[i].dispose();
    }
    for (int i = 0; i < _yellowControllers.length; i++) {
      for (int j = 0; j < _yellowControllers[i].length; j++) {
        _yellowControllers[i][j].dispose();
      }
    }
    for (int i = 0; i < _greyControllers.length; i++) {
      _greyControllers[i].dispose();
    }
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    _dictionary.init().then((result) {
      setState(() {
        _message = result;
      });
    });
  }

  void _submit() {
    setState(() {
      _answer = _solve();
    });
  }

  String _solve() {
    List<PositionLetter> correctLetterCorrectPosition = [];
    for (int i = 0; i < _greenControllers.length; i++) {
      if (_greenControllers[i].text != "") {
        correctLetterCorrectPosition
            .add(PositionLetter(i, _greenControllers[i].text));
      }
    }

    List<PositionLetter> correctLetterIncorrectPosition = [];
    for (int i = 0; i < _yellowControllers.length; i++) {
      for (int guess = 0; guess < _yellowControllers[i].length; guess++) {
        String letter = _yellowControllers[i][guess].text;
        if (letter != "") {
          correctLetterIncorrectPosition.add(PositionLetter(i, letter));
        }
      }
    }

    List<String> incorrectLetter = [];
    for (int i = 0; i < _greyControllers.length; i++) {
      if (_greyControllers[i].text != "") {
        incorrectLetter.add(_greyControllers[i].text);
      }
    }

    List<String> answers = solve(_dictionary, correctLetterCorrectPosition,
        correctLetterIncorrectPosition, incorrectLetter);
    if (answers.length == 0) {
      return "No Answer Found.";
    }
    return answers.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
          child: Column(children: [
        SizedBox(height: 20),
        Text(
          '$_message',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 20),
        Text('Position Matters'),
        _buildCorrectLetterCorrectPositionInputTable(),
        SizedBox(height: 20),
        _buildCorrectLetterIncorrectPositionInputTable(),
        SizedBox(height: 20),
        Text('Position Doesn\'t Matter'),
        _buildIncorrectLetterInputTable(),
        SizedBox(height: 20),
        Text('Answer'),
        Text('$_answer'),
      ])),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        tooltip: 'Submit',
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildCorrectLetterCorrectPositionInputTable() {
    return Container(
        color: Color(0xff538d4e),
        child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(children: [
              _buildLetterInput(_greenControllers[0]),
              _buildLetterInput(_greenControllers[1]),
              _buildLetterInput(_greenControllers[2]),
              _buildLetterInput(_greenControllers[3]),
              _buildLetterInput(_greenControllers[4]),
            ]),
          ],
        ));
  }

  Widget _buildCorrectLetterIncorrectPositionInputTable() {
    return Container(
        color: Color(0xffb59f3b),
        child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: [
                _buildLetterInput(_yellowControllers[0][0]),
                _buildLetterInput(_yellowControllers[1][0]),
                _buildLetterInput(_yellowControllers[2][0]),
                _buildLetterInput(_yellowControllers[3][0]),
                _buildLetterInput(_yellowControllers[4][0]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_yellowControllers[0][1]),
                _buildLetterInput(_yellowControllers[1][1]),
                _buildLetterInput(_yellowControllers[2][1]),
                _buildLetterInput(_yellowControllers[3][1]),
                _buildLetterInput(_yellowControllers[4][1]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_yellowControllers[0][2]),
                _buildLetterInput(_yellowControllers[1][2]),
                _buildLetterInput(_yellowControllers[2][2]),
                _buildLetterInput(_yellowControllers[3][2]),
                _buildLetterInput(_yellowControllers[4][2]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_yellowControllers[0][3]),
                _buildLetterInput(_yellowControllers[1][3]),
                _buildLetterInput(_yellowControllers[2][3]),
                _buildLetterInput(_yellowControllers[3][3]),
                _buildLetterInput(_yellowControllers[4][3]),
              ],
            ),
          ],
        ));
  }

  Widget _buildIncorrectLetterInputTable() {
    return Container(
        color: Color(0xff3a3a3c),
        child: Table(
          border: TableBorder.all(),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: <TableRow>[
            TableRow(
              children: [
                _buildLetterInput(_greyControllers[0]),
                _buildLetterInput(_greyControllers[1]),
                _buildLetterInput(_greyControllers[2]),
                _buildLetterInput(_greyControllers[3]),
                _buildLetterInput(_greyControllers[4]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_greyControllers[5]),
                _buildLetterInput(_greyControllers[6]),
                _buildLetterInput(_greyControllers[7]),
                _buildLetterInput(_greyControllers[8]),
                _buildLetterInput(_greyControllers[9]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_greyControllers[10]),
                _buildLetterInput(_greyControllers[11]),
                _buildLetterInput(_greyControllers[12]),
                _buildLetterInput(_greyControllers[13]),
                _buildLetterInput(_greyControllers[14]),
              ],
            ),
            TableRow(
              children: [
                _buildLetterInput(_greyControllers[15]),
                _buildLetterInput(_greyControllers[16]),
                _buildLetterInput(_greyControllers[17]),
                _buildLetterInput(_greyControllers[18]),
                _buildLetterInput(_greyControllers[19]),
              ],
            ),
          ],
        ));
  }

  Widget _buildLetterInput(TextEditingController controller) {
    return TextField(
      autocorrect: false,
      controller: controller,
      decoration: const InputDecoration(
        hintText: '_',
      ),
      inputFormatters: [
        LengthLimitingTextInputFormatter(1),
        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
        UpperCaseTextFormatter(),
      ],
      keyboardType: TextInputType.text,
      textAlign: TextAlign.center,
      textCapitalization: TextCapitalization.characters,
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
