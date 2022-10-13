import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';

// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/booking_model.dart';

class PaymentScreen extends StatefulWidget {
  double price;
  double moyasarPrice;
  Booking booking;

  PaymentScreen({this.price, this.moyasarPrice, this.booking});

  @override
  PaymentScreenState createState() => PaymentScreenState();
}

class PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      platform = 1;
    } else if (Platform.isIOS) {
      platform = 2;
    }
  }

  final GlobalKey webViewKey = GlobalKey();

  String url = "";
  int platform = 1;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("الدفع"),
          centerTitle: true,automaticallyImplyLeading: false,
        ),
        body: SafeArea(
            child: Container(
          height: MediaQuery.of(context).size.height,
          child: WebView(
              initialUrl:
                  "https://jamal-khanah.das-360.net/payments/moyasar/process?order_id=${widget.booking.id}&order_amount=${widget.booking.payment.amount.floor()*100}&language=ar",

              // initialUrl: "http://handyman.smartersvision.com/mock/privacy/",
              javascriptMode: JavascriptMode.unrestricted,
          onPageStarted: (url){
                print(url);
                // if(url.toString().contains("service-order-callback")){
                //  Get.log("CONTAINS");
                // }
          },

          ),
          // child: InAppWebView(
          //   key: webViewKey,
          //   initialUrlRequest: URLRequest(
          //       url: Uri.parse("https://jamal-khanah.das-360.net/" +
          //           "payment/process?order_id=${widget.booking.id}&order_amount=${widget.moyasarPrice}&order_type=1&language=" +
          //           "ar")),
          //   initialOptions: options,
          //   onWebViewCreated: (controller) {
          //     webViewController = controller;
          //   },
          //   onLoadStart: (controller, url) {
          //     // if (url.toString().contains("appointment-plan-order-callback")) {
          //     //   sleep(const Duration(seconds: 10));
          //     //   Navigator.of(context).pushAndRemoveUntil(
          //     //     MaterialPageRoute(
          //     //         builder: (context) => PaymentStatus(
          //     //             orderid: widget.id,
          //     //             appointmentID: widget.appointmentID,
          //     //             appointmentType: widget.appointmentType)),
          //     //     (Route<dynamic> route) => false,
          //     //   );
          //     // }
          //   },
          //   androidOnPermissionRequest: (controller, origin, resources) async {
          //     return PermissionRequestResponse(
          //         resources: resources,
          //         action: PermissionRequestResponseAction.GRANT);
          //   },
          //   shouldOverrideUrlLoading: (controller, navigationAction) async {
          //     var uri = navigationAction.request.url;
          //
          //     if (![
          //       "http",
          //       "https",
          //       "file",
          //       "chrome",
          //       "data",
          //       "javascript",
          //       "about"
          //     ].contains(uri.scheme)) {
          //       if (await canLaunch(url)) {
          //         // Launch the App
          //         await launch(
          //           url,
          //         );
          //         // and cancel the request
          //         return NavigationActionPolicy.CANCEL;
          //       }
          //     }
          //
          //     return NavigationActionPolicy.ALLOW;
          //   },
          //   onLoadStop: (controller, url) async {
          //     if (url.toString().contains("appointment-plan-order-callback")) {
          //       sleep(const Duration(seconds: 3));
          //       // Navigator.of(context).pushAndRemoveUntil(
          //       //   MaterialPageRoute(
          //       //       builder: (context) => PaymentStatus(
          //       //           orderid: widget.id,
          //       //           appointmentID: widget.appointmentID,
          //       //           appointmentType: widget.appointmentType)),
          //       //       (Route<dynamic> route) => false,
          //       // );
          //     }
          //   },
          //   onLoadError: (controller, url, code, message) {},
          // ),
        )),
      ),
    );
  }
}
