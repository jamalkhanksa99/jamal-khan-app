import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/e_service_model.dart';
import '../models/media_model.dart';
import '../modules/e_service/controllers/e_service_controller.dart';
import '../modules/global_widgets/block_button_widget.dart';
import '../modules/global_widgets/image_field_widget.dart';
import 'package:duration_picker/duration_picker.dart';


class AddServicesScreen extends GetView<EServiceController> {
  var name = new TextEditingController();
  var price = new TextEditingController();
  var capacity = new TextEditingController();
  var sessionDuration = new TextEditingController();
  var description = new TextEditingController();
  var priceUnit = new TextEditingController();
  var uuid = new Media().obs;
  EServiceController controller_e_service = Get.put(EServiceController());
  var durationDate = DateTime.fromMillisecondsSinceEpoch(
    0,
  );

  final GlobalKey<FormState> servicekey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("إضافة خدمة جديدة"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Form(
            key: servicekey,
            child: Column(
              children: [
                Obx(
                  () => ImageFieldWidget(
                    label: "ServicePhoto".tr,
                    field: 'avatar',
                    tag: controller_e_service.tag.value,
                    uploadCompleted: (uuid) {
                      print(uuid);
                      // this.uuid = uuid;
                      controller_e_service.imagePicked.value =
                          new Media(id: uuid);
                    },
                    reset: (uuid) {
                      this.uuid = null;
                      controller_e_service.imagePicked.value = null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: TextFormField(
                            controller: name,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Required".tr;
                              return null;
                            },
                            style: TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              filled: true,
                              labelText: 'ServiceName'.tr,
                              fillColor: Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide.none),
                            )),
                      ),
                      // SizedBox(
                      //   height: 20,
                      // ),

                      Obx(() {
                        var storage = GetStorage();
                        if (storage.read("role") == "3")
                          controller_e_service.inHome.value = true;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            storage.read("role") != "3"
                                ? Checkbox(
                                    value: controller_e_service.inCenter.value,
                                    checkColor: Colors.white,
                                    fillColor: MaterialStateProperty.all(
                                        Get.theme.colorScheme.secondary),
                                    onChanged: (value) {
                                      controller_e_service.inCenter.value =
                                          value;
                                    })
                                : Container(),
                            storage.read("role") != "3"
                                ? Text("inCenter".tr)
                                : Container(),
                            Checkbox(
                                value: controller_e_service.inHome.value,
                                checkColor: Colors.white,
                                fillColor: MaterialStateProperty.all(
                                    Get.theme.colorScheme.secondary),
                                onChanged: (value) {
                                  controller_e_service.inHome.value = value;
                                  if (storage.read("role") == "3") {
                                    controller_e_service.inHome.value = true;
                                  }
                                }),
                            Text("inHome".tr),
                          ],
                        );
                      }),
                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: TextFormField(
                            controller: price,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Required".tr;
                              return null;
                            },
                            style: TextStyle(fontSize: 14),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              filled: true,
                              labelText: 'Price'.tr,
                              suffix: Text('ر.س./ ساعة'.tr),
                              fillColor: Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide.none),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: TextFormField(
                            controller: capacity,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Required".tr;
                              return null;
                            },
                            style: TextStyle(fontSize: 14),
                            keyboardType: TextInputType.numberWithOptions(),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              filled: true,
                              labelText: 'Capacity'.tr,
                              suffix: Text('شخص'.tr),
                              fillColor: Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide.none),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: InkWell(
                          onTap: () async {
                            var resultingDuration = await showDurationPicker(
                              context: context,
                              initialTime: Duration(minutes: 30),
                            );

                            sessionDuration.text =
                                // resultingDuration.inHours.toString() +
                                //     ":" +
                                resultingDuration.inMinutes.toString() +
                                    " " +
                                    "minutes".tr;
                          },
                          child: TextFormField(
                              controller: sessionDuration,
                              validator: (value) {
                                if (value == null || value == "")
                                  return "Required".tr;
                                return null;
                              },
                              enabled: false,
                              style: TextStyle(fontSize: 14),
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.all(8.0),
                                filled: true,
                                hintText: "00:00",
                                labelText: 'Duration'.tr,
                                fillColor: Color(0xFFFFFFFFF),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                    borderSide: BorderSide.none),
                              )),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                  color: Get.theme.focusColor.withOpacity(0.1),
                                  blurRadius: 10,
                                  offset: Offset(0, 5)),
                            ],
                            border: Border.all(
                                color: Get.theme.focusColor.withOpacity(0.05))),
                        child: TextFormField(
                            controller: description,
                            maxLines: 8,
                            validator: (value) {
                              if (value == null || value == "")
                                return "Required".tr;
                              return null;
                            },
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(8.0),
                              filled: true,
                              labelText: 'Description'.tr,
                              fillColor: Color(0xFFFFFFFF),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide.none),
                            )),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Obx(() {
                        return controller_e_service.loading.isTrue
                            ? CircularProgressIndicator()
                            : BlockButtonWidget(
                                onPressed: () {
                                  if (servicekey.currentState.validate()) {
                                    var _eService = EService(
                                        name: name.text,
                                        capacity: int.parse(capacity.text),
                                        duration: sessionDuration.text,
                                        price: double.parse(price.text),
                                        description: description.text);
                                    final box = GetStorage();
                                    var catId = box.read("categoryId");
                                    controller_e_service.addEService(
                                        _eService,
                                        catId,
                                        controller_e_service.imagePicked.value);

                                    name.clear();
                                    sessionDuration.clear();
                                    price.clear();
                                    capacity.clear();
                                    description.clear();
                                    print(controller_e_service.loading);
                                  }
                                },
                                color: Get.theme.colorScheme.secondary,
                                text: Container(
                                    height: 24,
                                    alignment: Alignment.center,
                                    child: Text(
                                      "Confirm".tr,
                                      style: TextStyle(color: Colors.white),
                                    )));
                      }),
                      SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
