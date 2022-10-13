import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/setting_model.dart';
import '../../../routes/app_routes.dart';
import '../../../services/settings_service.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/auth_controller.dart';

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: Form(
          // key: loginFormKey,
          child: ListView(
            primary: true,
            children: [
              Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: [
                  Container(
                    height: 180,
                    width: Get.width,
                    decoration: BoxDecoration(
                      color: Get.theme.colorScheme.secondary,
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(100)),
                      boxShadow: [
                        BoxShadow(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            blurRadius: 10,
                            offset: Offset(0, 5)),
                      ],
                    ),
                    margin: EdgeInsets.only(bottom: 50),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.65,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: Ui.getBoxDecoration(
                      color: Color(0xFFFCE1B5),
                      radius: 14,
                      border: Border.all(width: 5, color: Color(0xFFFCE1B5)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Container(
                        child: Image.asset(
                          'assets/icon/jamal.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Obx(() {
                if (controller.loading.isTrue)
                  return CircularLoadingWidget(height: 300);
                else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFieldWidget(
                        labelText: "Email Address".tr,
                        hintText: "johndoe@gmail.com".tr,
                        // initialValue: "provider@demo.com",
                        onChanged: (input) =>
                            controller.currentUser.value.email = input,
                        onSaved: (input) =>
                            controller.currentUser.value.email = input,
                        validator: (input) => !input.contains('@')
                            ? "Should be a valid email".tr
                            : null,
                        iconData: Icons.alternate_email,
                      ),
                      Obx(() {
                        return TextFieldWidget(
                          labelText: "Password".tr,
                          hintText: "••••••••••••".tr,
                          // initialValue: "password",
                          onChanged: (input) =>
                              controller.currentUser.value.password = input,
                          onSaved: (input) =>
                              controller.currentUser.value.password = input,
                          validator: (input) => input.length < 3
                              ? "Should be more than 3 characters".tr
                              : null,
                          obscureText: controller.hidePassword.value,
                          iconData: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.hidePassword.value =
                                  !controller.hidePassword.value;
                            },
                            color: Theme.of(context).focusColor,
                            icon: Icon(controller.hidePassword.value
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined),
                          ),
                        );
                      }),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     BlockButtonWidget(
                      //       onPressed: () {
                      //         controller.roleSelected = 0.obs;
                      //         controller.choosenrole.value = role.user;
                      //         print(controller.choosenrole);
                      //       },
                      //       color: controller.choosenrole.value == role.company
                      //           ? Colors.grey.withOpacity(0.5)
                      //           : Get.theme.colorScheme.secondary,
                      //       text: Text(
                      //         "    مستخدم    ".tr,
                      //         style: Get.textTheme.headline6.merge(
                      //             TextStyle(color: Get.theme.primaryColor)),
                      //       ),
                      //     ),
                      //     BlockButtonWidget(
                      //       onPressed: () {
                      //         controller.roleSelected = 1.obs;
                      //         controller.choosenrole.value = role.company;
                      //         print(controller.choosenrole);
                      //       },
                      //       color: controller.choosenrole.value != role.company
                      //           ?Colors.grey.withOpacity(0.5)
                      //           : Get.theme.colorScheme.secondary,
                      //       text: Text(
                      //         "    مقدم خدمة    ".tr,
                      //         style: Get.textTheme.headline6.merge(
                      //             TextStyle(color: Get.theme.primaryColor)),
                      //       ),
                      //     ).paddingSymmetric(vertical: 10, horizontal: 20),
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Get.toNamed(Routes.FORGOT_PASSWORD);
                            },
                            child: Text("Forgot Password?".tr),
                          ),
                        ],
                      ).paddingSymmetric(horizontal: 20),
                      BlockButtonWidget(
                        onPressed: () {

                          controller.login();
                        },
                        color: Get.theme.colorScheme.secondary,
                        text: Text(
                          "Login".tr,
                          style: Get.textTheme.headline6
                              .merge(TextStyle(color: Get.theme.primaryColor)),
                        ),
                      ).paddingSymmetric(vertical: 10, horizontal: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              showAnimatedDialog(
                                context: context,
                                // barrierDismissible: false,
                                builder: (BuildContext context) {
                                  return Center(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      height:
                                      MediaQuery.of(context).size.height *
                                          0.4,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          image: DecorationImage(
                                            image: AssetImage(
                                                "assets/img/makeup.png"),
                                            fit: BoxFit.cover,
                                          )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 80,
                                            ),
                                            ElevatedButton(
                                                onPressed: () {
                                                  var box = GetStorage();
                                                  box.remove("addressRegister");
                                                  box.remove(
                                                      "addressRegisterLong");
                                                  box.remove(
                                                      "addressRegisterLat");
                                                  box.write(
                                                      'roleRegister', '1');
                                                  Get.toNamed(Routes.REGISTER);
                                                },
                                                child: Text('مستخدم')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  var box = GetStorage();
                                                  box.remove("addressRegister");
                                                  box.remove(
                                                      "addressRegisterLong");
                                                  box.remove(
                                                      "addressRegisterLat");
                                                  box.write(
                                                      'roleRegister', '3');
                                                  Get.toNamed(Routes.REGISTER);
                                                },
                                                child: Text('مقدم خدمة - عمل حر')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  var box = GetStorage();
                                                  box.remove("addressRegister");
                                                  box.remove(
                                                      "addressRegisterLong");
                                                  box.remove(
                                                      "addressRegisterLat");
                                                  box.write(
                                                      'roleRegister', '2');
                                                  Get.toNamed(Routes.REGISTER);
                                                },
                                                child:
                                                Text('مقدم خدمة - مركز')),

                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                animationType:
                                DialogTransitionType.slideFromRight,
                                curve: Curves.easeOutSine,
                                duration: Duration(seconds: 1),
                              );
                            },
                            child: Text("You don't have an account?".tr),
                          ),
                        ],
                      ).paddingSymmetric(vertical: 20),
                    ],
                  );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
