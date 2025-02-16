import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calendar")),
      body: SfCalendar(
        view: CalendarView.timelineDay,

        dataSource: EventDataSource(getCalendarEvents()),
        timeSlotViewSettings: TimeSlotViewSettings(
          timeInterval: Duration(minutes: 30),
          timeFormat: 'h:mm a',
        ),
      ),
    );
  }
}

List<Appointment> getCalendarEvents() {
  return [
    Appointment(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      subject: 'Meeting',
      color: Colors.blue,
    ),
    Appointment(
      startTime: DateTime.now().add(Duration(hours: 3)),
      endTime: DateTime.now().add(Duration(hours: 4)),
      subject: 'Lunch',
      color: Colors.green,
    ),
  ];
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Appointment> source) {
    appointments = source;
  }
}
