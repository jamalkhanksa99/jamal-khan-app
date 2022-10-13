import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../providers/laravel_provider.dart';
import '../../global_widgets/address_widget.dart';
import '../../global_widgets/home_search_bar_widget.dart';
import '../controllers/category_controller.dart';
import '../widgets/services_list_widget.dart';

class CategoryView extends GetView<CategoryController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          Get.find<LaravelApiClient>().forceRefresh();
          controller.refreshEServices(showMessage: true);
          Get.find<LaravelApiClient>().unForceRefresh();
        },
        child: CustomScrollView(
          controller: controller.scrollController,
          shrinkWrap: false,
          slivers: <Widget>[
            SliverAppBar(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              expandedHeight: 280,
              elevation: 0.5,
              primary: true,
              // pinned: true,
              floating: true,
              iconTheme: IconThemeData(color: Get.theme.primaryColor),
              title: Text(
                controller.category.value.name,
                style: Get.textTheme.headline6.merge(TextStyle(
                  color: Get.theme.primaryColor,
                  shadows: <Shadow>[
                    Shadow(
                      offset: Offset(0.3, 0.2),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),

                  ],
                )),
              ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back_ios,
                    color: Get.theme.primaryColor),
                onPressed: () => {Get.back()},
              ),
              bottom: HomeSearchBarWidget(),
              flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        width: double.infinity,
                        // padding: EdgeInsets.only(top: 75, bottom: 115),
                        decoration: new BoxDecoration(
                          gradient: new LinearGradient(
                              colors: [
                                Color(0xffFCE1B5).withOpacity(1),
                                Color(0xffFCE1B5),
                              ],
                              begin: AlignmentDirectional.topStart,
                              //const FractionalOffset(1, 0),
                              end: AlignmentDirectional.bottomEnd,
                              stops: [0.1, 0.9],
                              tileMode: TileMode.clamp),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(5),
                              topRight: Radius.circular(5)),
                        ),
                        child: (controller.category.value.image.url
                                .toLowerCase()
                                .endsWith('.svg')
                            ? SvgPicture.network(
                                controller.category.value.image.url,
                                color: controller.category.value.color,
                              )
                            : CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: controller.category.value.image.url,
                                placeholder: (context, url) => Image.asset(
                                  'assets/img/loading.gif',
                                  fit: BoxFit.cover,
                                ),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error_outline),
                              )),
                      ),
                    ],
                  )).marginOnly(bottom: 42),
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  AddressWidget(),
                  Container(
                    height: 60,
                    child: ListView(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        children: List.generate(CategoryFilter.values.length,
                            (index) {
                          var _filter = CategoryFilter.values.elementAt(index);
                          return Obx(() {
                            return Padding(
                              padding:
                                  const EdgeInsetsDirectional.only(start: 20),
                              child: RawChip(
                                elevation: 0,
                                label: Text(_filter.toString() ==
                                        "CategoryFilter.CENTER"
                                    ? "ServicesInCenter".tr
                                    : "ServicesInHome".tr),
                                labelStyle: controller.isSelected(_filter)
                                    ? Get.textTheme.bodyText2.merge(TextStyle(
                                        color: Get.theme.primaryColor))
                                    : Get.textTheme.bodyText2,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 15),
                                backgroundColor: Theme.of(context)
                                    .focusColor
                                    .withOpacity(0.1),
                                selectedColor: Color(0xffDE8B61),
                                selected: controller.isSelected(_filter),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
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
                  ),
                  ServicesListWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
