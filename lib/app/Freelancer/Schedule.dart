import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../models/media_model.dart';
import '../models/parents/model.dart';
import '../models/user_model.dart';
import '../modules/global_widgets/notifications_button_widget.dart';
import 'schedulesecondscreen.dart';

class Schedule extends Model {
  MonthsName monthsName;
  Day day;
  Time time;

  Schedule({this.monthsName, this.day, this.time});

  Schedule.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
    monthsName = stringFromJson(json, 'monthsName') as MonthsName;
    day = stringFromJson(json, 'day') as Day;
    time = stringFromJson(json, 'time') as Time;
  }

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    map["monthsName"] = monthsName;
    map["day"] = day;
    map["time"] = time;
    return map;
  }
}

class MonthsName {
  String id;
  String value;

  MonthsName({this.id, this.value});
}

class Day {
  int id;
  String dayName;
  bool isSelected;
  List<dynamic> timeSlots;

  Day({this.id, this.dayName, this.isSelected, this.timeSlots});
}

class Time {
  int id;
  String value;
  bool isSelected;

  Time({this.id, this.value, this.isSelected});
}

class ScheduleView extends StatefulWidget {
  const ScheduleView({Key key}) : super(key: key);

  @override
  _ScheduleViewState createState() => _ScheduleViewState();
}

class _ScheduleViewState extends State<ScheduleView> {
  DateTime now = DateTime.now();

  var local = Get.locale;

  int daycount = 0;
  List<Day> dayList = [];

  List<Map<String, dynamic>> daysTobeScheduled = [
    {
      "name": "monday".tr,
      "nameEn": "monday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "tuesday".tr,
      "nameEn": "tuesday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "wednesday".tr,
      "nameEn": "wednesday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "thursday".tr,
      "nameEn": "thursday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "friday".tr,
      "nameEn": "friday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "saturday".tr,
      "nameEn": "saturday",
      "isSelected": false,
      "timeSlots": []
    },
    {
      "name": "sunday".tr,
      "nameEn": "sunday",
      "isSelected": false,
      "timeSlots": []
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFCE1B5),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...daysTobeScheduled.map((e) => Container(
                              height: 70,
                              width: MediaQuery.of(context).size.width * 0.8,
                              decoration: BoxDecoration(
                                color: Get.theme.colorScheme.secondary
                                    .withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              padding: EdgeInsets.all(5),
                              margin: EdgeInsets.all(5),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ScheduleDayView(
                                              dayName: e['name'],
                                              dayNameEn: e['nameEn'],
                                            )),
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Center(
                                            child: Icon(
                                          Icons.date_range,
                                          size: 18,
                                          color:
                                              Get.theme.colorScheme.secondary,
                                        )),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Center(
                                            child: Text(
                                          e['name'],
                                          style: TextStyle(
                                              color: Get
                                                  .theme.colorScheme.secondary,
                                              fontSize: 16),
                                        )),
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Get.theme.colorScheme.secondary)
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
