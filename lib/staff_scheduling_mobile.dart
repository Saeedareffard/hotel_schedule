import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StaffMember {
  final String name;
  final String avatar;
  final List<Schedule> schedule;

  StaffMember({
    required this.name,
    required this.avatar,
    required this.schedule,
  });
}

class Schedule {
  final String day;
  final String task;
  final String startTime;
  final String endTime;

  Schedule({
    required this.day,
    required this.task,
    required this.startTime,
    required this.endTime,
  });
}

class StaffSchedulingPage extends StatefulWidget {
  const StaffSchedulingPage({Key? key}) : super(key: key);

  @override
  _StaffSchedulingPageState createState() => _StaffSchedulingPageState();
}

class _StaffSchedulingPageState extends State<StaffSchedulingPage> {
  List<StaffMember> staffMembers = [];

  @override
  void initState() {
    super.initState();
    loadStaffData();
  }

  Future<void> loadStaffData() async {
    final jsonString = await rootBundle.loadString('assets/json/staff.json');
    final jsonMap = json.decode(jsonString);

    List<StaffMember> members = [];

    for (var member in jsonMap['staff']) {
      List<Schedule> schedule = [];
      for (var s in member['schedule']) {
        schedule.add(Schedule(
          day: s['day'],
          task: s['task'],
          startTime: s['startTime'],
          endTime: s['endTime'],
        ));
      }
      members.add(StaffMember(
        name: member['name'],
        avatar: member['avatar'],
        schedule: schedule,
      ));
    }

    setState(() {
      staffMembers = members;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Scheduling'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(83.0),
                children: [
                  TableRow(
                    children: [
                      const TableCell(
                        child: SizedBox(),
                      ),
                      for (var day in [
                        'Mon',
                        'Tue',
                        'Wed',
                        'Thu',
                        'Fri',
                        'Sat',
                        'Sun'
                      ])
                        TableCell(
                          child: Center(child: Text(day)),
                        ),
                    ],
                  ),
                  for (var member in staffMembers)
                    TableRow(
                      children: [
                        TableCell(
                          child: _getAvatarWithName(
                            name: member.name,
                            path: member.avatar,
                          ),
                        ),
                        for (var schedule in member.schedule)
                          TableCell(
                            child: StaffCell(
                              avatar: _getTaskIcon(schedule.task),
                              task: schedule.startTime.isEmpty ||
                                      schedule.endTime.isEmpty
                                  ? 'off'
                                  : '${schedule.startTime} - ${schedule.endTime}',
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getAvatarWithName({required String name, required String path}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: 20),
        CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: 32,
        ),
        SizedBox(height: 10),
        Text(name),
      ],
    );
  }

  Widget _getTaskIcon(String task) {
    if (task == 'IRD') {
      return SvgPicture.asset(
        'assets/icon/ird.svg',
        width: 60,
        height: 40,
      );
    } else if (task == 'Minibar') {
      return SvgPicture.asset(
        'assets/icon/minibar.svg',
        width: 60,
        height: 40,
      );
    } else if (task == 'Banquet') {
      return SvgPicture.asset(
        'assets/icon/banquet.svg',
        width: 60,
        height: 40,
      );
    } else {
      return Icon(Icons.weekend);
    }
  }
}

class StaffCell extends StatelessWidget {
  final Widget avatar;
  final String task;

  const StaffCell({
    super.key,
    required this.avatar,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 85.0,
      height: 120.0,
      alignment: Alignment.center,
      color: Colors.blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          avatar,
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Text(
                task,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
