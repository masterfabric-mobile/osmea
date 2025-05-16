import 'package:apis/apis.dart';
import 'package:apis/network/remote/orders/order/abstract/order.dart';
import 'package:apis/network/remote/orders/order/freezed_model/request/create_order_partially_paid_request.dart';
import 'package:example/services/api_request_handler.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';

class CreateOrderPartiallyPaidHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, String> params) async {
    switch (method) {
      case 'POST':
        final String apiVersion =
            params['api_version'] ?? ApiNetwork.apiVersion;

        final String? customerFirstName = params['customer_first_name'];
        final String? customerLastName = params['customer_last_name'];
        final String? customerEmail = params['customer_email'];

        final String? billingAddressFirstName =
            params['billing_address_first_name'];
        final String? billingAddressLastName =
            params['billing_address_last_name'];
        final String? billingAddressAddress1 =
            params['billing_address_address1'];
        final String? billingAddressPhone = params['billing_address_phone'];
        final String? billingAddressCity = params['billing_address_city'];
        final String? billingAddressProvince =
            params['billing_address_province'];
        final String? billingAddressCountry = params['billing_address_country'];
        final String? billingAddressZip = params['billing_address_zip'];

        final String? shippingAddressFirstName =
            params['shipping_address_first_name'];
        final String? shippingAddressLastName =
            params['shipping_address_last_name'];
        final String? shippingAddressAddress1 =
            params['shipping_address_address1'];
        final String? shippingAddressPhone = params['shipping_address_phone'];
        final String? shippingAddressCity = params['shipping_address_city'];
        final String? shippingAddressProvince =
            params['shipping_address_province'];
        final String? shippingAddressCountry =
            params['shipping_address_country'];
        final String? shippingAddressZip = params['shipping_address_zip'];

        final String? email = params['email'];
        final String? financialStatus = params['financial_status'];

        final String? lineItemVariantIdStr = params['line_item_variant_id'];
        final String? lineItemQuantityStr = params['line_item_quantity'];

        final String? transactionKind = params['transaction_kind'];
        final String? transactionStatus = params['transaction_status'];
        final String? transactionAmountStr = params['transaction_amount'];

        if (customerFirstName == null ||
            customerFirstName.isEmpty ||
            customerLastName == null ||
            customerLastName.isEmpty ||
            customerEmail == null ||
            customerEmail.isEmpty ||
            billingAddressFirstName == null ||
            billingAddressFirstName.isEmpty ||
            billingAddressLastName == null ||
            billingAddressLastName.isEmpty ||
            billingAddressAddress1 == null ||
            billingAddressAddress1.isEmpty ||
            billingAddressPhone == null ||
            billingAddressPhone.isEmpty ||
            billingAddressCity == null ||
            billingAddressCity.isEmpty ||
            billingAddressProvince == null ||
            billingAddressProvince.isEmpty ||
            billingAddressCountry == null ||
            billingAddressCountry.isEmpty ||
            billingAddressZip == null ||
            billingAddressZip.isEmpty ||
            shippingAddressFirstName == null ||
            shippingAddressFirstName.isEmpty ||
            shippingAddressLastName == null ||
            shippingAddressLastName.isEmpty ||
            shippingAddressAddress1 == null ||
            shippingAddressAddress1.isEmpty ||
            shippingAddressPhone == null ||
            shippingAddressPhone.isEmpty ||
            shippingAddressCity == null ||
            shippingAddressCity.isEmpty ||
            shippingAddressProvince == null ||
            shippingAddressProvince.isEmpty ||
            shippingAddressCountry == null ||
            shippingAddressCountry.isEmpty ||
            shippingAddressZip == null ||
            shippingAddressZip.isEmpty ||
            email == null ||
            email.isEmpty ||
            financialStatus == null ||
            financialStatus.isEmpty ||
            lineItemVariantIdStr == null ||
            lineItemVariantIdStr.isEmpty ||
            lineItemQuantityStr == null ||
            lineItemQuantityStr.isEmpty ||
            transactionKind == null ||
            transactionKind.isEmpty ||
            transactionStatus == null ||
            transactionStatus.isEmpty ||
            transactionAmountStr == null ||
            transactionAmountStr.isEmpty) {
          return {
            "status": "error",
            "message": "All required fields must be provided",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

        try {
          final int? lineItemVariantId = int.tryParse(lineItemVariantIdStr);
          final int? lineItemQuantity = int.tryParse(lineItemQuantityStr);
          final int? transactionAmount = int.tryParse(transactionAmountStr);

          if (lineItemVariantId == null ||
              lineItemQuantity == null ||
              transactionAmount == null) {
            return {
              "status": "error",
              "message":
                  "Invalid number format for variant ID, quantity, or transaction amount",
              "timestamp": DateTime.now().toIso8601String(),
            };
          }

          final model = CreateOrderPartiallyPaidRequest(
            order: Order(
              customer: Customer(
                firstName: customerFirstName,
                lastName: customerLastName,
                email: customerEmail,
              ),
              billingAddress: IngAddress(
                firstName: billingAddressFirstName,
                lastName: billingAddressLastName,
                address1: billingAddressAddress1,
                phone: billingAddressPhone,
                city: billingAddressCity,
                province: billingAddressProvince,
                country: billingAddressCountry,
                zip: billingAddressZip,
              ),
              shippingAddress: IngAddress(
                firstName: shippingAddressFirstName,
                lastName: shippingAddressLastName,
                address1: shippingAddressAddress1,
                phone: shippingAddressPhone,
                city: shippingAddressCity,
                province: shippingAddressProvince,
                country: shippingAddressCountry,
                zip: shippingAddressZip,
              ),
              email: email,
              financialStatus: financialStatus,
              lineItems: [
                LineItem(
                  variantId: lineItemVariantId,
                  quantity: lineItemQuantity,
                ),
              ],
              transactions: [
                Transaction(
                  kind: transactionKind,
                  status: transactionStatus,
                  amount: transactionAmount,
                ),
              ],
            ),
          );

          final response = await GetIt.I
              .get<OrderService>()
              .createOrderPartiallyPaid(apiVersion: apiVersion, model: model);

          return {
            "status": "success",
            "message": "Partially paid order created successfully",
            "order": response.toJson(),
            "timestamp": DateTime.now().toIso8601String(),
          };
        } catch (e) {
          return {
            "status": "error",
            "message": "Failed to create partially paid order: ${e.toString()}",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }

      default:
        return {
          "error":
              "Method $method not supported for Create Partially Paid Order API",
        };
    }
  }

  @override
  List<String> get supportedMethods => ['POST'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
        'POST': [
          const ApiField(
              name: 'customer_first_name',
              label: 'Customer First Name',
              hint: 'Customer First Name'),
          const ApiField(
              name: 'customer_last_name',
              label: 'Customer Last Name',
              hint: 'Customer Last Name'),
          const ApiField(
              name: 'customer_email',
              label: 'Customer Email',
              hint: 'Customer Email'),
          const ApiField(
              name: 'billing_address_first_name',
              label: 'Billing First Name',
              hint: 'Billing First Name'),
          const ApiField(
              name: 'billing_address_last_name',
              label: 'Billing Last Name',
              hint: 'Billing Last Name'),
          const ApiField(
              name: 'billing_address_address1',
              label: 'Billing Address',
              hint: 'Billing Address'),
          const ApiField(
              name: 'billing_address_phone',
              label: 'Billing Phone',
              hint: 'Billing Phone'),
          const ApiField(
              name: 'billing_address_city',
              label: 'Billing City',
              hint: 'Billing City'),
          const ApiField(
              name: 'billing_address_province',
              label: 'Billing Province',
              hint: 'Billing Province'),
          const ApiField(
              name: 'billing_address_country',
              label: 'Billing Country',
              hint: 'Billing Country'),
          const ApiField(
              name: 'billing_address_zip',
              label: 'Billing Zip',
              hint: 'Billing Zip'),
          const ApiField(
              name: 'shipping_address_first_name',
              label: 'Shipping First Name',
              hint: 'Shipping First Name'),
          const ApiField(
              name: 'shipping_address_last_name',
              label: 'Shipping Last Name',
              hint: 'Shipping Last Name'),
          const ApiField(
              name: 'shipping_address_address1',
              label: 'Shipping Address',
              hint: 'Shipping Address'),
          const ApiField(
              name: 'shipping_address_phone',
              label: 'Shipping Phone',
              hint: 'Shipping Phone'),
          const ApiField(
              name: 'shipping_address_city',
              label: 'Shipping City',
              hint: 'Shipping City'),
          const ApiField(
              name: 'shipping_address_province',
              label: 'Shipping Province',
              hint: 'Shipping Province'),
          const ApiField(
              name: 'shipping_address_country',
              label: 'Shipping Country',
              hint: 'Shipping Country'),
          const ApiField(
              name: 'shipping_address_zip',
              label: 'Shipping Zip',
              hint: 'Shipping Zip'),
          const ApiField(name: 'email', label: 'Email', hint: 'Email'),
          const ApiField(
              name: 'financial_status',
              label: 'Financial Status',
              hint: 'Financial Status'),
          const ApiField(
              name: 'line_item_variant_id',
              label: 'Variant ID',
              hint: 'Variant ID'),
          const ApiField(
              name: 'line_item_quantity', label: 'Quantity', hint: 'Quantity'),
          const ApiField(
              name: 'transaction_kind',
              label: 'Transaction Kind',
              hint: 'Transaction Kind'),
          const ApiField(
              name: 'transaction_status',
              label: 'Transaction Status',
              hint: 'Transaction Status'),
          const ApiField(
              name: 'transaction_amount',
              label: 'Transaction Amount',
              hint: 'Transaction Amount'),
        ],
      };
}
