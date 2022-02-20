import 'package:flutter/material.dart';

class WorkTimeInputWidget extends StatefulWidget {
  const WorkTimeInputWidget({Key? key}) : super(key: key);

  @override
  _InputWidgetState createState() => _InputWidgetState();
}

class _InputWidgetState extends State<WorkTimeInputWidget> {
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Work Start Time',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 12,
        ),
        GestureDetector(
          onTap: () async {
            startTime = await _selectTime(startTime);
            setState(() {});
          },
          child: Text('${startTime.hour}:${startTime.minute}'),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Work End Time',
          style: Theme.of(context).textTheme.headline5,
        ),
        const SizedBox(
          height: 21,
        ),
        GestureDetector(
          onTap: () async {
            endTime = await _selectTime(endTime);
            setState(() {});
          },
          child: Text('${endTime.hour}:${endTime.minute}'),
        ),
      ],
    );
  }

  Future<TimeOfDay> _selectTime(TimeOfDay initTime) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: initTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != initTime) {
      return timeOfDay;
    }
    return TimeOfDay.now();
  }
}
