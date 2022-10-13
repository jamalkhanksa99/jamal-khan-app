import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../models/booking_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/global_service.dart';
import '../controllers/bookings_controller.dart';

class BookingOptionsPopupMenuWidget extends GetView<BookingsController> {
  const BookingOptionsPopupMenuWidget({
    Key key,
    @required Booking booking,
  })  : _booking = booking,
        super(key: key);

  final Booking _booking;

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    return PopupMenuButton(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      onSelected: (item) {
        switch (item) {
          case "cancel":
            {
              controller.cancelBookingService(_booking);
            }
            break;
          case "view":
            {
              Get.toNamed(Routes.BOOKING, arguments: _booking);
            }
            break;
          case "track":
            {
              final data = GetStorage(); // instance of getStorage class
              data.write("order_id", _booking.id);
              data.write("originLat", _booking.address.latitude);
              data.write("originLong", _booking.address.longitude);
              // data.write("bookingTracked", _booking);
              print(_booking.address);
              print("-------------------");

              data.read("role") == "1"
                  ? Get.toNamed(Routes.TRACKINGLOCATIONCUSTOMER,
                      arguments: _booking)
                  : Get.toNamed(Routes.TRACKINGLOCATION, arguments: _booking);
            }
            break;
          case "Accept":
            {
              controller.acceptBookingService(_booking);
            }
            break;
          case "MoveToNext":
            {
              // final _status = controller.getStatusByOrder(
              //     Get.find<GlobalService>().global.value.onTheWay);
              final _status = controller.getStatusByOrder(
                  3);
              controller.moveToStatusBookingService(_booking, _status);
            }
            break;
          case "MoveToCompleted":
            {
              final _status = controller.getStatusByOrder(
                  4

              );
              // final _status = controller.getStatusByOrder(
              //     Get.find<GlobalService>().global.value.done
              // );
              controller.moveToStatusBookingService(_booking, _status);
            }
            break;
        }
      },
      itemBuilder: (context) {
        var list = <PopupMenuEntry<Object>>[];
        if (_booking.status.order ==
         3)
          // if (_booking.status.order ==
          //   Get.find<GlobalService>().global.value.onTheWay)
        {
          box.read("role") != "1"
              ? list.add(
                  PopupMenuItem(
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 10,
                      children: [
                        Icon(Icons.check, color: Colors.green),
                        Text(
                          "MoveToCompleted".tr,
                          style: TextStyle(color: Colors.green),
                        ),
                      ],
                    ),
                    value: "MoveToCompleted",
                  ),
                )
              : null;
        }
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "ID #".tr + _booking.id,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );
        list.add(
          PopupMenuItem(
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 10,
              children: [
                Icon(Icons.assignment_outlined, color: Get.theme.hintColor),
                Text(
                  "View Details".tr,
                  style: TextStyle(color: Get.theme.hintColor),
                ),
              ],
            ),
            value: "view",
          ),
        );

        if (_booking.type != 1)
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.radar, color: Get.theme.hintColor),
                  Text(
                    "TrackOrder".tr,
                    style: TextStyle(color: Get.theme.hintColor),
                  ),
                ],
              ),
              value: "track",
            ),
          );
        if (!_booking.cancel &&
            _booking.status.order <
                3) {
          list.add(PopupMenuDivider(
            height: 10,
          ));
          list.add(
            PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                children: [
                  Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                  Text(
                    "Cancel".tr,
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
              value: "cancel",
            ),
          );
          if (!_booking.cancel &&
              _booking.status.order <
                  2  &&
              box.read("role") != "1") {
            list.add(
              PopupMenuItem(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.check, color: Colors.green),
                    Text(
                      "AcceptOrder".tr,
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
                value: "Accept",
              ),
            );
          }
          if (_booking.status.order ==
                  2 &&
              box.read("role") != "1")
            // if (_booking.status.order ==
            //       Get.find<GlobalService>().global.value.accepted &&
            //   box.read("role") != "1")

          {
            list.add(
              PopupMenuItem(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 10,
                  children: [
                    Icon(Icons.next_plan_rounded, color: Colors.orangeAccent),
                    Text(
                      "MoveToProcessing".tr,
                      style: TextStyle(color: Colors.orangeAccent),
                    ),
                  ],
                ),
                value: "MoveToNext",
              ),
            );
          }
        }
        return list;
      },
      child: Icon(
        Icons.more_vert,
        color: Get.theme.hintColor,
      ),
    );
  }
}
