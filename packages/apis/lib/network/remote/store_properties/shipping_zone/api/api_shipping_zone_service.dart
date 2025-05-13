// api/api_shipping_zone_service.dart

import 'package:apis/apis.dart';
import 'package:apis/dio_config/api_dio_client.dart';
import 'package:apis/network/remote/store_properties/shipping_zone/abstract/shipping_zone_service.dart';
import 'package:apis/network/remote/store_properties/shipping_zone/freezed_model/receive_list_of_shipping_zones_response.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/http.dart';

part 'api_shipping_zone_service.g.dart';

@RestApi()
@Injectable(as: ShippingZoneService)
abstract class ShippingZoneServiceClient implements ShippingZoneService {
  @factoryMethod
  factory ShippingZoneServiceClient(Dio dio) => _ShippingZoneServiceClient(
        ApiDioClient.starter(),
        baseUrl: ApiNetwork.baseUrl,
      );

  @override
  @GET('/api/{api_version}/shipping_zones.json')
  Future<ReceiveListOfShippingZonesResponse> receiveListOfShippingZones({
    @Path('api_version') required String apiVersion,
  });
}
