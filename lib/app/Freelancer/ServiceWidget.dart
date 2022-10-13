/*
 * Copyright (c) 2020 .
 */

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';

import '../models/e_service_model.dart';
import '../modules/global_widgets/block_button_widget.dart';
import '../repositories/e_service_repository.dart';
import '../routes/app_routes.dart';

class ServicesListItemFreeLancerWidget extends StatelessWidget {
  const ServicesListItemFreeLancerWidget({
    Key key,
    @required EService service,
    @required Function delete,
  })
      : _service = service,
        delete = delete;

  final EService _service;
  final Function delete;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Get.toNamed(Routes.E_SERVICE,
        //     arguments: {'eService': _service, 'heroTag': 'service_list_item'});
        Get.toNamed(Routes.E_SERVICEFREELANCER,
            arguments: {'eService': _service, 'heroTag': 'service_list_item'});
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: Ui.getBoxDecoration(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Hero(
                  tag: 'service_list_item' + _service.id,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 140,
                      width: 80,
                      fit: BoxFit.cover,
                      imageUrl: _service.firstImageUrl,
                      placeholder: (context, url) =>
                          Image.asset(
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
                // if (_service.eProvider.available)
                //   Container(
                //     width: 80,
                //     child: Text("Available".tr,
                //         maxLines: 1,
                //         style: Get.textTheme.bodyText2.merge(
                //           TextStyle(
                //               color: Colors.green, height: 1.4, fontSize: 10),
                //         ),
                //         softWrap: false,
                //         textAlign: TextAlign.center,
                //         overflow: TextOverflow.fade),
                //     decoration: BoxDecoration(
                //       color: Colors.green.withOpacity(0.2),
                //       borderRadius: BorderRadius.only(
                //           bottomRight: Radius.circular(10),
                //           bottomLeft: Radius.circular(10)),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //   ),
                // if (!_service.eProvider.available)
                //   Container(
                //     width: 80,
                //     child: Text("Offline".tr,
                //         maxLines: 1,
                //         style: Get.textTheme.bodyText2.merge(
                //           TextStyle(
                //               color: Colors.grey, height: 1.4, fontSize: 10),
                //         ),
                //         softWrap: false,
                //         textAlign: TextAlign.center,
                //         overflow: TextOverflow.fade),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.withOpacity(0.2),
                //       borderRadius: BorderRadius.only(
                //           bottomRight: Radius.circular(10),
                //           bottomLeft: Radius.circular(10)),
                //     ),
                //     padding: EdgeInsets.symmetric(horizontal: 5, vertical: 6),
                //   ),
              ],
            ),
            SizedBox(width: 12),
            Expanded(
              child: Wrap(
                runSpacing: 10,
                alignment: WrapAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width * 0.35,
                        child: Text(
                          _service.name,
                          style: Get.textTheme.bodyText2,
                          maxLines: 3,
                          // textAlign: TextAlign.end,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 5,
                            children: [
                              SizedBox(
                                height: 32,
                                child: Chip(
                                  padding: EdgeInsets.all(0),
                                  label: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.star,
                                        color: Get.theme.colorScheme.secondary,
                                        size: 18,
                                      ),
                                      Text(_service.rate.toString(),
                                          style: Get.textTheme.bodyText2.merge(
                                              TextStyle(
                                                  color: Get.theme.colorScheme
                                                      .secondary,
                                                  height: 1.4))),
                                    ],
                                  ),
                                  backgroundColor: Get
                                      .theme.colorScheme.secondary
                                      .withOpacity(0.15),
                                  shape: StadiumBorder(),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(height: 8, thickness: 1),
               Ui.getPrice(
                      _service.price, style: Get.textTheme.headline6),
                  _service.eProvider.firstAddress != "" ?     Row(
                    children: [
                      Icon(
                        Icons.place_outlined,
                        size: 18,
                        color: Get.theme.focusColor,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          // TODO eProvider address
                          _service.eProvider.firstAddress,
                          maxLines: 1,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          style: Get.textTheme.bodyText1,
                        ),
                      ),
                    ],
                  ):Container(),
                  MaterialButton(
                    onPressed: () {
                      Get.toNamed(Routes.E_SERVICEFREELANCER, arguments: {
                        'eService': _service,
                        'heroTag': 'service_list_item'
                      });
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    color: Get.theme.colorScheme.secondary,
                    disabledElevation: 0,
                    disabledColor: Get.theme.focusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "تعديل",
                      style: Get.textTheme.headline6.merge(TextStyle(
                          color: Get.theme.primaryColor, fontSize: 10)),
                    ),
                    elevation: 0,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  MaterialButton(
                    onPressed: delete,
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                    color: Get.theme.colorScheme.secondary,
                    disabledElevation: 0,
                    disabledColor: Get.theme.focusColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "حذف",
                      style: Get.textTheme.headline6.merge(TextStyle(
                          color: Get.theme.primaryColor, fontSize: 10)),
                    ),
                    elevation: 0,
                  ),
                  // Divider(height: 8, thickness: 1),
                  // Wrap(
                  //   spacing: 5,
                  //   children: List.generate(_service.categories.length, (index) {
                  //     return Container(
                  //       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  //       child: Text(_service.categories.elementAt(index).name, style: Get.textTheme.caption.merge(TextStyle(fontSize: 10))),
                  //       decoration: BoxDecoration(
                  //           color: Get.theme.primaryColor,
                  //           border: Border.all(
                  //             color: Get.theme.focusColor.withOpacity(0.2),
                  //           ),
                  //           borderRadius: BorderRadius.all(Radius.circular(20))),
                  //     );
                  //   }),
                  //   runSpacing: 5,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
