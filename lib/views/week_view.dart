import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:neumont_planner/models/objects.dart';
import 'package:neumont_planner/models/week_date_helper.dart';

import '../main.dart';

class WeekView extends StatelessWidget {
  final void Function(View, DateTime) changeView;
  // @override
  // State<StatefulWidget> createState() => _WeekViewState();
  final List<Assignment> assignments;
  final List<Course> courses;
  final List<Event> events;
  final DateTime date;

  WeekView(
      this.assignments, this.courses, this.events, this.changeView, this.date);

  @override
  Widget build(BuildContext context) {
    DateTime currentDate;
    List<String> dates = [];
    if (date == null) {
      print("null");
      currentDate = DateTime.now();
    } else {
      print("notNull");
      currentDate = date;
    }
    DateTime _viewWeek =
        currentDate.subtract(new Duration(days: currentDate.weekday));

    for (var i = 6, j = 0; j < 7; i++, j++) {
      // print("${describeEnum(_WeekDay.values[i])} ${_thisWeek.month}/${(_thisWeek.day+j)}");
      dates.add(
          "${describeEnum(_WeekDay.values[i])}, ${_viewWeek.month}/${(_viewWeek.day + j)}");
      if (i == 6) {
        i = -1;
      }
    }

    List<Container> cardList = buildCards(dates, assignments, events);

    double start = 0;
    double update = 0;

    //   return Expanded(
    //       child: ListView(
    //           shrinkWrap: true,
    //           children: dates
    //               .map((dateString) => GestureDetector(
    //                   onTap: () {
    //                     changeView(View.DAY, currentDate);
    //                   },
    //                   onPanStart: (DragStartDetails details) {
    //                     start = details.globalPosition.dx;
    //                   },
    //                   onPanUpdate: (DragUpdateDetails details) {
    //                     update = details.globalPosition.dx - start;
    //                   },
    //                   onPanEnd: (DragEndDetails details) {
    //                     if (update - start > 0) {
    //                       //previoius
    //                       print(currentDate.toString());
    //                       DateTime toPass =
    //                           currentDate.subtract(new Duration(days: 7));
    //                       print(toPass.toString());
    //                       changeView(View.WEEK, toPass);
    //                     } else {
    //                       //next
    //                       DateTime toPass =
    //                           currentDate.add(new Duration(days: 7));
    //                       changeView(View.WEEK, toPass);
    //                     }
    //                   },
    //                   child: Container(
    //                       height: 100,
    //                       child: Card(
    //                         child: Column(
    //                           children: assignments.length < 4
    //                               ? <Widget>[
    //                                   WeekDateHelper(assignments, dateString)
    //                                 ]
    //                               : <Widget>[
    //                                   Text(
    //                                       "$dateString\n${assignments.length.toString()} assignments")
    //                                 ],
    //                         ),
    //                       ))))
    //               .toList()));
    return Expanded(
      child: new GestureDetector(
        child: ListView(
          children: cardList,
        ),
        onTap: () {
          changeView(View.DAY, currentDate);
        },
        onPanStart: (DragStartDetails details) {
          start = details.globalPosition.dx;
        },
        onPanUpdate: (DragUpdateDetails details) {
          update = details.globalPosition.dx - start;
        },
        onPanEnd: (DragEndDetails details) {
          if (update - start > 0) {
            //previoius
            print(currentDate.toString());
            DateTime toPass = currentDate.subtract(new Duration(days: 7));
            print(toPass.toString());
            changeView(View.WEEK, toPass);
          } else {
            //next
            DateTime toPass = currentDate.add(new Duration(days: 7));
            changeView(View.WEEK, toPass);
          }
        },
      ),
    );
  }
}

enum _WeekDay {
  MONDAY,
  TUESDAY,
  WEDNESDAY,
  THURESDAY,
  FRIDAY,
  SATURDAY,
  SUNDAY
}

List<Container> buildCards(
    List<String> dates, List<Assignment> assignments, List<Event> events) {
  List<Container> toReturn = new List<Container>();
  for (String item in dates) {
    toReturn.add(new Container(
      height: 100,
      child: Card(
        child: Column(
          children: assignments.length < 4
              ? <Widget>[WeekDateHelper(assignments, item)]
              : <Widget>[
                  Text("$item\n${assignments.length.toString()} assignments")
                ],
        ),
      ),
    ));
  }
  return toReturn;
}
