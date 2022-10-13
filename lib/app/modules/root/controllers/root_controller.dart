/*
 * Copyright (c) 2020 .
 */

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../Freelancer/Schedule.dart';
import '../../../Freelancer/homeScreenUI.dart';
import '../../../models/custom_page_model.dart';
import '../../../repositories/custom_page_repository.dart';
import '../../../repositories/notification_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../account/views/account_view.dart';
import '../../auth/views/login_view.dart';
import '../../bookings/controllers/bookings_controller.dart';
import '../../bookings/views/bookings_view.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/views/home2_view.dart';
import '../../messages/controllers/messages_controller.dart';
import '../../messages/views/messages_view.dart';

class RootController extends GetxController {
  var store = GetStorage();
  var currentIndex;
  final notificationsCount = 0.obs;
  final customPages = <CustomPage>[].obs;
  NotificationRepository _notificationRepository;
  CustomPageRepository _customPageRepository;

  RootController() {
    var store = GetStorage();
    _notificationRepository = new NotificationRepository();
    _customPageRepository = new CustomPageRepository();
    print("----------");

    print(store.read("role"));
    print("----------");
    currentIndex =
        store.read("role") != null && store.read("role") == "1" ? 0.obs : 4.obs;
  }

  @override
  void onInit() async {
    super.onInit();
    var store = GetStorage();

    currentIndex =
        store.read("role") != null && store.read("role") != "1" ? 4.obs : 0.obs;

    await getCustomPages();
    print("******---***---*******");
  }

  List<Widget> pages = [
    Home2View(),
    BookingsView(),
    MessagesView(),
    ScheduleView(),
    HomeFreelancer(),
    LoginView(),
    AccountView(),
  ];

  Widget get currentPage => pages[currentIndex.value];

  /**
   *
   * change page in route
   *
   *  */
  Future<void> changePageInRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    } else {
      currentIndex.value = _index;
      await refreshPage(_index);
    }
  }

  Future<void> changePageOutRoot(int _index) async {
    if (!Get.find<AuthService>().isAuth && _index > 0) {
      await Get.toNamed(Routes.LOGIN);
    }
    currentIndex.value = _index;
    await refreshPage(_index);
    await Get.offNamedUntil(Routes.ROOT, (Route route) {
      if (route.settings.name == Routes.ROOT) {
        return true;
      }
      return false;
    }, arguments: _index);
  }

  Future<void> changePage(int _index) async {
    if (Get.currentRoute == Routes.ROOT) {
      store.read("isVerified") == false && store.read("apiToken")!=null
          ? Get.offAllNamed(Routes.PHONE_VERIFICATION)
          : store.read("role") != null &&
                  store.read("role") != "1" &&
                  _index == 0
              ? await changePageInRoot(4)
              : await changePageInRoot(_index);
      Get.find<AuthService>().isAuth;
    } else {
      await changePageOutRoot(_index);
    }
  }

  Future<void> refreshPage(int _index) async {
    switch (_index) {
      case 0:
        {
          await Get.find<HomeController>().refreshHome();
          break;
        }
      case 1:
        {
          await Get.find<BookingsController>().refreshBookings();
          break;
        }
      case 2:
        {
          await Get.find<MessagesController>().refreshMessages();
          break;
        }
    }
  }

  void getNotificationsCount() async {
    notificationsCount.value = await _notificationRepository.getCount();
  }

  Future<void> getCustomPages() async {
    customPages.assignAll(await _customPageRepository.all());
  }
}
