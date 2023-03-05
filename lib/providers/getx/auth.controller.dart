import 'package:get/get.dart';
import 'package:my_memo/services/auth.service.dart';

import '../../models/user.model.dart';

class AuthController extends GetxController {
  static AuthController to = Get.find();

  final authService = AuthService();
  late final Rx<User> me;// = User(name: '').obs;

  @override
  void onInit() {
    me = authService.me().obs;
    super.onInit();
  }

  void setMe({required String name}) {
    var newMe = authService.setMe(User(name: name));
    me.update((val) {
      val!.name = newMe.name;
    });
  }
}