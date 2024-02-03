import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/painting.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgeb_bet/adminPage/screens/AttachmentPage.dart';
import 'package:mezgeb_bet/adminPage/screens/LetterManagementPage.dart';
import 'package:mezgeb_bet/backEndFunctionality/Letter.dart';
import 'package:mezgeb_bet/common/AppColor.dart';
import 'package:flutter/widgets.dart';
import 'package:data_table_2/data_table_2.dart';

import 'dart:io';

class OutgoingLetter extends StatefulWidget {
  const OutgoingLetter({super.key});

  @override
  State<OutgoingLetter> createState() => _OutgoingLetterState();
}

class _OutgoingLetterState extends State<OutgoingLetter> with ChangeNotifier {
  late String myAccessToken;
  List<Letter> letters = [];

  int rowsPerPage = 15;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    fetchLetters();
  }

  @override
  Widget build(BuildContext context) {
    List<DataRow> currentRows =
    _buildRows().skip(currentPage * rowsPerPage).take(rowsPerPage).toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('OutGoing Letter', style: TextStyle(fontSize: 20)),
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft),
            onPressed: Navigator.of(context).pop,
          ),
          elevation: 8,
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25.0),
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 20,
                  columns: _buildColumns(),
                  rows: currentRows,
                  headingRowColor: MaterialStateProperty.all(AppColor.yellow),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: currentPage > 0 ? () => _changePage(-1) : null,
                    child: Text('Previous'),
                  ),
                  TextButton(
                    onPressed: currentRows.length == rowsPerPage
                        ? () => _changePage(1)
                        : null,
                    child: Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('Reference Number')),
      DataColumn(label: Text('Date')),
      DataColumn(label: Text('Subject')),
      DataColumn(label: Text('Urgency')),
      DataColumn(label: Text('Attachments')),
      DataColumn(label: Text('Created By')),
      DataColumn(label: Text('Comments')),
    ];
  }

  List<DataRow> _buildRows() {
    return letters.map((letter) {
      return DataRow(
        color: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
            if (states.contains(MaterialState.selected)) {
              return AppColor.black;
            } else {
              return AppColor.black;
            }
          },
        ),
        cells: [
          DataCell(Text(letter.referenceNumber)),
          DataCell(Text(letter.date.toString())),
          DataCell(Text(letter.senderName)),
          DataCell(Text(letter.urgency)),
          DataCell(Text(letter.attachments.name)),
          DataCell(Text(letter.createdBy)),
          DataCell(Text(letter.comments)),
        ],
        onSelectChanged: (selected) {
          if (selected != null && selected) {
            _navigateToAttachmentPage(letter);
          }
        },
      );
    }).toList();
  }

  void _navigateToAttachmentPage(Letter letter) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AttachmentPage(),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
    );
  }


  void _changePage(int delta) {
    setState(() {
      currentPage += delta;
    });
  }

  Future<void> fetchLetters() async {
    // ... API call to fetch letters
    notifyListeners(); // Notify listeners after fetching
  }
}