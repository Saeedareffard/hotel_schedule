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
  StaffSchedulingPageState createState() => StaffSchedulingPageState();
}

class StaffSchedulingPageState extends State<StaffSchedulingPage> {
  List<StaffMember> staffMembers = [];
  List<String> terms = [];
  @override
  void initState() {
    super.initState();
    loadStaffData();
  }

  Future<void> loadStaffData() async {
    final jsonString = await rootBundle.loadString('assets/json/staff.json');
    final jsonMap = json.decode(jsonString);

    List<StaffMember> members = [];
    List<String> scheduleTerms = [];
    for (String term in jsonMap['terms']) {
      scheduleTerms.add(term);
    }
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
      terms = scheduleTerms;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Scheduling'),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10.0,
                  ),
                  Card(
                      shape: const CircleBorder(),
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            TextEditingController termTextController =
                                TextEditingController();
                            showDialog(
                              context: context,
                              builder: (context) => SimpleDialog(
                                title: const Text('Add Terms'),
                                contentPadding: EdgeInsets.all(8.0),
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                        label: Text('term')),
                                    controller: termTextController,
                                  ),
                                  const SizedBox(
                                    height: 8.0,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (termTextController
                                              .text.isNotEmpty) {
                                            terms.add(termTextController.text);
                                          }
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: const Text('Save')),
                                ],
                              ),
                            );
                          });
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.green,
                      )),
                ],
              ),
              const SizedBox(
                height: 12.0,
              ),
              if (terms.isNotEmpty)
                ...terms
                    .map<Widget>((e) => Card(
                          child: ListTile(title: Text(e)),
                        ))
                    .toList()
              else
                const Text('No terms yet')
            ],
          ),
          const SizedBox(
            height: 10.0,
          ),
          SingleChildScrollView(
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
        ],
      ),
    );
  }

  Widget _getAvatarWithName({required String name, required String path}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(height: 20),
        CircleAvatar(
          backgroundImage: AssetImage(path),
          radius: 32,
        ),
        const SizedBox(height: 10),
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
      return const Icon(Icons.weekend);
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
