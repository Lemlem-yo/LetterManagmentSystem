import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mezgeb_bet/adminPage/screens/AttachmentPage.dart';
import 'package:mezgeb_bet/backEndFunctionality/CollactionFunction.dart';
import 'package:mezgeb_bet/backEndFunctionality/Letter.dart';
import 'package:mezgeb_bet/common/AppColor.dart';
import 'package:http/http.dart' as http;
import 'package:mezgeb_bet/login_authetication_pages/accessToken.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
class LetterManagementPage extends StatefulWidget {
  @override
  _LetterManagementPageState createState() => _LetterManagementPageState();
}

class _LetterManagementPageState extends State<LetterManagementPage> {
  late String myAccessToken;
  DateTime? selectedDate;
  List<Letter> letters = [];
  final TextEditingController referenceNumber = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController organizationController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController urgencyController = TextEditingController();
  final TextEditingController contentSummaryController = TextEditingController();
  final TextEditingController attachmentsController = TextEditingController();
  final TextEditingController assignedToController = TextEditingController();
  final TextEditingController createdByController = TextEditingController();
  final TextEditingController commentsController = TextEditingController();
  CollectionFunction collectionFunction = CollectionFunction();
  File? attachment;

  Object? get data => null;

  @override
  void initState() {
    super.initState();
    myAccessToken = Provider.of<AccessTokenProvider>(context, listen: false).accessToken ?? '';
    _loadData();
  }


