import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../modules/category/controllers/category_controller.dart';

import '../modules/global_widgets/circular_loading_widget.dart';
import '../providers/laravel_provider.dart';
import '../repositories/e_service_repository.dart';
import '../routes/app_routes.dart';
import 'ServiceWidget.dart';

class CategoryServicesDetails extends GetView<CategoryController> {
  var storage = GetStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.colorScheme.secondary,
              expandedHeight: 60,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Text(
                controller.category.value.name,
                style: Get.textTheme.headline6
                    .merge(TextStyle(color: Get.theme.primaryColor)),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    color: Get.theme.primaryColor),
                onPressed: () => {Get.back()},
              ),

              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      // Container(
                      //   width: double.infinity,
                      //   decoration: new BoxDecoration(
                      //     gradient: new LinearGradient(
                      //         colors: [
                      //           Color(0xffFCE1B5).withOpacity(1),
                      //           Color(0xffFCE1B5),
                      //         ],
                      //         begin: AlignmentDirectional.topStart,
                      //         //const FractionalOffset(1, 0),
                      //         // end: AlignmentDirectional.bottomEnd,
                      //         stops: [0.1, 0.9],
                      //         tileMode: TileMode.clamp),
                      //   ),
                      //   child: (controller.category.value.image.url
                      //           .toLowerCase()
                      //           .endsWith('.svg')
                      //       ? SvgPicture.network(
                      //           controller.category.value.image.url,
                      //           color: controller.category.value.color,
                      //         )
                      //       : CachedNetworkImage(
                      //           fit: BoxFit.fitHeight,
                      //           height: double.infinity,
                      //           imageUrl: controller.category.value.image.url,
                      //           placeholder: (context, url) => Image.asset(
                      //             'assets/img/loading.gif',
                      //             fit: BoxFit.fitHeight,
                      //           ),
                      //           errorWidget: (context, url, error) =>
                      //               Icon(Icons.error_outline),
                      //         )),
                      // ),
                    ],
                  )),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  // AddressWidget(),
                  Center(
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        height: 50,
                        child: MaterialButton(
                          // padding:
                          //     EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                          color: Get.theme.colorScheme.secondary,
                          onPressed: () {
                            final box = GetStorage();
                            box.write("categoryId",
                                controller.category.value.id.toString());
                            Get.toNamed(Routes.ADDSERVICEFREELANCER,
                                arguments: {'heroTag': 'service_list_item'});
                          },
                          disabledElevation: 0,
                          minWidth: MediaQuery.of(context).size.width * 0.9,
                          disabledColor: Get.theme.focusColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "إضافة خدمة جديدة",
                            style: Get.textTheme.headline6.merge(TextStyle(
                                color: Get.theme.primaryColor, fontSize: 12)),
                          ),
                        )),
                  ),
                  storage.read("role") != "3"
                      ? Container(
                          height: 60,
                          child: ListView(
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                  CategoryFilter.values.length, (index) {
                                var _filter =
                                    CategoryFilter.values.elementAt(index);
                                return Obx(() {
                                  return Padding(
                                    padding: const EdgeInsetsDirectional.only(
                                        start: 20),
                                    child: RawChip(
                                      elevation: 0,
                                      label: Text(_filter.toString() ==
                                              "CategoryFilter.CENTER"
                                          ? "الخدمات في المركز"
                                          : "الخدمات المنزلية"),
                                      labelStyle: controller.isSelected(_filter)
                                          ? Get.textTheme.bodyText2.merge(
                                              TextStyle(
                                                  color:
                                                      Get.theme.primaryColor))
                                          : Get.textTheme.bodyText2,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 15),
                                      backgroundColor: Theme.of(context)
                                          .focusColor
                                          .withOpacity(0.1),
                                      selectedColor: Color(0xffDE8B61),
                                      selected: controller.isSelected(_filter),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      showCheckmark: true,
                                      checkmarkColor: Get.theme.primaryColor,
                                      onSelected: (bool value) {
                                        controller.toggleSelected(_filter);
                                        controller.loadEServicesOfCategory(
                                            controller.category.value.id,
                                            filter: controller.selected.value);
                                      },
                                    ),
                                  );
                                });
                              })),
                        )
                      : Container(),
                  Obx(() {
                    if (controller.eServices.isEmpty) {
                      return CircularLoadingWidget(height: 300);
                    } else {
                      return ListView.builder(
                        padding: EdgeInsets.only(bottom: 10, top: 10),
                        primary: false,
                        shrinkWrap: true,
                        itemCount: controller.eServices.length + 1,
                        itemBuilder: ((_, index) {
                          if (index == controller.eServices.length) {
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
                          } else {
                            var _service =
                                controller.eServices.elementAt(index);

                            return ServicesListItemFreeLancerWidget(
                                service: _service,
                                delete: () async {
                                  // controller.isLoading.value = true;

                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text("deleteservice".tr),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text(
                                                'yes'.tr,
                                              ),
                                              onPressed: () async {
                                                Navigator.of(context).pop();

                                                controller.eServices
                                                    .removeAt(index);
                                                EServiceRepository
                                                    _eServiceRepository =
                                                    new EServiceRepository();
                                                print(index);
                                                await _eServiceRepository
                                                    .deleteEservice(_service);
                                                // controller.isLoading.value = false;
                                                controller.eServices
                                                    .remove(_service);
                                              },
                                            ),
                                            TextButton(
                                                child: Text('no'.tr),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                }),
                                          ],
                                        );
                                      });
                                });
                          }
                        }),
                      );
                    }
                  })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
