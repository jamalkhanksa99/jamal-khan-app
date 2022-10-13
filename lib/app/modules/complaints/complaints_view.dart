import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/media_model.dart';
import '../global_widgets/circular_loading_widget.dart';
import '../global_widgets/image_field_widget.dart';
import 'complaints_controller.dart';

class ComplaintsView extends GetView<ComplaintsController> {
  ComplaintsView({Key key}) : super(key: key);

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();

  @override
  Widget build(BuildContext context) {
    controller.complaintForm = GlobalKey<FormState>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Complaints".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFCE1B5),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => {Get.back()},
        ),
      ),
      body: SingleChildScrollView(
        child: Obx(() {
          if (controller.loading.isTrue) {
            return CircularLoadingWidget(height: 300);
          } else {
            return Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.05,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: title,
                      keyboardType: TextInputType.multiline,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'ComplaintsTitle'.tr,

                        hintStyle: TextStyle(color: Color(0xffDE8B61)),
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.white,
                        filled: true,
                        // enabled: false,
                        focusColor: Color(0xffDE8B61),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                      ),
                      onSaved: (input) {
                        title.text = input;
                        input = controller.complaints.value.title;
                      },
                      validator: (input) => input.length < 3
                          ? "Should be more than 3 characters".tr
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextFormField(
                      controller: description,
                      keyboardType: TextInputType.multiline,
                      maxLines: 7,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'ComplaintsContent'.tr,
                        hintStyle: TextStyle(color: Color(0xffDE8B61)),
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        fillColor: Colors.white,
                        filled: true,
                        // enabled: false,
                        focusColor: Color(0xffDE8B61),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(color: Color(0xffDE8B61))),
                      ),
                      onSaved: (input) {
                        description.text = input;
                        input = controller.complaints.value.description;
                      },
                      validator: (input) => input.length < 3
                          ? "Should be more than 3 characters".tr
                          : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 15, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("PhotoAttachments".tr),
                      ],
                    ),
                  ),
                  Obx(() {
                    return ImageFieldWidget(
                      label: "image".tr,
                      field: 'avatar',
                      tag: controller.complaintForm.hashCode.toString(),
                      initialImage: controller.imagePicked.value,
                      uploadCompleted: (uuid) {
                        controller.imagePicked.value = new Media(id: uuid);
                      },
                      reset: (uuid) {
                        controller.imagePicked.value = new Media(
                            thumb: controller.complaints.value.image.thumb);
                      },
                    );
                  }),
                  InkWell(
                    onTap: () {
                      // controller.loading.value = true;
                      controller.sendComplaint(title.text, description.text,
                          controller.complaints.value.image);
                      title.clear();
                      description.clear();
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.height * 0.05,
                      decoration: BoxDecoration(
                          color: Color(0xffDE8B61),
                          borderRadius: BorderRadius.circular(20)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'send'.tr,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        }),
      ),
    );
  }
}
