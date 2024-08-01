import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateOfBirthInput extends StatefulWidget {
  final Function(int age) onChange;
  const DateOfBirthInput({super.key, required this.onChange});
  @override
  State<DateOfBirthInput> createState() => _DateOfBirthInputState();
}

final List<String> _months = List<String>.generate(12, (int index) {
  return DateFormat.MMMM().format(DateTime(0, index + 1));
});

class _DateOfBirthInputState extends State<DateOfBirthInput> {
  final List<int> _days = List<int>.generate(31, (int index) => index + 1);

  final List<int> _years = List<int>.generate(100, (int index) {
    return DateTime.now().year - index;
  });

  String _selectedMonth = _months[DateTime.now().month - 1];
  int _selectedDay = DateTime.now().day;
  int _selectedYear = DateTime.now().year;

  int _calculateAge() {
    final currentDate = DateTime.now();
    final birthDate = DateTime(
      _selectedYear,
      _months.indexOf(_selectedMonth) + 1,
      _selectedDay,
    );
    int age = currentDate.year - birthDate.year;
    if (currentDate.month < birthDate.month ||
        (currentDate.month == birthDate.month &&
            currentDate.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.calendar_month,
              color: Colors.green,
            ),
            const SizedBox(width: 8),
            const Text(
              'Date of Birth',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${_calculateAge()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Text(
              ' yrs',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(boxShadow: const [
            BoxShadow(
              color: Color(0xFFf6f6f6),
              blurRadius: 2,
              spreadRadius: 2,
            )
          ], color: Colors.white, borderRadius: BorderRadius.circular(6)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedMonth,
                  items: _months.map((String month) {
                    return DropdownMenuItem<String>(
                      value: month,
                      child: Text(month),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedMonth = value!;
                      widget.onChange(_calculateAge());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const VerticalDivider(
                color: Color(0xFFf6f6f6),
              ),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedDay,
                  items: _days.map((int day) {
                    return DropdownMenuItem<int>(
                      value: day,
                      child: Text(day.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedDay = value!;
                      widget.onChange(_calculateAge());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
              const VerticalDivider(
                color: Color(0xFFf6f6f6),
              ),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: _selectedYear,
                  items: _years.map((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedYear = value!;
                      widget.onChange(_calculateAge());
                    });
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
