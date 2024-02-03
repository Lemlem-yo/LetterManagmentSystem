import 'package:flutter/material.dart';

import '../common/AppColor.dart';

class StaffMainPage extends StatefulWidget {
  @override
  _StaffMainPageState createState() => _StaffMainPageState();
}

class _StaffMainPageState extends State<StaffMainPage> {
  int _currentIndex = 0;
  List<Staff> staffList = []; // Your staff data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mezgeb Bet'),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Handle notification button press
            },
          ),
        ],
      ),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildFilesTab();
      case 1:
        return _buildRepliesTab();
      case 2:
        return _buildNotificationTab();
      case 3:
        return _buildOutgoingFilesTab();
      default:
        return Container();
    }
  }

  Widget _buildFilesTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
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
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: _buildColumns(),
              rows: _buildRows(),
              headingRowColor: MaterialStateProperty.all(AppColor.yellow),
            ),
          ),
        ),
      ],
    );
  }

  List<DataColumn> _buildColumns() {
    return [
      DataColumn(label: Text('Staff ID')),
      DataColumn(label: Text('Name')),
      DataColumn(label: Text('Department')),
      DataColumn(label: Text('Position')),
      DataColumn(label: Text('Contact')),
    ];
  }

  List<DataRow> _buildRows() {
    return staffList.map((staff) {
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
          DataCell(Text(staff.staffId)),
          DataCell(Text(staff.name)),
          DataCell(Text(staff.department)),
          DataCell(Text(staff.position)),
          DataCell(Text(staff.contact)),
        ],
        onSelectChanged: (selected) {
          if (selected != null && selected) {
            // Handle row selection
          }
        },
      );
    }).toList();
  }

  Widget _buildRepliesTab() {
    return SingleChildScrollView(
      child: Center(
        child: Text('Replies Tab Content'),
      ),
    );
  }

  Widget _buildNotificationTab() {
    return SingleChildScrollView(
      child: Center(
        child: Text('Notification Tab Content'),
      ),
    );
  }

  Widget _buildOutgoingFilesTab() {
    return SingleChildScrollView(
      child: Center(
        child: Text('Outgoing Files Tab Content'),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(
        canvasColor: AppColor.yellow,
        primaryColor: Colors.black, // Color of the selected item
        textTheme: Theme.of(context).textTheme.copyWith(
          caption: TextStyle(color: Colors.black),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        backgroundColor: AppColor.yellow,
        selectedItemColor: Colors.black, // Color of the selected item
        unselectedItemColor: Colors.black, // Color of unselected items
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy, color: Colors.black),
            label: 'Files',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.reply, color: Colors.black),
            label: 'Replies',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications, color: Colors.black),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_upload, color: Colors.black),
            label: 'Outgoing Files',
          ),
        ],
      ),
    );
  }
}

class Staff {
  String staffId;
  String name;
  String department;
  String position;
  String contact;

  Staff({
    required this.staffId,
    required this.name,
    required this.department,
    required this.position,
    required this.contact,
  });
}