  int rowsPerPage = 15;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    List<DataRow> currentRows = _buildRows()
        .skip(currentPage * rowsPerPage)
        .take(rowsPerPage)
        .toList();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Letter Management System', style: TextStyle(fontSize: 20)),
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.search, color: Colors.black),
                          ),
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                // Call the fetch data function when the text changes
                                collectionFunction.fetchData(searchQuery: value);
                                setState(() {}); // Redraw the widget to reflect the search results
                              },
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  CircleAvatar(
                    backgroundColor: AppColor.yellow,
                    child: IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () => _showForm(context),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
      DataColumn(label: Text('Sender Name')),
      DataColumn(label: Text('Organization')),
      DataColumn(label: Text('Subject')),
      DataColumn(label: Text('Urgency')),
      DataColumn(label: Text('Content Summary')),
      DataColumn(label: Text('AttachmentName')),
      DataColumn(label: Text('Assigned To')),
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
              return AppColor.white;
            } else {
              return AppColor.white;
            }
          },
        ),
        cells: [
          DataCell(Text(letter.referenceNumber)),
          DataCell(Text(letter.date.toString())),
          DataCell(Text(letter.senderName)),
          DataCell(Text(letter.organization)),
          DataCell(Text(letter.subject)),
          DataCell(Text(letter.urgency)),
          DataCell(Text(letter.contentSummary)),
          DataCell(Text(letter.attachments.name)),
          DataCell(Text(letter.assignedTo)),
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

  Future<void> _showForm(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Letter'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField('Date'),
                _buildTextField('Reference Number'),
                _buildTextField('Sender Name'),
                _buildTextField('Organization'),
                _buildTextField('Subject'),
                _buildTextField('Urgency'),
                _buildTextField('Content Summary'),
                _buildAttachmentField(),
                _buildTextField('Assigned To'),
                _buildTextField('Comments'),
                _buildTextField('Created By')
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _submitForm(context);
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dateController.text = DateFormat('MM/dd/yyyy').format(pickedDate);
      });
    }
  }

  Widget _buildTextField(String label) {
    TextEditingController controller;

    if (label == 'Date') {
      controller = dateController;
      return TextField(
        controller: controller,
        readOnly: true,
        onTap: () => _selectDate(context),
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(context),
          ),
        ),
      );
    } else if (label == 'Reference Number') {
      controller = referenceNumber;
    } else if (label == 'Sender Name') {
      controller = senderNameController;
    } else if (label == 'Organization') {
      controller = organizationController;
    } else if (label == 'Subject') {
      controller = subjectController;
    } else if (label == 'Urgency') {
      controller = urgencyController;
    } else if (label == 'Content Summary') {
      controller = contentSummaryController;
    } else if (label == 'Assigned To') {
      controller = assignedToController;
    } else if (label == 'Comments') {
      controller = commentsController;
    } else if (label == 'Created By'){
      controller = createdByController;
    }
    else {
      // Handle other cases or set a default controller
      controller = TextEditingController();
    }

    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
      ),
    );
  }

  Widget _buildAttachmentField() {
    return ElevatedButton(
      onPressed: () => _pickAttachment(context),
      child: Text('Attachment'),
    );
  }
  //

  Future<void> _pickAttachment(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);

      setState(() {
        attachment = file;
      });
    }
  }
  //


  Future<Uint8List> _readFile(File file) async {
    try {
      Uint8List bytes = await file.readAsBytes();
      return bytes;
    } catch (e) {
      print('Error reading file: $e');
      return Uint8List(0);
    }
  }

  Future<void> _submitForm(BuildContext context) async {
    if (_validateForm()) {
      try {
        DateTime parsedDate =
        DateFormat('MM/dd/yyyy').parse(dateController.text);

        Attachment newAttachment = Attachment(
          name: attachment != null ? attachment!.path.split('/').last : '',
          content: attachment != null ? await _readFile(attachment!) : Uint8List(0),
        );

        Letter newLetter = Letter(
          referenceNumber: referenceNumber.text,
          date: parsedDate,
          senderName: senderNameController.text,
          organization: organizationController.text,
          subject: subjectController.text,
          urgency: urgencyController.text,
          contentSummary: contentSummaryController.text,
          attachments: newAttachment,
          assignedTo: assignedToController.text,
          createdBy: createdByController.text,
          comments: commentsController.text,
        );
        print(newLetter);
        print('Reference Number: ${newLetter.referenceNumber}');
        await _sendLetterDataToNextJsApi(newLetter);
        await _loadData();

        _clearControllers();
        Navigator.of(context).pop();
      } catch (e) {
        print('Error parsing date: $e');
      }
    } else {
      _showErrorDialog(context);
    }
  }

  Future<void> _sendLetterDataToNextJsApi(Letter newLetter) async {
    try {
      // Create a multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.100.195:3000/letters'),
      );

      // Set Content-Type header to 'application/json'
      request.headers['Authorization'] = 'Bearer $myAccessToken';
      request.headers['Content-Type'] = 'application/json'; // Add this line

      // Include required fields, such as 'referenceNumber'
      Map<String, dynamic> letterMap = newLetter.toMap();

      // Check if referenceNumber is present
      if (!letterMap.containsKey('referenceNumber')) {
        print('Error: Reference number is missing in the letter data.');
        return; // Stop further processing if reference number is missing
      }

      request.fields['data'] = jsonEncode(letterMap);

      // Add file attachment
      if (newLetter.attachments != null && newLetter.attachments.content.isNotEmpty) {
        try {
          request.files.add(http.MultipartFile.fromBytes(
            'attachments',
            newLetter.attachments.content.buffer.asUint8List(),
            filename: newLetter.attachments.name,
            contentType: MediaType('application', 'octet-stream'),
          ));
        } catch (e) {
          print('Error adding file attachment: $e');
        }
      }

      // Send the request
      var response = await request.send();

      if (response.statusCode != 201) {
        print('Encoded JSON: ${jsonEncode(letterMap)}');
        print('Failed to add letter. Status code: ${response.statusCode}');
      } else {
        print('Letter successfully sent.');
      }
    } catch (e) {
      print('Error sending letter data: $e');
    }
  }



  //
  // Future<void> _sendLetterDataToNextJsApi(Letter newLetter) async {
  //   try {
  //     // Create a multipart request
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse('http://192.168.100.195:3000/letters'),
  //     );
  //
  //     // Add JSON data
  //     request.headers['Authorization'] = 'Bearer $myAccessToken';
  //     request.fields['data'] = jsonEncode(newLetter.toMap());
  //
  //     // Add file attachment
  //     if (newLetter.attachments.content.isNotEmpty) {
  //       try {
  //         request.files.add(http.MultipartFile.fromBytes(
  //           'attachments',
  //           newLetter.attachments.content.buffer.asUint8List(),
  //           //newLetter.attachments.content,
  //           filename: newLetter.attachments.name,
  //           contentType: MediaType('application', 'octet-stream'), // Set content type based on the actual file type
  //         ));
  //       } catch (e) {
  //         print('Error adding file attachment: $e');
  //       }
  //     }
  //
  //     // Send the request
  //     var response = await request.send();
  //
  //     if (response.statusCode != 201) {
  //       print('Failed to add letter. Status code: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     print('Error sending letter data: $e');
  //   }
  // }

  Future<void> _loadData() async {
    try {
      final dataLetter = Uri.parse("http://192.168.100.195:3000/letters/admin/all");

      final response = await http.get(
        dataLetter,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $myAccessToken',
        },
      );

      if (response.statusCode == 200) {
        List<Map<String, dynamic>> data = (jsonDecode(response.body) as List).cast<Map<String, dynamic>>();

        // Print the raw response body
        print('Raw Response Body: ${response.body}');

        // Handle null values in the data
        List<Letter> loadedLetters = [];
        setState(() {
          letters = loadedLetters;
        });
        print('Data: $dataLetter');
        for (var item in data) {
          if (item != null &&
              item['referenceNumber'] != null &&
              item['date'] != null) {
            // Print individual item for debugging
            print('Item: $item');

            String attachments = item['attachments'] != null ? (item['attachments'] is String ? item['attachments'] as String : '') : '';
            String attachmentName = item['attachmentName'] != null ? (item['attachmentName'] is String ? item['attachmentName'] as String : '') : '';

            loadedLetters.add(
              Letter.fromMap(
                item..['attachments'] = attachments..['attachmentName'] = attachmentName,
              ),
            );
          }
        }

        setState(() {
          letters = loadedLetters;
        });
      } else {
        print('Failed to fetch letters. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching letters: $e');
    }
  }


  bool _validateForm() {
    return referenceNumber.text.isNotEmpty &&
        assignedToController.text.isNotEmpty &&
        commentsController.text.isNotEmpty;
  }

  void _showErrorDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Please fill in all required fields.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  void _clearControllers() {
    dateController.clear();
    senderNameController.clear();
    organizationController.clear();
    subjectController.clear();
    urgencyController.clear();
    contentSummaryController.clear();
    attachmentsController.clear();
    assignedToController.clear();
    commentsController.clear();
    createdByController.clear();
  }

  Future<void> _fetchData({String? searchQuery}) async {
    await collectionFunction.fetchData(searchQuery: searchQuery);
    setState(() {
      letters = collectionFunction.letters;
    });
  }

  void _changePage(int delta) {
    setState(() {
      currentPage += delta;
    });
  }
}


// {
// "referenceNumber": "123",
// "date": "2024-01-31T12:00:00.000Z",
// "attachments": {
// "name": "file.pdf",
// "content": "base64-encoded-content"
// },

