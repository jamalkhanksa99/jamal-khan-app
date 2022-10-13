import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../../common/ui.dart';
import '../models/media_model.dart';
import '../models/parents/model.dart';
import '../models/user_model.dart';
import '../modules/global_widgets/main_drawer_widget.dart';
import '../modules/global_widgets/notifications_button_widget.dart';
import '../routes/app_routes.dart';

class ScheduleDayView extends StatefulWidget {
  ScheduleDayView({Key key, this.dayName, this.dayNameEn}) : super(key: key);
  String dayName;
  String dayNameEn;

  @override
  _ScheduleDayViewState createState() => _ScheduleDayViewState();
}

class _ScheduleDayViewState extends State<ScheduleDayView> {
  var local = Get.locale;
  TimeOfDay startTime = TimeOfDay(hour: 00, minute: 00);
  TimeOfDay endTime = TimeOfDay(hour: 00, minute: 00);
  List<Map<String, dynamic>> days = [];
  bool loading = true;

  showDateTimes() async {
    print(widget.dayNameEn);
    var headers = {'Accept': 'application/json'};
    var store = GetStorage();
    print(store.read("apiToken"));
    var request = http.Request(
        'GET',
        Uri.parse(
            'https://jamal-khanah.das-360.net/api/provider/availability_hours?api_token=${store.read("apiToken")}&search=day:${widget.dayNameEn}&orderBy=start_at'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      try {
        var resp = await response.stream.bytesToString();
        print(resp);
        var tagObjsJson = jsonDecode(resp);
        days = [];
        print(tagObjsJson["data"]);
        for (int i = 0; i < tagObjsJson["data"].length; i++) {
          days.add({
            "id": tagObjsJson["data"][i]['id'],
            "startTime": TimeOfDay(
                hour: int.parse(tagObjsJson["data"][i]['start_at']
                    .toString()
                    .split(":")[0]),
                minute: int.parse(tagObjsJson["data"][i]["start_at"]
                    .toString()
                    .split(":")[1])),
            "endTime": TimeOfDay(
                hour: int.parse(
                    tagObjsJson["data"][i]["end_at"].toString().split(":")[0]),
                minute: int.parse(
                    tagObjsJson["data"][i]["end_at"].toString().split(":")[1]))
          });
        }
      } catch (e) {}
    } else {
      print(response.reasonPhrase);
    }
    setState(() {
      if (days.length == 0)
        days = [
          {
            "id": "-1",
            "startTime": startTime,
            "endTime": endTime,
            "loading": false,
          }
        ];
      else
        days = days;
      loading = false;
    });
  }

  Future<TimeOfDay> _selectTime(
      BuildContext context, TimeOfDay selectedTime) async {
    final TimeOfDay timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      return timeOfDay;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    showDateTimes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.dayName.tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFCE1B5),
        elevation: 0,
        // automaticallyImplyLeading: false,
        // leading: new IconButton(
        //   icon: new Icon(Icons.sort, color: Get.theme.hintColor),
        //   onPressed: () => {Scaffold.of(context).openDrawer()},
        // ),
        actions: [NotificationsButtonWidget()],
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    ...days.map((e) => Container(
                          padding: EdgeInsets.all(8),
                          margin: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Get.theme.colorScheme.secondary
                                  .withOpacity(0.3),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              Icon(Icons.access_time_sharp,
                                  color: Get.theme.colorScheme.secondary),
                              Text("أوقات العمل ليوم " + widget.dayName.tr),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: InkWell(
                                      onTap: () {
                                        _selectTime(context, e['startTime'])
                                            .then((value) {
                                          setState(() {
                                            e['startTime'] = value;
                                          });
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          Text(
                                            "وقت البدء",
                                            style: TextStyle(
                                                color: Get.theme.colorScheme
                                                    .secondary),
                                          ),
                                          Text(e['startTime']
                                              .toString()
                                              .replaceAll("TimeOfDay", "")
                                              .replaceAll("(", "")
                                              .replaceAll(")", ""))
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      _selectTime(context, e['endTime'])
                                          .then((value) {
                                        setState(() {
                                          e['endTime'] = value;
                                        });
                                      });
                                    },
                                    child: Column(
                                      children: [
                                        Text(
                                          "وقت الانتهاء",
                                          style: TextStyle(
                                              color: Get
                                                  .theme.colorScheme.secondary),
                                        ),
                                        Text(e['endTime']
                                            .toString()
                                            .replaceAll("TimeOfDay", "")
                                            .replaceAll("(", "")
                                            .replaceAll(")", ""))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              e['loading'] == true
                                  ? CircularProgressIndicator()
                                  : MaterialButton(
                                      onPressed: () async {

                                          setState(() {
                                            e['loading'] = true;
                                          });
                                          var store = GetStorage();
                                          var token = store.read("apiToken");
                                          if (e['id'] == "-1") {
                                            var headers = {
                                              'Accept': 'application/json'
                                            };

                                            var request = http.MultipartRequest(
                                                'POST',
                                                Uri.parse(
                                                    'https://jamal-khanah.das-360.net/api/provider/availability_hours?api_token=${token}&skipCache=true'));
                                            request.fields.addAll({
                                              'day': widget.dayNameEn,
                                              'start_at': e['startTime']
                                                  .toString()
                                                  .replaceAll("TimeOfDay", "")
                                                  .replaceAll("(", "")
                                                  .replaceAll(")", ""),
                                              'end_at': e['endTime']
                                                  .toString()
                                                  .replaceAll("TimeOfDay", "")
                                                  .replaceAll("(", "")
                                                  .replaceAll(")", "")
                                            });

                                            request.headers.addAll(headers);

                                            http.StreamedResponse response =
                                                await request.send();

                                            if (response.statusCode == 200) {
                                              var resp = await response.stream
                                                  .bytesToString();
                                              var resp2 = jsonDecode(resp);
                                              print(resp);
                                              if (resp2["success"] == true)
                                                Get.showSnackbar(
                                                    Ui.SuccessSnackBar(
                                                        message:
                                                            resp2["message"]));
                                              else
                                                Get.showSnackbar(
                                                    Ui.ErrorSnackBar(
                                                        message:
                                                            resp2["message"]));
                                            } else {
                                              print(response.reasonPhrase);
                                            }
                                          } else {
                                            var headers = {
                                              'Accept': 'application/json'
                                            };
                                            var request = http.MultipartRequest(
                                                'POST',
                                                Uri.parse(
                                                    'https://jamal-khanah.das-360.net/api/provider/availability_hours/${e['id']}?api_token=${token}&_method=PUT&skipCache=true'));
                                            request.fields.addAll({
                                              'day': widget.dayNameEn,
                                              'start_at': e['startTime']
                                                  .toString()
                                                  .replaceAll("TimeOfDay", "")
                                                  .replaceAll("(", "")
                                                  .replaceAll(")", ""),
                                              'end_at': e['endTime']
                                                  .toString()
                                                  .replaceAll("TimeOfDay", "")
                                                  .replaceAll("(", "")
                                                  .replaceAll(")", "")
                                            });

                                            request.headers.addAll(headers);

                                            http.StreamedResponse response =
                                                await request.send();

                                            if (response.statusCode == 200) {
                                              var resp = await response.stream
                                                  .bytesToString();
                                              var resp2 = jsonDecode(resp);
                                              print(resp);
                                              if (resp2["success"] == true)
                                                Get.showSnackbar(
                                                    Ui.SuccessSnackBar(
                                                        message:
                                                            resp2["message"]));
                                              else
                                                Get.showSnackbar(
                                                    Ui.ErrorSnackBar(
                                                        message:
                                                            resp2["message"]));
                                            } else {
                                              print(response.reasonPhrase);
                                            }
                                          }
                                          setState(() {
                                            e['loading'] = false;
                                          });

                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      color: Get.theme.colorScheme.secondary,
                                      disabledElevation: 0,
                                      disabledColor: Get.theme.focusColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            e['id'] == "-1"
                                                ? "Save".tr
                                                : "Update".tr,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    ),
                              e['id'] != "-1"
                                  ? MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          days.remove(e);
                                          loading = true;
                                        });
                                        var store = GetStorage();
                                        var token = store.read("apiToken");

                                        var headers = {
                                          'Accept': 'application/json'
                                        };
                                        var request = http.Request(
                                            'DELETE',
                                            Uri.parse(
                                                'https://jamal-khanah.das-360.net/api/provider/availability_hours/${e['id']}?api_token=${token}&_method=PUT&skipCache=true'));

                                        request.headers.addAll(headers);

                                        http.StreamedResponse response =
                                            await request.send();

                                        if (response.statusCode == 200) {
                                          var resp = await response.stream
                                              .bytesToString();
                                          var resp2 = jsonDecode(resp);
                                          print(resp);
                                          if (resp2["success"] == true)
                                            Get.showSnackbar(Ui.SuccessSnackBar(
                                                message: resp2["message"]));
                                          else
                                            Get.showSnackbar(Ui.ErrorSnackBar(
                                                message: resp2["message"]));
                                        }

                                        setState(() {
                                          loading = false;
                                          if (days.length == 0)
                                            days.add({
                                              "id": "-1",
                                              "startTime": startTime,
                                              "endTime": endTime,
                                              "loading": false
                                            });
                                        });
                                      },
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 4),
                                      color: Get.theme.colorScheme.secondary,
                                      disabledElevation: 0,
                                      disabledColor: Get.theme.focusColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: Text(
                                            "Delete".tr,
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                    )
                                  : Container(),
                            ],
                          ),
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                print("ues");
                                days.add({
                                  "id": "-1",
                                  "startTime": startTime,
                                  "endTime": endTime,
                                  "loading": false
                                });
                                print(days.length);
                              });
                            },
                            child: Icon(
                              Icons.add_circle,
                              size: 30,
                              color: Get.theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
      drawer: MainDrawerWidget(),
    );
  }
}
