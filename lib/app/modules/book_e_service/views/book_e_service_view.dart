import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../common/ui.dart';
import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/tab_bar_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/book_e_service_controller.dart';

class BookEServiceView extends GetView<BookEServiceController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Book the Service".tr,
            style: context.textTheme.headline6,
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
            onPressed: () => Get.back(),
          ),
          elevation: 0,
        ),
        bottomNavigationBar: buildBlockButtonWidget(controller.booking.value),
        body: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 0),
              decoration: Ui.getBoxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Expanded(
                          child: Text("Your Addresses".tr,
                              style: Get.textTheme.bodyText1)),
                      SizedBox(width: 4),
                      MaterialButton(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        onPressed: () {
                          Get.toNamed(Routes.SETTINGS_ADDRESS_PICKER);
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        color: Get.theme.colorScheme.secondary.withOpacity(0.1),
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text("New".tr, style: Get.textTheme.subtitle1),
                            Icon(
                              Icons.my_location,
                              color: Get.theme.colorScheme.secondary,
                              size: 20,
                            ),
                          ],
                        ),
                        elevation: 0,
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    if (controller.addresses.isEmpty) {
                      return TabBarLoadingWidget();
                    } else {
                      return TabBarWidget(
                        initialSelectedId: "0",
                        tag: 'addresses',
                        tabs:
                            List.generate(controller.addresses.length, (index) {
                          final _address =
                              controller.addresses.elementAt(index);
                          return ChipWidget(
                            tag: 'addresses',
                            text: _address.getDescription,
                            id: index,
                            onSelected: (id) {
                              Get.find<SettingsService>().address.value =
                                  _address;
                            },
                          );
                        }),
                      );
                    }
                  }),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      SizedBox(width: 20),
                      Icon(Icons.place_outlined, color: Get.theme.focusColor),
                      SizedBox(width: 15),
                      Expanded(
                        child: Obx(() {
                          return Text(
                              controller.currentAddress?.address ??
                                  "Loading...".tr,
                              style: Get.textTheme.bodyText2);
                        }),
                      ),
                      SizedBox(width: 20),
                    ],
                  ),
                ],
              ),
            ),
            TextFieldWidget(
              onChanged: (input) => controller.booking.value.hint = input,
              hintText: "Is there anything else you would like us to know?".tr,
              labelText: "Hint".tr,
              iconData: Icons.description_outlined,
            ),
            Obx(() {
              return TextFieldWidget(
                onChanged: (input) =>
                    controller.booking.value.coupon.code = input,
                hintText: "COUPON01".tr,
                labelText: "Coupon Code".tr,
                errorText: controller.getValidationMessage(),
                iconData: Icons.confirmation_number_outlined,
                style: Get.textTheme.bodyText2.merge(TextStyle(
                    color: controller.getValidationMessage() != null
                        ? Colors.redAccent
                        : Colors.green)),
                suffixIcon: MaterialButton(
                  onPressed: () {
                    controller.validateCoupon();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  color: Get.theme.focusColor.withOpacity(0.1),
                  child: Text("Apply".tr, style: Get.textTheme.bodyText1),
                  elevation: 0,
                ).marginSymmetric(vertical: 4),
              );
            }),
            SizedBox(height: 20),
            // Obx(() {
            //   return Container(
            //     margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            //     decoration: Ui.getBoxDecoration(
            //         color: controller.getColor(!controller.scheduled.value)),
            //     child: Theme(
            //       data: ThemeData(
            //         toggleableActiveColor: Get.theme.primaryColor,
            //       ),
            //       child: RadioListTile(
            //         value: false,
            //         groupValue: controller.scheduled.value,
            //         onChanged: (value) {
            //           controller.toggleScheduled(value);
            //         },
            //         title: Text("As Soon as Possible".tr,
            //                 style: controller
            //                     .getTextTheme(!controller.scheduled.value))
            //             .paddingSymmetric(vertical: 20),
            //       ),
            //     ),
            //   );
            // }),
            Obx(() {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: Ui.getBoxDecoration(
                    color: controller.getColor(controller.scheduled.value)),
                child: Theme(
                  data: ThemeData(
                    toggleableActiveColor: Get.theme.primaryColor,
                  ),
                  child: RadioListTile(
                    value: true,
                    groupValue: controller.scheduled.value,
                    onChanged: (value) {
                      controller.toggleScheduled(value);
                    },
                    title: Text("Schedule an Order".tr,
                            style: controller
                                .getTextTheme(controller.scheduled.value))
                        .paddingSymmetric(vertical: 20),
                  ),
                ),
              );
            }),
            Obx(() {
              return AnimatedOpacity(
                opacity: controller.scheduled.value ? 1 : 0,
                duration: Duration(milliseconds: 300),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 20 : 0),
                  padding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: controller.scheduled.value ? 20 : 0),
                  decoration: Ui.getBoxDecoration(),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                                "When would you like us to come to your address?"
                                    .tr,
                                style: Get.textTheme.bodyText1),
                          ),
                          SizedBox(width: 10),
                          MaterialButton(
                            elevation: 0,
                            onPressed: () {
                              controller.showMyDatePicker(context);
                            },
                            shape: StadiumBorder(),
                            color: Get.theme.colorScheme.secondary
                                .withOpacity(0.2),
                            child: Text("Select a Date".tr,
                                style: Get.textTheme.subtitle1),
                          ),
                        ],
                      ),
                      Divider(thickness: 1.3, height: 30),
                      Column(
                        children: [
                          Row(
                            children: [  SizedBox(
                              height: 35,
                            ),
                              Expanded(
                                child: Text(
                                    "At What's time you are free in your address?"
                                        .tr,
                                    style: Get.textTheme.bodyText1),
                              ),
                              SizedBox(width: 10),

                              // MaterialButton(
                              //   onPressed: () {
                              //     controller.showMyTimePicker(context);
                              //   },
                              //   shape: StadiumBorder(),
                              //   color: Get.theme.colorScheme.secondary
                              //       .withOpacity(0.2),
                              //   child: Text("Select a time".tr,
                              //       style: Get.textTheme.subtitle1),
                              //   elevation: 0,
                              // ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Obx(() => controller.booking.value.timeSlots != null
                              ? controller.booking.value.timeSlots.length == 0
                                  ? Text(
                                      "لا يوجد أوقات متاحة في هذا التاريخ",
                                      style: TextStyle(
                                          color: Get.theme.colorScheme.secondary
                                              .withOpacity(0.7)),
                                    )
                                  : Container(
                                      height: double.parse((40 *
                                                  ((controller
                                                              .booking
                                                              .value
                                                              .timeSlots
                                                              .length +
                                                          1) /
                                                      2) +
                                              60)
                                          .toString()),
                                      child: GridView.count(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 1.0,
                                          childAspectRatio: 1.5,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          children: List.generate(
                                              controller.booking.value.timeSlots
                                                  .length, (index) {
                                            return
                                                // ...controller.booking.value.timeSlots.map((e) =>
                                                InkWell(
                                              onTap: () {
                                                controller.booking
                                                    .update((val) {
                                                  for (int i = 0;
                                                      i <
                                                          controller
                                                              .booking
                                                              .value
                                                              .timeSlots
                                                              .length;
                                                      i++) {
                                                    controller.booking.value
                                                            .timeSlots[i]
                                                        ['choosen'] = false;
                                                  }
                                                  controller.booking.value
                                                          .timeSlots[index]
                                                      ['choosen'] = true;

                                                  controller.booking.value
                                                      .bookingAt = DateTime(
                                                    controller.booking.value
                                                        .bookingAt.year,
                                                    controller.booking.value
                                                        .bookingAt.month,
                                                    controller.booking.value
                                                        .bookingAt.day,
                                                    int.parse(controller
                                                        .booking
                                                        .value
                                                        .timeSlots[index]
                                                            ['startTime']
                                                        .toString()
                                                        .split(":")[0]
                                                        .toString()),
                                                    int.parse(controller
                                                        .booking
                                                        .value
                                                        .timeSlots[index]
                                                            ['startTime']
                                                        .toString()
                                                        .split(":")[1]
                                                        .toString()),
                                                  );
                                                  controller.booking.value
                                                      .startAt = controller
                                                          .booking
                                                          .value
                                                          .bookingAt
                                                          .year
                                                          .toString() +
                                                      "-" +
                                                      controller.booking.value
                                                          .bookingAt.month
                                                          .toString() +
                                                      "-" +
                                                      controller.booking.value
                                                          .bookingAt.day
                                                          .toString() +
                                                      " " +
                                                      controller.booking.value
                                                              .timeSlots[index]
                                                          ['startTime'];
                                                  controller.booking.value
                                                      .endsAt = controller
                                                          .booking
                                                          .value
                                                          .bookingAt
                                                          .year
                                                          .toString() +
                                                      "-" +
                                                      controller.booking.value
                                                          .bookingAt.month
                                                          .toString() +
                                                      "-" +
                                                      controller.booking.value
                                                          .bookingAt.day
                                                          .toString() +
                                                      " " +
                                                      controller.booking.value
                                                              .timeSlots[index]
                                                          ['endTime'];
                                                });
                                                print(controller
                                                    .booking.value.startAt);
                                                print(controller
                                                    .booking.value.endsAt);
                                                print(controller
                                                    .booking.value.bookingAt);
                                              },
                                              child: Container(
                                                  padding: EdgeInsets.all(5),
                                                  margin: EdgeInsets.all(5),
                                                  decoration: BoxDecoration(
                                                      color: controller
                                                                      .booking
                                                                      .value
                                                                      .timeSlots[index]
                                                                  ['choosen'] ==
                                                              true
                                                          ? Get
                                                              .theme
                                                              .colorScheme
                                                              .secondary
                                                          : Get
                                                              .theme
                                                              .colorScheme
                                                              .secondary
                                                              .withOpacity(
                                                                  0.3)),
                                                  child: Center(
                                                    child: Text(
                                                      controller.booking.value
                                                              .timeSlots[index]
                                                          ['display'],
                                                      style: TextStyle(
                                                          color: controller
                                                                      .booking
                                                                      .value
                                                                      .timeSlots[index]
                                                                  ['choosen']
                                                              ? Colors.white
                                                              : Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .secondary,
                                                          fontSize: 8),
                                                    ),
                                                  )),
                                            );
                                          })))
                              : Container(
                                  child: Text(
                                      "اختر التاريخ لاظهار الاوقات المتاحة خلاله"),
                                )),
                          controller.booking.value.eService.inHome == 1 &&
                                  controller.booking.value.eService.inCenter ==
                                      1
                              ? Obx(() => Row(
                                    children: [
                                      Text('مكان الخدمة:'),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      DropdownButton<int>(
                                          value: controller.booking.value.type,
                                          icon: const Icon(
                                              Icons.arrow_drop_down_sharp),
                                          iconSize: 24,
                                          elevation: 16,
                                          underline: Container(),
                                          onChanged: (int newValue) {
                                            controller.booking.update((val) {
                                              controller.booking.value.type =
                                                  newValue;
                                            });
                                          },
                                          items: [
                                            {"id": 1, "name": "inCenter".tr},
                                            {"id": 2, "name": "inHome".tr}
                                          ].map<DropdownMenuItem<int>>(
                                              (Map<String, dynamic> value) {
                                            return DropdownMenuItem<int>(
                                              value: value['id'],
                                              child: Text(
                                                value['name'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'frutiger',
                                                    color: Colors.black),
                                              ),
                                            );
                                          }).toList()),
                                    ],
                                  ))
                              : Container(
                                  child: Text(controller.booking.value.eService
                                              .inCenter ==
                                          1
                                      ? "inCenter".tr
                                      : "inHome".tr),
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),

            Obx(() {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                transform: Matrix4.translationValues(
                    0, controller.scheduled.value ? 0 : -110, 0),
                child: Obx(() {
                  return Column(
                    children: [
                      Text("Requested Service on".tr)
                          .paddingSymmetric(vertical: 20),
                      Text(
                          '${DateFormat.yMMMMEEEEd(Get.locale.toString()).format(controller.booking.value.bookingAt)}',
                          style: Get.textTheme.headline5),
                      Text(
                          '${DateFormat('HH:mm', Get.locale.toString()).format(controller.booking.value.bookingAt)}',
                          style: Get.textTheme.headline3),
                      SizedBox(height: 20)
                    ],
                  );
                }),
              );
            })
          ],
        ));
  }

  Widget buildBlockButtonWidget(Booking _booking) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: Obx(() {
        return BlockButtonWidget(
          text: Stack(
            alignment: AlignmentDirectional.centerEnd,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  "Continue".tr,
                  textAlign: TextAlign.center,
                  style: Get.textTheme.headline6.merge(
                    TextStyle(color: Get.theme.primaryColor),
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  color: Get.theme.primaryColor, size: 20)
            ],
          ),
          color: Get.theme.colorScheme.secondary,
          onPressed:
              (!(Get.find<SettingsService>().address.value?.isUnknown() ??
                      true))
                  ? () async {
                      await Get.toNamed(Routes.BOOKING_SUMMARY);
                    }
                  : null,
        ).paddingOnly(right: 20, left: 20);
      }),
    );
  }
}
