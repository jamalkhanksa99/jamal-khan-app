import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';
import '../controllers/home_controller.dart';

class CategoriesCarouselWidget extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      margin: EdgeInsets.only(bottom: 15),
      child: Obx(() {
        return ListView.builder(
            primary: false,
            shrinkWrap: false,
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (_, index) {
              var _category = controller.categories.elementAt(index);
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.CATEGORY, arguments: _category);
                  },
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child:
                            (_category.image.url.toLowerCase().endsWith('.svg')
                                ? SvgPicture.network(
                                    _category.image.url,
                                    color: _category.color,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  )
                                : CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                    imageUrl: _category.image.url,
                                    placeholder: (context, url) => Image.asset(
                                      'assets/img/loading.gif',
                                      fit: BoxFit.cover,
                                      height: 100,
                                      width: 100,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error_outline),
                                  )),
                      ),
                      Container(
                        width: 100,
                        child: Text(
                          _category.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          style: Get.textTheme.bodyText2
                              .merge(TextStyle(color: Colors.black54)),
                        ),
                      ),
                      // Container(
                      //   width: 100,
                      //   height: 100,
                      //   margin: EdgeInsetsDirectional.only(end: 20, start: index == 0 ? 20 : 0),
                      //   padding: EdgeInsets.symmetric(vertical: 10),
                      //   decoration: new BoxDecoration(
                      //     gradient: new LinearGradient(
                      //         colors: [Color(0xffEE9F76).withOpacity(1), Color(0xffEE9F76).withOpacity(0.9)],
                      //         begin: AlignmentDirectional.topStart,
                      //         //const FractionalOffset(1, 0),
                      //         end: AlignmentDirectional.bottomEnd,
                      //         stops: [0.1, 0.9],
                      //         tileMode: TileMode.clamp),
                      //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //   ),
                      //   child: Stack(
                      //     alignment: AlignmentDirectional.topStart,
                      //     children: [
                      //       // Padding(
                      //       //   padding: EdgeInsetsDirectional.only(start: 30, top: 30),
                      //       //   child: ClipRRect(
                      //       //     borderRadius: BorderRadius.all(Radius.circular(10)),
                      //       //     child: (_category.image.url.toLowerCase().endsWith('.svg')
                      //       //         ? SvgPicture.network(
                      //       //             _category.image.url,
                      //       //             color: _category.color,
                      //       //       height: 100,fit: BoxFit.cover,
                      //       //           )
                      //       //         : CachedNetworkImage(
                      //       //       height: 100,width: 100,      fit: BoxFit.cover,
                      //       //             imageUrl: _category.image.url,
                      //       //             placeholder: (context, url) => Image.asset(
                      //       //               'assets/img/loading.gif',
                      //       //               fit: BoxFit.cover,height: 100,width: 100,
                      //       //             ),
                      //       //             errorWidget: (context, url, error) => Icon(Icons.error_outline),
                      //       //           )),
                      //       //   ),
                      //       // ),
                      //       // Padding(
                      //       //   padding: const EdgeInsetsDirectional.only(start: 10, top: 0),
                      //       //   child: Text(
                      //       //     _category.name,
                      //       //     maxLines: 2,
                      //       //     style: Get.textTheme.bodyText2.merge(TextStyle(color: Get.theme.primaryColor)),
                      //       //   ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}

class CategoriesCarouselWidget2 extends GetWidget<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 1.0,
            childAspectRatio: 0.95,
            physics: NeverScrollableScrollPhysics(),
            children: List.generate(controller.categories.length, (index) {
              var _category = controller.categories.elementAt(index);
              return InkWell(
                onTap: () {
                  Get.toNamed(Routes.CATEGORYSERVICES, arguments: _category);
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: (_category.image.url.toLowerCase().endsWith('.svg')
                          ? SvgPicture.network(
                              _category.image.url,
                              color: _category.color,
                              height: 100,
                              fit: BoxFit.cover,
                            )
                          : CachedNetworkImage(
                              width: 160,
                              height: 130,
                              fit: BoxFit.cover,
                              imageUrl: _category.image.url,
                              placeholder: (context, url) => Image.asset(
                                'assets/img/loading.gif',
                                fit: BoxFit.cover,
                                height: 100,
                                width: 100,
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error_outline),
                            )),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Container(
                      width: 100,
                      child: Text(
                        _category.name,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: Get.textTheme.bodyText2
                            .merge(TextStyle(color: Colors.black54)),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      );
    });
  }
}
