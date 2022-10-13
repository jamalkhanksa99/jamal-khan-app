import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  var storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        drawer: Drawer(
          child: MainDrawerWidget(),
          elevation: 0,
        ),
        body: controller.currentPage,
        bottomNavigationBar: storage.read("role") != "1" && storage.read("role") != null
            ? CustomBottomNavigationBar(
                backgroundColor: context.theme.scaffoldBackgroundColor,
                itemColor: context.theme.colorScheme.secondary,
                currentIndex: controller.currentIndex.value,
                onChange: (index) {
                  controller.changePage(index);
                },
                children: [
                  CustomBottomNavigationItem(
                    icon: Icons.home_outlined,
                    label: "Home".tr,
                  ),
                  CustomBottomNavigationItem(
                    icon: Icons.assignment_outlined,
                    label: "Bookings".tr,
                  ),
                  CustomBottomNavigationItem(
                    icon: Icons.chat_outlined,
                    label: "Chats".tr,
                  ),
                  CustomBottomNavigationItem(
                    icon: Icons.calendar_today,
                    label: "Schedule".tr,
                  ),
                ],
              )
            : CustomBottomNavigationBar(
                backgroundColor: context.theme.scaffoldBackgroundColor,
                itemColor: context.theme.colorScheme.secondary,
                currentIndex: controller.currentIndex.value,
                onChange: (index) {
                  controller.changePage(index);
                },
                children: [
                  CustomBottomNavigationItem(
                    icon: Icons.home_outlined,
                    label: "Home".tr,
                  ),
                  CustomBottomNavigationItem(
                    icon: Icons.assignment_outlined,
                    label: "Bookings".tr,
                  ),
                  CustomBottomNavigationItem(
                    icon: Icons.chat_outlined,
                    label: "Chats".tr,
                  ),
                ],
              ),
      );
    });
  }
}
