import 'package:apis/apis.dart';
import 'package:apis/network/remote/billing/recurring_application_charge/abstract/recurring_application_charge_service.dart';
import 'package:example/services/api_service_registry.dart';
import 'package:get_it/get_it.dart';
import '../../../api_request_handler.dart';
import 'package:flutter/material.dart';

/// ******************************************************************
/// ************* 🗑️ DELETE RECURRING APPLICATION CHARGE HANDLER 🗑️ ********
/// ******************************************************************

class DeleteRecurringApplicationChargeHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
      String method, Map<String, dynamic> params) async {
    try {
      if (method == 'DELETE') {
        // Get charge ID from params and validate
        final idStr = params['id'] as String?;
        
        if (idStr == null || idStr.isEmpty) {
          return {
            "status": "error",
            "message": "Recurring Application Charge ID is required",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        // Parse the ID from string to int, with error handling
        int id;
        try {
          id = int.parse(idStr);
        } catch (e) {
          return {
            "status": "error",
            "message": "Invalid Recurring Application Charge ID: must be a number",
            "timestamp": DateTime.now().toIso8601String(),
          };
        }
        
        debugPrint('🗑️ Deleting recurring application charge with ID: $id');
        
        // Call the API service
        final service = GetIt.I.get<DeleteRecurringApplicationChargeService>();
        await service.deleteRecurringApplicationCharge(
          apiVersion: ApiNetwork.apiVersion,
          id: id,
        );
        
        debugPrint('✅ Successfully deleted recurring application charge');
        
        // Format the success response
        return {
          "status": "success",
          "message": "Recurring application charge deleted successfully",
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
      
      return {
        "status": "error",
        "message": "Method $method not supported. Use DELETE instead.",
        "timestamp": DateTime.now().toIso8601String(),
      };
    } catch (e) {
      debugPrint('❌ Error deleting recurring application charge: ${e.toString()}');
      return {
        "status": "error",
        "message": "Failed to delete recurring application charge: ${e.toString()}",
        "apiVersion": ApiNetwork.apiVersion,
        "params": params,
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  @override
  List<String> get supportedMethods => ['DELETE'];

  @override
  Map<String, List<ApiField>> get requiredFields => {
    'DELETE': [
      const ApiField(
        name: 'id',
        label: 'Recurring Application Charge ID',
        hint: 'ID of the specific recurring application charge to delete',
        isRequired: true,
      ),
    ],
  };
}