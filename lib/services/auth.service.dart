import 'dart:convert';

import '../models/user.model.dart';

class AuthService {

  User me() {
    Map<String, dynamic> user = jsonDecode( '{ "name": "forrest" }' );
    return User.fromJson( user );
  }

  User setMe(User me) {
    return User.fromJson(me.toJson());
  }
}
