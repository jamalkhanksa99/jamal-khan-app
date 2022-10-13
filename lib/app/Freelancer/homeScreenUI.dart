import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../modules/global_widgets/home_search_bar_widget.dart';
import '../modules/global_widgets/notifications_button_widget.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/home/widgets/categories_carousel_widget.dart';
import '../providers/laravel_provider.dart';

class HomeFreelancer extends GetView<HomeController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
            Get.find<LaravelApiClient>().forceRefresh();
            await controller.refreshHome(showMessage: true);
            Get.find<LaravelApiClient>().unForceRefresh();
          },
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: Color(0xffFCE1B5),
                expandedHeight: 80,
                elevation: 0.5,
                floating: true,
                iconTheme: IconThemeData(color: Theme.of(context).primaryColor),
                title: Image(
                  image: AssetImage('assets/icon/jamal.png'),
                  height: 50,
                  width: 50,
                ),
                centerTitle: true,
                automaticallyImplyLeading: false,
                leading: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6)),
                  margin: EdgeInsets.all(8),
                  child: new IconButton(
                    icon: new Icon(Icons.sort, color: Color(0xffEE9F76)),
                    onPressed: () => {Scaffold.of(context).openDrawer()},
                  ),
                ),
                actions: [NotificationsButtonWidget()],
              ),
              SliverToBoxAdapter(
                child: Wrap(
                  children: [
                    Container(child: CategoriesCarouselWidget2()),
                  ],
                ),
              ),
            ],
          )),
    );
  }
}
