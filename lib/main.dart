import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  final List<TextEditingController> _clcpControllers =
      List.generate(5, (i) => TextEditingController());

  @override
  void dispose() {
    for (int i = 0; i < _clcpControllers.length; i++) {
      _clcpControllers[i].dispose();
    }
    super.dispose();
  }

  void _submit() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Text(_clcpControllers[1].text),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildCorrectLetterCorrectSpotInputTable(),
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
          children: [
            TableRow(children: [
              _buildLetterInput(_clcpControllers[0]),
              _buildLetterInput(_clcpControllers[1]),
              _buildLetterInput(_clcpControllers[2]),
              _buildLetterInput(_clcpControllers[3]),
              _buildLetterInput(_clcpControllers[4]),
            ]),
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
