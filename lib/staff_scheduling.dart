import 'package:flutter/material.dart';

class StaffScheduleCalendar extends StatelessWidget {
  final List<Map<String, dynamic>> staffList;

  const StaffScheduleCalendar({Key? key, required this.staffList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Staff Schedule Calendar'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildWeekdayRow(),
            const SizedBox(height: 16),
            ...staffList.map<Widget>((staff) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(staff['image']),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          staff['name'],
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  ..._buildScheduleCells(staff),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekdayRow() {
    return Row(
      children: [
        const Expanded(
          flex: 1,
          child: SizedBox(),
        ),
        _buildWeekdayHeader('Mon'),
        _buildWeekdayHeader('Tue'),
        _buildWeekdayHeader('Wed'),
        _buildWeekdayHeader('Thu'),
        _buildWeekdayHeader('Fri'),
        _buildWeekdayHeader('Sat'),
        _buildWeekdayHeader('Sun'),
      ],
    );
  }

  Widget _buildWeekdayHeader(String day) {
    return Expanded(
      child: Center(
        child: Text(
          day,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  List<Widget> _buildScheduleCells(Map<String, dynamic> staff) {
    return staff['schedule']
        .map<Widget>(
            (schedule) => Expanded(child: _buildScheduleCell(schedule)))
        .toList();
  }

  Widget _buildScheduleCell(Map<String, dynamic> schedule) {
    final hasSchedule = schedule['taskName'] != 'off';
    final timeRange =
        schedule['startTime'] == null || schedule['endTime'] == null
            ? ''
            : '${schedule['startTime']} - ${schedule['endTime']}';

    return Card(
      color: hasSchedule ? Colors.blue : Colors.white,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: const BorderSide(
          color: Colors.grey,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              timeRange,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasSchedule ? schedule['taskName'] : 'Off',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
