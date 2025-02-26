/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/settings_service.dart';
import '../custom_pages/views/custom_page_drawer_link_widget.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {
  var store = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          Obx(() {
            if (!Get.find<AuthService>().isAuth) {
              return GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Color(0xffEE9F76),
                    image: new DecorationImage(
                      image: AssetImage("assets/img/drawer_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Welcome".tr,
                          style: Get.textTheme.headline5.merge(TextStyle(
                              color: Get.theme.colorScheme.secondary))),
                      SizedBox(height: 5),
                      Text("Login account or create new one for free".tr,
                          style: Get.textTheme.bodyText1),
                      SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.toNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined,
                                    color: Get.theme.primaryColor, size: 24),
                                Text(
                                  "Login".tr,
                                  style: Get.textTheme.subtitle1.merge(
                                      TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              showAnimatedDialog(
                                context: context,
                                barrierDismissible: false,
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
                                                child: Text('مقدم خدمة -عمل حر')),
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
                              // Get.toNamed(Routes.REGISTER);
                            },
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined,
                                    color: Get.theme.hintColor, size: 24),
                                Text(
                                  "Register".tr,
                                  style: Get.textTheme.subtitle1.merge(
                                      TextStyle(color: Get.theme.hintColor)),
                                ),
                              ],
                            ),
                            shape: StadiumBorder(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  // await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xffEE9F76),
                    image: new DecorationImage(
                      image: AssetImage("assets/img/drawer_background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  accountEmail: Text(
                    Get.find<AuthService>().user.value.email,
                    style: TextStyle(color: Colors.white70),
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(80)),
                          child: CachedNetworkImage(
                            height: 80,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            imageUrl:
                                Get.find<AuthService>().user.value.avatar.thumb,
                            placeholder: (context, url) => Image.asset(
                              'assets/img/loading.gif',
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 80,
                            ),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error_outline),
                          ),
                        ),
                      ),
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      // )
                    ],
                  ),
                ),
              );
            }
          }),
          SizedBox(height: 20),
          DrawerLinkWidget(
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) async {
              Get.back();
              var storage = GetStorage();
              storage.read("role") == "1"
                  ? await Get.find<RootController>().changePage(0)
                  : await Get.find<RootController>().changePage(4);
            },
          ),

          store.read("role").toString() == "1"
              ? DrawerLinkWidget(
                  icon: Icons.folder_special_outlined,
                  text: "Categories",
                  onTap: (e) {
                    Get.offAndToNamed(Routes.CATEGORIES);
                  },
                )
              : Container(),
          DrawerLinkWidget(
            icon: Icons.assignment_outlined,
            text: "Bookings",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(1);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.notifications_none_outlined,
            text: "Notifications",
            onTap: (e) {
              Get.offAndToNamed(Routes.NOTIFICATIONS);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.favorite_outline,
            text: "Favorites",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.FAVORITES);
            },
          ),
          // DrawerLinkWidget(
          //   icon: Icons.chat_outlined,
          //   text: "Messages",
          //   onTap: (e) async {
          //     Get.back();
          //     await Get.find<RootController>().changePage(2);
          //   },
          // ),
          ListTile(
            dense: true,
            title: Text(
              "Application preferences".tr,
              style: TextStyle(color: Colors.black),
            ),
          ),
          // DrawerLinkWidget(
          //   icon: Icons.account_balance_wallet_outlined,
          //   text: "Wallets",
          //   onTap: (e) async {
          //     await Get.offAndToNamed(Routes.WALLETS);
          //   },
          // ),
          DrawerLinkWidget(
            icon: Icons.person_outline,
            text: "Account",
            onTap: (e) async {
              Get.back();
              await Get.find<RootController>().changePage(6);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.settings_outlined,
            text: "Settings",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS);
            },
          ),

          DrawerLinkWidget(
            icon: Icons.translate_outlined,
            text: "Languages",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.SETTINGS_LANGUAGE);
            },
          ),
          // DrawerLinkWidget(
          //   icon: Icons.brightness_6_outlined,
          //   text: Get.isDarkMode ? "Light Theme" : "Dark Theme",
          //   onTap: (e) async {
          //     await Get.offAndToNamed(Routes.SETTINGS_THEME_MODE);
          //   },
          // ),
          ListTile(
            dense: true,
            title: Text(
              "Help & Privacy".tr,
              style:
                  Get.textTheme.caption.merge(TextStyle(color: Colors.black)),
            ),
            trailing: Icon(
              Icons.remove,
              color: Get.theme.focusColor.withOpacity(0.3),
            ),
          ),
          DrawerLinkWidget(
            icon: Icons.help_outline,
            text: "Help & FAQ".tr,
            onTap: (e) async {
              await Get.offAndToNamed(Routes.HELP);
            },
          ),
          DrawerLinkWidget(
            icon: Icons.announcement_outlined,
            text: "Complaints",
            onTap: (e) async {
              await Get.offAndToNamed(Routes.COMPLAINTS);
            },
          ),
          CustomPageDrawerLinkWidget(),
          Obx(() {
            if (Get.find<AuthService>().isAuth) {
              return DrawerLinkWidget(
                icon: Icons.logout,
                text: "Logout",
                onTap: (e) async {
                  var storage = GetStorage();
                  storage.remove("apiToken");
                  storage.remove("role");
                  await Get.find<AuthService>().removeCurrentUser();
                  Get.back();
                  await Get.find<RootController>().changePage(0);
                },
              );
            } else {
              return SizedBox(height: 0);
            }
          }),
          if (Get.find<SettingsService>().setting.value.enableVersion)
            ListTile(
              dense: true,
              title: Text(
                "Version".tr +
                    " " +
                    Get.find<SettingsService>().setting.value.appVersion,
                style:
                    Get.textTheme.caption.merge(TextStyle(color: Colors.black)),
              ),
              trailing: Icon(
                Icons.remove,
                color: Get.theme.focusColor.withOpacity(0.3),
              ),
            )
        ],
      ),
    );
  }
}
