import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/phone_number.dart';

import '../../common/uuid.dart';
import '../services/settings_service.dart';
import 'media_model.dart';
import 'parents/model.dart';

class User extends Model {
  String name;
  String email;
  String password;
  Media avatar;

  String apiToken;
  String deviceToken;
  String phoneNumber;
  bool verifiedPhone;
  String verificationId;
  String address;
  String long;
  String lat;
  String availabilityRange;
  String bio;
  String role;
  String companyName;
  String taxNumber;

  bool auth;

  User(
      {this.name,
      this.email,
      this.password,
      this.apiToken,
      this.deviceToken,
      this.phoneNumber,
      this.verifiedPhone,
      this.verificationId,
      this.address,
        this.lat, this.long,
        this.availabilityRange, this.companyName, this.taxNumber,
      this.bio,
      this.avatar,
      this.role});

  User.fromJson(Map<String, dynamic> json) {
    name = stringFromJson(json, 'name');
    email = stringFromJson(json, 'email');
    apiToken = stringFromJson(json, 'api_token');
    var getStorage = GetStorage();
    getStorage.write("apiToken", this.apiToken);
    deviceToken = stringFromJson(json, 'device_token');
    address = stringFromJson(json, 'device_token');
    phoneNumber = stringFromJson(json, 'phone_number');
    verifiedPhone = boolFromJson(json, 'phone_verified_at');
    avatar = mediaFromJson(json, 'avatar');
    auth = boolFromJson(json, 'auth');
    companyName = stringFromJson(json, 'company_name');
    availabilityRange = stringFromJson(json, 'availability_range');
    long = stringFromJson(json, 'longitude');
    lat= stringFromJson(json, 'latitude');
    try {
      role = json['user_type']['id'].toString();
    } catch (e) {}

    try {
      address = json['custom_fields']['address']['view'];
    } catch (e) {
      address = stringFromJson(json, 'address');
    }
    try {
      bio = json['custom_fields']['bio']['view'];
    } catch (e) {
      bio = stringFromJson(json, 'bio');
    }
    super.fromJson(json);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    data['company_name'] = this.companyName;
    data['availability_range'] = this.availabilityRange;
    data['tax_number'] = this.taxNumber;
    if (password != null && password != '') {
      data['password'] = this.password;
    }
    data['api_token'] = this.apiToken;
    var getStorage = GetStorage();
    getStorage.write("apiToken", this.apiToken);
    if (deviceToken != null) {
      data["device_token"] = deviceToken;
    }
    data["phone_number"] = phoneNumber;
    if (verifiedPhone != null && verifiedPhone) {
      data["phone_verified_at"] = DateTime.now().toLocal().toString();
    }
    data["longitude"] = long;
    data["latitude"] = lat;
    data["address"] = address;
    data["bio"] = bio;
    if (this.avatar != null && Uuid.isUuid(avatar.id)) {
      data['avatar'] = this.avatar.id;
    }
    if (avatar != null) {
      data["media"] = [avatar.toJson()];
    }
    data['auth'] = this.auth;
    return data;
  }

  Map toRestrictMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["thumb"] = avatar.thumb;
    map["device_token"] = deviceToken;
    return map;
  }

  PhoneNumber getPhoneNumber() {
    if (this.phoneNumber != null) {
      this.phoneNumber = this.phoneNumber.replaceAll(' ', '');
      String dialCode1 = this.phoneNumber.substring(1, 2);
      String dialCode2 = this.phoneNumber.substring(1, 3);
      String dialCode3 = this.phoneNumber.substring(1, 4);
      for (int i = 0; i < countries.length; i++) {
        if (countries[i].dialCode == dialCode1) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode1,
              number: this.phoneNumber.substring(2));
        } else if (countries[i].dialCode == dialCode2) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode2,
              number: this.phoneNumber.substring(3));
        } else if (countries[i].dialCode == dialCode3) {
          return new PhoneNumber(
              countryISOCode: countries[i].code,
              countryCode: dialCode3,
              number: this.phoneNumber.substring(4));
        }
      }
    }
    return new PhoneNumber(
        countryISOCode:
            Get.find<SettingsService>().setting.value.defaultCountryCode,
        countryCode: '1',
        number: '');
  }

  @override
  bool operator ==(Object other) =>
      super == other &&
      other is User &&
      runtimeType == other.runtimeType &&
      name == other.name &&
      email == other.email &&
      password == other.password &&
      avatar == other.avatar &&
      apiToken == other.apiToken &&
      deviceToken == other.deviceToken &&
      phoneNumber == other.phoneNumber &&
      verifiedPhone == other.verifiedPhone &&
      verificationId == other.verificationId &&
      address == other.address &&
      bio == other.bio &&
      auth == other.auth;

  @override
  int get hashCode =>
      super.hashCode ^
      name.hashCode ^
      email.hashCode ^
      password.hashCode ^
      avatar.hashCode ^
      apiToken.hashCode ^
      deviceToken.hashCode ^
      phoneNumber.hashCode ^
      verifiedPhone.hashCode ^
      verificationId.hashCode ^
      address.hashCode ^
      bio.hashCode ^
      auth.hashCode;
}
