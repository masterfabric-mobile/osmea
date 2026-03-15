import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:injectable/injectable.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_coupons_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/coupon.dart';
import 'module/states.dart';

@injectable
class AddCouponViewModel extends BaseViewModelCubit<AddCouponState> {
  AddCouponViewModel() : super(AddCouponInitial());

  AdminCouponsService get _coupons => getIt<AdminCouponsService>();

  final codeController = TextEditingController();
  final valueController = TextEditingController();
  final minPurchaseController = TextEditingController();
  final usageLimitController = TextEditingController();
  
  String discountType = 'percentage'; // Default
  DateTime? expiryDate;
  bool isActive = true;

  Future<void> initial({String? couponId}) async {
    stateChanger(AddCouponLoading());
    try {
      Coupon? coupon;
      if (couponId != null) {
        coupon = await _coupons.getCoupon(couponId);
        if (coupon != null) _populateFields(coupon);
      }
      stateChanger(AddCouponLoaded(coupon: coupon));
    } catch (e) {
      stateChanger(AddCouponError('Failed to load coupon: $e'));
    }
  }

  void _populateFields(Coupon coupon) {
    codeController.text = coupon.code;
    discountType = coupon.discountType;
    valueController.text = coupon.discountValue.toString();
    minPurchaseController.text = coupon.minimumPurchase?.toString() ?? '';
    usageLimitController.text = coupon.usageLimit?.toString() ?? '';
    expiryDate = coupon.expiryDate;
    isActive = coupon.isActive;
  }

  void setDiscountType(String? type) {
    if (type != null) discountType = type;
  }

  void setExpiryDate(DateTime? date) {
    expiryDate = date;
  }

  void toggleActive(bool value) {
    isActive = value;
  }

  Future<void> saveCoupon({String? couponId}) async {
    if (codeController.text.isEmpty || valueController.text.isEmpty) {
      stateChanger(AddCouponError('Code and Discount Value are required.'));
      // Revert to Loaded to allow editing, maybe use a snackbar trigger instead of full error state
      // For simplicity in this structure, going to Error state is standard but requires "Retry/Back".
      // Better: Emit Loaded with error message.
      stateChanger(AddCouponLoaded(errorMessage: 'Code and Discount Value are required.'));
      return;
    }

    stateChanger(AddCouponLoading());

    try {
      final now = DateTime.now().toUtc().toIso8601String();
      final data = <String, dynamic>{
        'code': codeController.text.trim().toUpperCase(),
        'discount_type': discountType,
        'discount_value': double.parse(valueController.text),
        'minimum_purchase': minPurchaseController.text.isNotEmpty ? double.parse(minPurchaseController.text) : null,
        'usage_limit': usageLimitController.text.isNotEmpty ? int.parse(usageLimitController.text) : null,
        'expiry_date': expiryDate?.toIso8601String(),
        'is_active': isActive,
        'updated_at': now,
        if (couponId == null) 'created_at': now,
      };

      if (couponId != null) {
        await _coupons.updateCoupon(couponId, data);
      } else {
        await _coupons.createCoupon(data);
      }

      stateChanger(AddCouponSuccess());
    } catch (e) {
      stateChanger(AddCouponError('Failed to save coupon: $e'));
    }
  }

  @override
  Future<void> close() {
    codeController.dispose();
    valueController.dispose();
    minPurchaseController.dispose();
    usageLimitController.dispose();
    return super.close();
  }
}
