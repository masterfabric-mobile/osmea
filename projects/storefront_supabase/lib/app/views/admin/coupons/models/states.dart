import 'package:storefront_supabase/app/models/coupon.dart';

abstract class AdminCouponsState {}

class AdminCouponsInitial extends AdminCouponsState {}

class AdminCouponsLoading extends AdminCouponsState {}

class AdminCouponsLoaded extends AdminCouponsState {
  final List<Coupon> coupons;
  final bool isLoading;

  AdminCouponsLoaded({
    required this.coupons,
    this.isLoading = false,
  });

  AdminCouponsLoaded copyWith({
    List<Coupon>? coupons,
    bool? isLoading,
  }) {
    return AdminCouponsLoaded(
      coupons: coupons ?? this.coupons,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AdminCouponsError extends AdminCouponsState {
  final String message;
  AdminCouponsError(this.message);
}
