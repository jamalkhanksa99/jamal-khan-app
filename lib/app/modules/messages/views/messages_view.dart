import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../global_widgets/circular_loading_widget.dart';
import '../../global_widgets/notifications_button_widget.dart';
import '../controllers/messages_controller.dart';
import '../widgets/message_item_widget.dart';

class MessagesView extends GetView<MessagesController> {

  Widget conversationsList() {
    // Get.lazyPut(()=>MessagesController());
    return Obx(
      () {
        if (controller.messages.isNotEmpty) {
          var _messages = controller.messages;
          print(_messages.length);
          print(_messages);
          return ListView.separated(
              physics: AlwaysScrollableScrollPhysics(),
              controller: controller.scrollController,
              itemCount: _messages.length,
              separatorBuilder: (context, index) {
                return SizedBox(height: 7);
              },
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                if (index == controller.messages.length + 1) {
                  // return Text("hohohho");
                  return Obx(() {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Center(
                        child: new Opacity(
                          opacity: controller.isLoading.value ? 1 : 0,
                          child: new CircularProgressIndicator(),
                        ),
                      ),
                    );
                  });
                }
                else {
                  // return Text("hihihi");
                  return MessageItemWidget(
                    message: controller.messages.elementAt(index),
                    onDismissed: (conversation) async {
                      await controller.deleteMessage(controller.messages.elementAt(index));
                    },
                  );
                }
              });
        } else {
          print("empty");
          return CircularLoadingWidget(
            height: Get.height,
            onCompleteText: "Messages List Empty".tr,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Chats".tr,
          style: Get.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Color(0xffFCE1B5),
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.sort, color: Get.theme.hintColor),
          onPressed: () => {Scaffold.of(context).openDrawer()},
        ),
        actions: [NotificationsButtonWidget()],
      ),
      body: RefreshIndicator(
          onRefresh: () async {
            controller.messages.clear();
            controller.lastDocument = new Rx<DocumentSnapshot>(null);
            await controller.listenForMessages();
          },
          child: conversationsList()),
    );
  }
}
