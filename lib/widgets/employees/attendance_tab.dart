import 'package:flutter/material.dart';

class AttendanceTab extends StatefulWidget {
  final Map<String, dynamic> employeeData;

  const AttendanceTab({
    super.key,
    required this.employeeData,
  });

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sample attendance data
    final attendanceRecords = [
      {
        'date': '2024-11-06',
        'day': 'Wednesday',
        'time_in': '09:00 AM',
        'time_out': '06:00 PM',
        'hours': '9h 0m',
        'status': 'Present',
      },
      {
        'date': '2024-11-05',
        'day': 'Tuesday',
        'time_in': '08:45 AM',
        'time_out': '06:15 PM',
        'hours': '9h 30m',
        'status': 'Present',
      },
      {
        'date': '2024-11-04',
        'day': 'Monday',
        'time_in': '09:10 AM',
        'time_out': '06:00 PM',
        'hours': '8h 50m',
        'status': 'Late',
      },
      {
        'date': '2024-11-03',
        'day': 'Sunday',
        'time_in': '-',
        'time_out': '-',
        'hours': '-',
        'status': 'Day Off',
      },
      {
        'date': '2024-11-02',
        'day': 'Saturday',
        'time_in': '-',
        'time_out': '-',
        'hours': '-',
        'status': 'Day Off',
      },
      {
        'date': '2024-11-01',
        'day': 'Friday',
        'time_in': '09:00 AM',
        'time_out': '06:00 PM',
        'hours': '9h 0m',
        'status': 'Present',
      },
    ];

    final presentDays =
        attendanceRecords.where((r) => r['status'] == 'Present').length;
    final lateDays =
        attendanceRecords.where((r) => r['status'] == 'Late').length;
    final absentDays =
        attendanceRecords.where((r) => r['status'] == 'Absent').length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.access_time,
                  color: Theme.of(context).primaryColor,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attendance Record',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Time in/out records for ${widget.employeeData['first_name']} ${widget.employeeData['last_name']}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Date filter
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 8),
                      Text(
                          '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}'),
                      const SizedBox(width: 8),
                      Icon(Icons.arrow_drop_down, color: Colors.grey.shade600),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Summary Stats
          Row(
            children: [
              _StatCard(
                title: 'Present',
                value: presentDays.toString(),
                icon: Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _StatCard(
                title: 'Late',
                value: lateDays.toString(),
                icon: Icons.watch_later,
                color: Colors.orange,
              ),
              const SizedBox(width: 16),
              _StatCard(
                title: 'Absent',
                value: absentDays.toString(),
                icon: Icons.cancel,
                color: Colors.red,
              ),
              const SizedBox(width: 16),
              _StatCard(
                title: 'Total Days',
                value: attendanceRecords.length.toString(),
                icon: Icons.calendar_today,
                color: Colors.blue,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Attendance Table
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Day',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Time In',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Time Out',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Hours',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Status',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Table Content
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: attendanceRecords.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (context, index) {
                    final record = attendanceRecords[index];
                    return _AttendanceRow(
                      date: record['date'] as String,
                      day: record['day'] as String,
                      timeIn: record['time_in'] as String,
                      timeOut: record['time_out'] as String,
                      hours: record['hours'] as String,
                      status: record['status'] as String,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AttendanceRow extends StatelessWidget {
  final String date;
  final String day;
  final String timeIn;
  final String timeOut;
  final String hours;
  final String status;

  const _AttendanceRow({
    required this.date,
    required this.day,
    required this.timeIn,
    required this.timeOut,
    required this.hours,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              day,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              timeIn,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              timeOut,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              hours,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              status,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _getStatusColor(status),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return Colors.green;
      case 'late':
        return Colors.orange;
      case 'absent':
        return Colors.red;
      case 'day off':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
