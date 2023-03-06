import 'package:flutter/foundation.dart';
import 'package:my_memo/services/auth.service.dart';

import '../../models/user.model.dart';

class AuthProvider with ChangeNotifier {

  final AuthService _authService = AuthService();
  final User _me = User(name: 'temp');// = User(name: '').obs;

  User get me => _me;

  void init() {
    _me.name = _authService.me().name;
  }

  void setMe({required String name}) {
    _me.name = _authService.setMe(User(name: name)).name;
    notifyListeners();
  }
}