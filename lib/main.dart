import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dictionary.dart';

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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Text(_solve()),
        );
      },
    );
  }

  String _solve() {
    return "answer....";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      backgroundColor: Colors.black,
      body: Column(children: [
        SizedBox(height: 20),
        Text(
          '$_message',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
        SizedBox(height: 20),
        Text('Position Matters'),
        _buildCorrectLetterCorrectSpotInputTable(),
        SizedBox(height: 20),
        _buildCorrectLetterIncorrectSpotInputTable(),
        SizedBox(height: 20),
        Text('Position Doesn\'t Matter'),
        _buildIncorrectLetterInputTable(),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: _submit,
        tooltip: 'Submit',
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget _buildCorrectLetterCorrectSpotInputTable() {
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

  Widget _buildCorrectLetterIncorrectSpotInputTable() {
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
        controller: controller,
        decoration: const InputDecoration(
          hintText: '_',
        ),
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.allow(RegExp("[A-Z]"))
        ]);
  }
}
