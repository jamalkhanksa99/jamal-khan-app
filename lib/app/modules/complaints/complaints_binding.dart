

import 'package:get/get.dart';

import 'complaints_controller.dart';

class ComplaintsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ComplaintsController>(
          () => ComplaintsController(),
    );
  }
}
