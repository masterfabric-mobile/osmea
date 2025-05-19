import 'package:apis/network/remote/store_properties/shipping_zone/freezed_model/receive_list_of_shipping_zones_response.dart';

/// 🌏 Abstract contract for Shipping Zone Service
/// Implement this to interact with Shopify Shipping Zones API
abstract class ShippingZoneService {
  /// 📋 Retrieve a list of shipping zones
  Future<ReceiveListOfShippingZonesResponse> receiveListOfShippingZones({
    required String apiVersion,
  });
}
