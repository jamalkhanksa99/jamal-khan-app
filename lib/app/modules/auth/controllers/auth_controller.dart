import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../../services/firebase_messaging_service.dart';
import '../../root/controllers/root_controller.dart';
import 'package:http/http.dart' as http;

enum role { user, company }

class AuthController extends GetxController {
  final Rx<User> currentUser = Get.find<AuthService>().user;
  GlobalKey<FormState> loginFormKey;
  GlobalKey<FormState> loginFormKey23;
  GlobalKey<FormState> registerFormKey;
  GlobalKey<FormState> forgotPasswordFormKey;
  final hidePassword = true.obs;
  final loading = false.obs;
  var choosenrole = role.user.obs;
  var roleSelected = 0.obs;
  var acceptTerms = true.obs;

  // final LocationSettings locationSettings = LocationSettings(
  //   accuracy: LocationAccuracy.high,
  //   distanceFilter: 100,);

  Position currentposition;

  String currentAddress;

  bool serviceEnabled;
  LocationPermission permission;
  final smsSent = ''.obs;
  UserRepository _userRepository;

  AuthController() {
    _userRepository = UserRepository();
  }

  // @override
  // void onInit() {
  //   // TODO: implement onInit
  //   super.onInit();
  //   getAddress();
  // }

  getAddress() async {
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (serviceEnabled) {
      Get.showSnackbar(
          Ui.ErrorSnackBar(message: 'Please enable Your Location Service'));
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Get.showSnackbar(
            Ui.ErrorSnackBar(message: 'Location permissions are denied'));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Get.showSnackbar(Ui.ErrorSnackBar(
          message:
              'Location permissions are permanently denied, we cannot request permissions.'));
    }

    Geolocator.getPositionStream(
            distanceFilter: 100, desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) async {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      print(position == null
          ? 'Unknown'
          : '${position.latitude.toString()}, ${position.longitude.toString()}');

      currentposition = position;
      List<Placemark> placemarks = await placemarkFromCoordinates(
          currentposition.latitude, currentposition.longitude);
      Placemark place = placemarks[0];

      currentAddress =
          " ${place.locality},${place.administrativeArea}, ${place.country},${place.street}, ${place.name}";
    });
  }

  void login() async {
    Get.focusScope.unfocus();
    //
    // if (loginFormKey23.currentState.validate()) {

    // loginFormKey23.currentState.save();

    loading.value = true;

    try {
      await Get.find<FireBaseMessagingService>().setDeviceToken();
      print(currentUser);
      currentUser.value = await _userRepository.login(currentUser.value);

      // var resp = await _userRepository.signInWithEmailAndPassword(
      //     currentUser.value.email, currentUser.value.apiToken);
      // print(resp);
      var store = GetStorage();
      store.write("role", currentUser.value.role);
      print(currentUser.value.role);
      Get.lazyPut(() => RootController());
      await Get.find<RootController>()
          .changePage(currentUser.value.role == "1" ? 0 : 4); //done by mariam
      // await Get.find<RootController>().changePage(0); // for normal user
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
    // }
  }

  void register() async {
    Get.focusScope.unfocus();
    if (registerFormKey.currentState.validate()) {
      registerFormKey.currentState.save();
      loading.value = true;
      try {
        loading.value = true;
        // await _userRepository.verifyPhone(smsSent.value);

        await Get.find<FireBaseMessagingService>().setDeviceToken();
        var storage = GetStorage();
        currentUser.value = await _userRepository.register(
          currentUser.value,
          storage.read('roleRegister'),
        );
        storage.write("isVerified", false);
        //
        // await _userRepository.signUpWithEmailAndPassword(
        //     currentUser.value.email, currentUser.value.password);
        if (storage.read('roleRegister') == "1") {
          Get.offAllNamed(Routes.PHONE_VERIFICATION);
          // await Get.find<RootController>().changePage(0);

        } else {
          Get.showSnackbar(Ui.SuccessSnackBar(message: "bePatient".tr));
          loading.value = false;
          await Get.toNamed(Routes.LOGIN);
        }
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }

  Future<void> verifyPhone() async {
    try {
      loading.value = true;
      var store = GetStorage();
      var token = store.read("apiToken");
      var request = http.MultipartRequest(
          'POST',
          Uri.parse(
              'https://jamal-khanah.das-360.net/api/account-verification/verify?api_token=$token'));
      request.fields.addAll({'verification_code': smsSent.value});

      http.StreamedResponse response = await request.send();
      print("============");
      print(response.statusCode);
      print(request.fields);
      print(request);
      if (response.statusCode == 406) {store.write("isVerified",false);
        Get.showSnackbar(Ui.ErrorSnackBar(message: "Wrong OTP code"));
      } else {
        Get.log("i am in else");
        if (response.statusCode == 202) {
          Get.put(RootController());
          Get.log("i am here");

          var storage = GetStorage();
          store.write("isVerified", true);
          Get.showSnackbar(
              Ui.SuccessSnackBar(message: "Phone Number Verified"));
          if (storage.read('roleRegister') == "1") {
            // Get.offAllNamed(Routes.PHONE_VERIFICATION);
            await Get.find<RootController>().changePage(0);
          } else {
            Get.showSnackbar(Ui.SuccessSnackBar(message: "bePatient".tr));
            loading.value = false;
            await Get.toNamed(Routes.LOGIN);
          }
        }
      }
      // await _userRepository.verifyPhone(smsSent.value);

      // await Get.find<RootController>().changePage(0);
    } catch (e) {
      Get.back();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future<void> resendOTPCode() async {
    await _userRepository.sendCodeToPhone();
  }

  void sendResetLink() async {
    Get.focusScope.unfocus();
    if (forgotPasswordFormKey.currentState.validate()) {
      forgotPasswordFormKey.currentState.save();
      loading.value = true;
      try {
        await _userRepository.sendResetLinkEmail(currentUser.value);
        loading.value = false;
        Get.showSnackbar(Ui.SuccessSnackBar(
            message:
                "The Password reset link has been sent to your email: ".tr +
                    currentUser.value.email));
        Timer(Duration(seconds: 5), () {
          Get.offAndToNamed(Routes.LOGIN);
        });
      } catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      } finally {
        loading.value = false;
      }
    }
  }
}
