import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../models/complaints_model.dart';
import '../../models/media_model.dart';
import '../../repositories/user_repository.dart';

class ComplaintsController extends GetxController {
  final complaints = Complaint().obs;
  var imagePicked = new Media().obs;
  GlobalKey<FormState> complaintForm;
  UserRepository _userRepository;
  final loading = false.obs;

  ComplaintsController() {
    _userRepository = new UserRepository();
  }

  @override
  void onInit() async {
    // await refreshComplaints();
    super.onInit();
  }

  void sendComplaint(
    String title,
    String description,
    Media image,
  ) async {
    Get.focusScope.unfocus();
    if (title != null && description != null) {
      try {
        loading.value = true;
        complaints.value.image = imagePicked.value;
        complaints.value =
            await _userRepository.sendComplaint(title, description, image);
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    } else {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message: "There are errors in some fields please correct them!".tr));
    }
  }

  void resetProfileForm() {
    imagePicked.value = new Media(thumb: complaints.value.image.thumb);
    complaintForm.currentState.reset();
  }
}
