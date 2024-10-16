import 'package:flutter/material.dart' as _i5;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i6;
import 'package:vendors/ui/views/intro/intro_view.dart' as _i2;

import 'package:vendors/ui/views/sign_in/sign_in_view.dart' as _i4;
import 'package:vendors/ui/views/sign_up/sign_up_view.dart' as _i3;
import 'package:vendors/ui/views/vendor/VendorView.dart' as _i5;
import 'package:vendors/ui/views/profile/ProfileView.dart' as _i7;
import 'package:vendors/ui/views/vendorDetails/vendordetailsView.dart' as _i8;
import 'package:vendors/ui/views/cart/CartView.dart' as _i9;
import 'package:vendors/ui/views/orders/userorderview.dart' as _i9;

class Routes {
  static const introView = '/';
  static const signUpView = '/sign-up-view';
  static const signInView = '/sign-in-view';
  static const vendorView = '/vendor-view';
  static const profileView = '/profile-view';
  static const vendorDetailsView = '/vendor-details-view';
  static const cartView = '/cart-view';
  static const UserOrderView = '/vendor-order-view';

  static const all = <String>{
    introView,
    signUpView,
    signInView,
    vendorView,
    profileView,
    vendorDetailsView,
    cartView,
    UserOrderView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.introView,
      page: _i2.IntroView,
    ),
    _i1.RouteDef(
      Routes.signUpView,
      page: _i3.SignUpView,
    ),
    _i1.RouteDef(
      Routes.signInView,
      page: _i4.SignInView,
    ),
    _i1.RouteDef(
      Routes.vendorView,
      page: _i5.VendorView,
    ),
    _i1.RouteDef(
      Routes.profileView,
      page: _i7.ProfileView,
    ),
    _i1.RouteDef(
      Routes.vendorDetailsView,
      page: _i8.VendorDetailsView,
    ),
    _i1.RouteDef(
      Routes.cartView,
      page: _i9.CartView,
    ),
    _i1.RouteDef(
      Routes.UserOrderView,
      page: _i9.UserOrderView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.IntroView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.IntroView(),
        settings: data,
      );
    },
    _i3.SignUpView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.SignUpView(),
        settings: data,
      );
    },
    _i4.SignInView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.SignInView(),
        settings: data,
      );
    },
    _i5.VendorView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.VendorView(),
        settings: data,
      );
    },
    _i7.ProfileView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ProfileView(),
        settings: data,
      );
    },
    _i8.VendorDetailsView: (data) {
      final vendorId = data.arguments as String;
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.VendorDetailsView(vendorId: vendorId),
        settings: data,
      );
    },
    _i9.CartView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.CartView(),
        settings: data,
      );
    },
    _i9.UserOrderView: (data) {
      return _i5.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.UserOrderView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

extension NavigatorStateExtension on _i6.NavigationService {
  Future<dynamic> navigateToIntroView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.introView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignUpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signUpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSignInView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.signInView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCartView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.cartView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVendorView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.vendorView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToProfileView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.profileView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToVendorDetailsView({
    required String vendorId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.vendorDetailsView,
        arguments: vendorId,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUserOrderView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.UserOrderView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
