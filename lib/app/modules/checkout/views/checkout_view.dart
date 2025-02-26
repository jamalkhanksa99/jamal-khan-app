import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/booking_model.dart';
import '../../../payment/payment.dart';
import '../../global_widgets/block_button_widget.dart';
import '../../global_widgets/circular_loading_widget.dart';
import '../controllers/checkout_controller.dart';
import '../widgets/payment_details_widget.dart';
import '../widgets/payment_method_item_widget.dart';

class CheckoutView extends GetView<CheckoutController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Checkout".tr,
          style: context.textTheme.headline6,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back_ios, color: Get.theme.hintColor),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadPaymentMethodsList();
          await controller.loadWalletList();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Obx(() {
            if (controller.isLoading.isTrue) {
              return CircularLoadingWidget(height: 200);
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 0),
                    leading: Icon(
                      Icons.payment,
                      color: Get.theme.hintColor,
                    ),
                    title: Text(
                      "Payment Option".tr,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.headline5,
                    ),
                    subtitle: Text("سيتم الدفع عن طريق الدفع الالكتروني المقدم من ميسر",
                        style: Get.textTheme.caption),
                  ),
                ),
                // ListView.separated(
                //   scrollDirection: Axis.vertical,
                //   shrinkWrap: true,
                //   primary: false,
                //   itemCount: controller.paymentsList.length,
                //   separatorBuilder: (context, index) {
                //     return SizedBox(height: 10);
                //   },
                //   itemBuilder: (context, index) {
                //     var _paymentMethod = controller.paymentsList.elementAt(index);
                //    if(_paymentMethod.id==7) return  PaymentMethodItemWidget(paymentMethod: _paymentMethod);
                //   },
                // ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: buildBottomWidget(Get.arguments as Booking, context),
    );
  }

  Widget buildBottomWidget(Booking _booking, BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Get.theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
              color: Get.theme.focusColor.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          PaymentDetailsWidget(booking: _booking),
          BlockButtonWidget(
              text: Stack(
                alignment: AlignmentDirectional.centerEnd,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "Confirm & Pay Now".tr,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.headline6.merge(
                        TextStyle(color: Get.theme.primaryColor),
                      ),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios,
                      color: Get.theme.primaryColor, size: 20)
                ],
              ),
              color: Get.theme.colorScheme.secondary,
              onPressed: () {
print(controller.selectedPaymentMethod.value.id);
print(_booking);
               // if(controller.selectedPaymentMethod.value.id==7)
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => PaymentScreen(
                          price: _booking.getTotal(),
                          moyasarPrice: _booking.getTotal() * 100,
                          booking: _booking,
                        )));

               // else controller.payBooking(_booking);
              }).paddingSymmetric(vertical: 10, horizontal: 20),
        ],
      ),
    );
  }
}
