import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/ui.dart';

import '../models/e_service_model.dart';
import '../models/media_model.dart';
import '../modules/e_provider/widgets/review_item_widget.dart';
import '../modules/e_service/controllers/e_service_controller.dart';
import '../modules/e_service/widgets/e_provider_item_widget.dart';
import '../modules/e_service/widgets/e_service_til_widget.dart';
import '../modules/e_service/widgets/e_service_title_bar_widget.dart';
import '../modules/e_service/widgets/option_group_item_widget.dart';
import '../modules/global_widgets/block_button_widget.dart';
import '../modules/global_widgets/circular_loading_widget.dart';
import '../modules/global_widgets/image_field_widget.dart';
import '../providers/laravel_provider.dart';
import '../routes/app_routes.dart';
import '../services/auth_service.dart';

class EServiceFreelancerView extends GetView<EServiceController> {
  var name = TextEditingController();
  var description = TextEditingController();
  var duration = TextEditingController();
  var price = TextEditingController();
  var capacity = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var _eService = controller.eService.value;
      description =
          TextEditingController(text: controller.eService.value.description);
      name = TextEditingController(text: controller.eService.value.name);
      duration =
          TextEditingController(text: controller.eService.value.duration);
      price = TextEditingController(
          text: controller.eService.value.price.toString());
      capacity = TextEditingController(
          text: controller.eService.value.capacity.toString());
      controller.imagePicked.value =
          Media(thumb: controller.eService.value.images[0].thumb);
      controller.inHome.value =
          controller.eService.value.inHome == 0 ? false : true;
      controller.inCenter.value =
          controller.eService.value.inCenter == 0 ? false : true;
      if (!_eService.hasData) {
        return Scaffold(
          body: CircularLoadingWidget(height: Get.height),
        );
      } else {
        return controller.editing.value == false
            ? Scaffold(
                body: RefreshIndicator(
                    onRefresh: () async {
                      Get.find<LaravelApiClient>().forceRefresh();
                      controller.refreshEService(showMessage: true);
                      Get.find<LaravelApiClient>().unForceRefresh();
                    },
                    child: CustomScrollView(
                      primary: true,
                      shrinkWrap: false,
                      slivers: <Widget>[
                        SliverAppBar(
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          expandedHeight: 310,
                          elevation: 0,
                          floating: true,
                          iconTheme: IconThemeData(
                              color: Theme.of(context).primaryColor),
                          centerTitle: true,
                          automaticallyImplyLeading: false,
                          leading: new IconButton(
                            icon: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Get.theme.primaryColor
                                          .withOpacity(0.5),
                                      blurRadius: 20,
                                    ),
                                  ]),
                              child: new Icon(Icons.arrow_back_ios,
                                  color: Get.theme.hintColor),
                            ),
                            onPressed: () => {Get.back()},
                          ),
                          actions: [
                            new IconButton(
                              icon: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Get.theme.primaryColor
                                            .withOpacity(0.5),
                                        blurRadius: 20,
                                      ),
                                    ]),
                                child: (_eService?.isFavorite ?? false)
                                    ? Icon(Icons.favorite,
                                        color: Colors.redAccent)
                                    : Icon(Icons.favorite_outline,
                                        color: Get.theme.hintColor),
                              ),
                              onPressed: () {
                                if (!Get.find<AuthService>().isAuth) {
                                  Get.toNamed(Routes.LOGIN);
                                } else {
                                  if (_eService?.isFavorite ?? false) {
                                    controller.removeFromFavorite();
                                  } else {
                                    controller.addToFavorite();
                                  }
                                }
                              },
                            ).marginSymmetric(horizontal: 10),
                          ],
                          bottom: buildEServiceTitleBarWidget(_eService),
                          flexibleSpace: FlexibleSpaceBar(
                            collapseMode: CollapseMode.parallax,
                            background: Obx(() {
                              return Stack(
                                alignment: AlignmentDirectional.bottomCenter,
                                children: <Widget>[
                                  buildCarouselSlider(_eService),
                                  buildCarouselBullets(_eService),
                                ],
                              );
                            }),
                          ).marginOnly(bottom: 50),
                        ),
                        SliverToBoxAdapter(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(height: 10),
                              EServiceTilWidget(
                                title: Text("Description".tr,
                                    style: Get.textTheme.subtitle2),
                                content: Obx(() {
                                  if (controller.eService.value.description ==
                                      '') {
                                    return SizedBox();
                                  }
                                  return controller.editing == Rx(false)
                                      ? Ui.applyHtml(_eService.description,
                                          style: Get.textTheme.bodyText1)
                                      : TextFormField(
                                          // initialValue: _eService.description,
                                          controller: description, maxLines: 7,
                                        );
                                }),
                              ),
                              buildDuration(_eService),
                              buildWhere(_eService)
                            ],
                          ),
                        ),
                      ],
                    )),
              )
            : Scaffold(
                appBar: AppBar(
                  title: Text(
                    "Update".tr + " " + "Service".tr,
                  ),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Obx(() => ImageFieldWidget(
                            label: "ServicePhoto".tr,
                            field: 'avatar',
                            initialImage: controller.imagePicked.value,
                            uploadCompleted: (uuid) {
                              controller.imagePicked.value =
                                  new Media(id: uuid);
                            },
                            reset: (uuid) {
                              controller.imagePicked.value = new Media(
                                  thumb: controller.imagePicked.value.thumb);
                            },
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: Ui.getBoxDecoration(),
                        child: TextFormField(
                          controller: name,
                          decoration: InputDecoration(
                            label: Text(
                              "ServiceName".tr,
                              style: TextStyle(fontSize: 16),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: Ui.getBoxDecoration(),
                        child: TextFormField(
                          controller: price,
                          decoration: InputDecoration(
                            label: Text(
                              "Price".tr,
                              style: TextStyle(fontSize: 16),
                            ),
                            suffixText: "sar".tr,
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: Ui.getBoxDecoration(),
                        child: TextFormField(
                            controller: capacity,
                            decoration: InputDecoration(
                              label: Text(
                                "Capacity".tr,
                                style: TextStyle(fontSize: 16),
                              ),
                              border: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              errorBorder: InputBorder.none,
                              disabledBorder: InputBorder.none,
                            )),
                      ),
                      Obx(() => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Checkbox(
                                  value: controller.inHome.value,
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all(
                                      Get.theme.colorScheme.secondary),
                                  onChanged: (value) {
                                    controller.inHome.value = value;
                                  }),
                              Text("inHome".tr),
                              Checkbox(
                                  value: controller.inCenter.value,
                                  checkColor: Colors.white,
                                  fillColor: MaterialStateProperty.all(
                                      Get.theme.colorScheme.secondary),
                                  onChanged: (value) {
                                    controller.inCenter.value = value;
                                  }),
                              Text("inCenter".tr),
                            ],
                          )),
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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

                            duration.text =
                                // resultingDuration.inHours.toString() +
                                //     ":" +
                                resultingDuration.inMinutes.toString() +
                                    " " +
                                    "minutes".tr;
                          },
                          child: TextFormField(
                              controller: duration,
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
                      Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        decoration: Ui.getBoxDecoration(),
                        child: TextFormField(
                          controller: description,
                          maxLines: 7,
                          decoration: InputDecoration(
                            label: Text(
                              "Description".tr,
                              style: TextStyle(fontSize: 16),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      Obx(
                        () => controller.loading.isTrue
                            ? CircularLoadingWidget()
                            : MaterialButton(
                                onPressed: () {
                                  controller.loading.value = true;
                                  _eService.name = name.text;
                                  _eService.duration = duration.text;
                                  _eService.price = double.parse(price.text);
                                  final box = GetStorage();
                                  var catId = box.read("categoryId");
                                  controller.editEService(_eService, catId);
                                  print(_eService);
                                  print(controller.loading.value);
                                  controller.loading.value = false;
                                  print(controller.loading.value);
                                },
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 4),
                                color: Get.theme.colorScheme.secondary,
                                disabledElevation: 0,
                                disabledColor: Get.theme.focusColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.6,
                                    child: Text(
                                      "تعديل".tr,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ),
                      ),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  ),
                ),
              );
      }
    });
  }

  Container buildDuration(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("Duration".tr, style: Get.textTheme.subtitle2),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          // Container(width:200,child: TextFormField(controller: duration,)), for edit and create¬
          controller.editing != RxBool(true)
              ? Text(_eService.duration, style: Get.textTheme.headline6)
              : Container(
                  width: 50,
                  child: TextFormField(
                    controller: duration,
                  )),
        ],
      ),
    );
  }

  Container buildWhere(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: Ui.getBoxDecoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text("خدمة منزلية".tr, style: Get.textTheme.subtitle2),
                Text(_eService.inHome.toString() == "0" ? "no".tr : "yes".tr,
                    style: Get.textTheme.headline6),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Text("خدمة في المركز".tr, style: Get.textTheme.subtitle2),
                Text(_eService.inCenter.toString() == "0" ? "no".tr : "yes".tr,
                    style: Get.textTheme.headline6),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ],
      ),
    );
  }

  CarouselSlider buildCarouselSlider(EService _eService) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 7),
        height: 370,
        viewportFraction: 1.0,
        onPageChanged: (index, reason) {
          controller.currentSlide.value = index;
        },
      ),
      items: _eService.images.map((Media media) {
        return Builder(
          builder: (BuildContext context) {
            return Hero(
              tag: controller.heroTag.value + _eService.id,
              child: CachedNetworkImage(
                width: double.infinity,
                height: 350,
                fit: BoxFit.cover,
                imageUrl: media.url,
                placeholder: (context, url) => Image.asset(
                  'assets/img/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error_outline),
              ),
            );
          },
        );
      }).toList(),
    );
  }

  Container buildCarouselBullets(EService _eService) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 100, horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _eService.images.map((Media media) {
          return Container(
            width: 20.0,
            height: 5.0,
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                color: controller.currentSlide.value ==
                        _eService.images.indexOf(media)
                    ? Get.theme.hintColor
                    : Get.theme.primaryColor.withOpacity(0.4)),
          );
        }).toList(),
      ),
    );
  }

  EServiceTitleBarWidget buildEServiceTitleBarWidget(EService _eService) {
    return EServiceTitleBarWidget(
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _eService.name ?? '',
                    style:
                        Get.textTheme.headline5.merge(TextStyle(height: 1.1)),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.fade,
                  ),
                ),
                controller.editing.value == false
                    ? InkWell(
                        onTap: () {
                          controller.editing.value = true;
                        },
                        child: Icon(Icons.edit_outlined),
                      )
                    : InkWell(
                        onTap: () {
                          controller.editing.value = false;
                        },
                        child: Icon(Icons.clear),
                      )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Expanded(
                child: Wrap(
                  crossAxisAlignment: WrapCrossAlignment.end,
                  children: List.from(Ui.getStarsList(_eService.rate))
                    ..addAll([
                      SizedBox(width: 5),
                      Text(
                        "Reviews (%s)"
                            .trArgs([_eService.totalReviews.toString()]),
                        style: Get.textTheme.caption,
                      ),
                    ]),
                ),
              ),
              Ui.getPrice(_eService.getPrice,
                  style: Get.textTheme.headline3
                      .merge(TextStyle(color: Get.theme.colorScheme.secondary)),
                  unit: _eService.getUnit)
            ],
          ),
          Row(
            children: [
              Text(' عدد الأشخاص في الجلسة:'),
              Text(_eService.capacity.toString()),
            ],
          ),
        ],
      ),
    );
  }
}
