import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/e_service_model.dart';
import '../../../models/favorite_model.dart';
import '../../../models/media_model.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/review_model.dart';
import '../../../repositories/e_service_repository.dart';
import '../../../routes/app_routes.dart';
import '../../../services/auth_service.dart';
import '../../favorites/controllers/favorites_controller.dart';

class EServiceController extends GetxController {

  final eService = EService().obs;

  final tag = "image".obs;

  final inHome = false.obs;

  final inCenter = true.obs;

  final reviews = <Review>[].obs;

  var imagePicked = new Media().obs;

  final optionGroups = <OptionGroup>[].obs;

  final currentSlide = 0.obs;

  final quantity = 1.obs;

  final heroTag = ''.obs;

  var editing = false.obs;

  var loading = false.obs;

  EServiceRepository _eServiceRepository;

  EServiceController() {
    _eServiceRepository = new EServiceRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    eService.value = arguments['eService'] as EService;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshEService();
    super.onReady();
  }

  Future refreshEService({bool showMessage = false}) async {
    await getEService();
    await getReviews();
    await getOptionGroups();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              eService.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getEService() async {
    try {
      eService.value = await _eServiceRepository.get(eService.value.id);
    } catch (e) {
      print(e.toString());
      // Get.showSnackbar(Ui.ErrorSnackBar(message:"error1"+ e.toString()));
    }
  }

  // mariam's work here to add a new service
  Future addEService(EService eService, String categoryId, Media uuid) async {
    try {
      loading.value = true;
      int inHome2;
      int inCenter2;

      inHome == false || inHome == null ? inHome2 = 0 : inHome2 = 1;
      inCenter == false || inCenter == null ? inCenter2 = 0 : inCenter2 = 1;
      print(inHome2);
      print("*****");
      print(inCenter2);
      await _eServiceRepository.add(
          eService, categoryId, inHome2, inCenter2, uuid);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      loading.value = false;
    }
  }

  Future editEService(EService eService, String categoryId) async {loading.value = true;
    try {
      loading.value = true;
      int inHome2;
      int inCenter2;
      inHome == false || inHome == null ? inHome2 = 0 : inHome2 = 1;
      inCenter == false || inCenter == null ? inCenter2 = 0 : inCenter2 = 1;
      eService.inHome = inHome2;
      eService.inCenter = inCenter2;
      print(inHome2);
      print("*****");
      print(inCenter2);
      Get.showSnackbar(Ui.LoadingSnackBar());

      await _eServiceRepository.edit(eService, categoryId, imagePicked.value);
      // Get.toNamed(Routes.CATEGORYSERVICES,
      //     arguments: {'eService': eService, 'heroTag': 'service_list_item'});
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      // loading.value = false;
    }
  }

  Future getReviews() async {
    try {
      reviews
          .assignAll(await _eServiceRepository.getReviews(eService.value.id));
    } catch (e) {
      print(e.toString());
      // Get.showSnackbar(Ui.ErrorSnackBar(message:"error3"+ e.toString()));
    }
  }

  Future getOptionGroups() async {
    try {
      var _optionGroups =
          await _eServiceRepository.getOptionGroups(eService.value.id);
      optionGroups.assignAll(_optionGroups.map((element) {
        element.options
            .removeWhere((option) => option.eServiceId != eService.value.id);
        return element;
      }));
    } catch (e) {
      print(e.toString());
      // Get.showSnackbar(Ui.ErrorSnackBar(message:"error33"+ e.toString()));
    }
  }

  Future addToFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        eService: this.eService.value,
        userId: Get.find<AuthService>().user.value.id,
        options: getCheckedOptions(),
      );
      await _eServiceRepository.addFavorite(_favorite);
      eService.update((val) {
        val.isFavorite = true;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(
          message: this.eService.value.name + " Added to favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future removeFromFavorite() async {
    try {
      Favorite _favorite = new Favorite(
        eService: this.eService.value,
        userId: Get.find<AuthService>().user.value.id,
      );
      await _eServiceRepository.removeFavorite(_favorite);
      eService.update((val) {
        val.isFavorite = false;
      });
      if (Get.isRegistered<FavoritesController>()) {
        Get.find<FavoritesController>().refreshFavorites();
      }
      Get.showSnackbar(Ui.SuccessSnackBar(
          message:
              this.eService.value.name + " Removed from favorite list".tr));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectOption(OptionGroup optionGroup, Option option) {
    optionGroup.options.forEach((e) {
      if (!optionGroup.allowMultiple && option != e) {
        e.checked.value = false;
      }
    });
    option.checked.value = !option.checked.value;
  }

  List<Option> getCheckedOptions() {
    if (optionGroups.isNotEmpty) {
      return optionGroups
          .map((element) => element.options)
          .expand((element) => element)
          .toList()
          .where((option) => option.checked.value)
          .toList();
    }
    return [];
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyText2
          .merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyText2;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.caption
          .merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.caption;
  }

  Color getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void currentlyEditing() {
    print("yes");
    editing = RxBool(true);
    // notifyChildrens();
  }

  void currentlyNotEditing() {
    print("no");
    editing = RxBool(false);
    // notifyChildrens();
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
  }
}
