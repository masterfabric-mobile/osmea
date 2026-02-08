import 'package:storefront_supabase/app/models/coupon.dart';

abstract class AddCouponState {}

class AddCouponInitial extends AddCouponState {}

class AddCouponLoading extends AddCouponState {}

class AddCouponLoaded extends AddCouponState {
  final Coupon? coupon; // If editing
  final String? errorMessage;

  AddCouponLoaded({this.coupon, this.errorMessage});
}

class AddCouponSuccess extends AddCouponState {}

class AddCouponError extends AddCouponState {
  final String message;
  AddCouponError(this.message);
}
