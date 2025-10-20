import 'package:api_explorer/services/api_request_handler.dart';
import 'package:api_explorer/services/api_service_registry.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:apis/network/remote/woocommerce/store_api/product_reviews_api/abstract/store_product_reviews_service.dart';

///*******************************************************************
///******************* 📝 PRODUCT REVIEWS HANDLER *******************
///*******************************************************************

class ProductReviewsHandler implements ApiRequestHandler {
  @override
  Future<Map<String, dynamic>> handleRequest(
    String method,
    Map<String, String> params,
  ) async {
    if (method != 'GET') {
      return {
        "status": "error",
        "message": "Method $method not supported for Product Reviews API",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    // Validate required parameters
    if (!params.containsKey('api_version') || params['api_version']!.isEmpty) {
      return {
        "status": "error",
        "message": "API version is required",
        "timestamp": DateTime.now().toIso8601String(),
      };
    }

    try {
      final apiVersion = params['api_version']!;
      final context = params['context'];
      final page =
          params['page'] != null ? int.tryParse(params['page']!) : null;
      final perPage =
          params['per_page'] != null ? int.tryParse(params['per_page']!) : null;
      final search = params['search'];
      final exclude = params['exclude'] != null
          ? params['exclude']!
              .split(',')
              .map((e) => int.tryParse(e.trim()))
              .where((e) => e != null)
              .cast<int>()
              .toList()
          : null;
      final include = params['include'] != null
          ? params['include']!
              .split(',')
              .map((e) => int.tryParse(e.trim()))
              .where((e) => e != null)
              .cast<int>()
              .toList()
          : null;
      final offset =
          params['offset'] != null ? int.tryParse(params['offset']!) : null;
      final order = params['order'];
      final orderby = params['orderby'];
      final product =
          params['product'] != null ? int.tryParse(params['product']!) : null;
      final reviewer = params['reviewer'];
      final reviewerEmail = params['reviewer_email'];
      final rating =
          params['rating'] != null ? int.tryParse(params['rating']!) : null;
      final status = params['status'];
      final reviewId = params['review_id'] != null
          ? int.tryParse(params['review_id']!)
          : null;

      debugPrint('📝 Starting product reviews request...');
      debugPrint('📋 API Version: $apiVersion');
      debugPrint('🔍 Review ID: $reviewId');
      debugPrint('📄 Page: $page');
      debugPrint('📊 Per Page: $perPage');
      debugPrint('🔎 Search: $search');
      debugPrint('⭐ Rating: $rating');

      // Use StoreProductReviewsService from the package
      final service = GetIt.I<StoreProductReviewsService>();

      if (reviewId != null) {
        // Retrieve single product review
        debugPrint('🔍 Retrieving single product review with ID: $reviewId');
        final review = await service.retrieveProductReview(
          apiVersion: apiVersion,
          reviewId: reviewId,
          context: context,
        );

        return {
          "status": "success",
          "message": "Product review retrieved successfully",
          "data": {
            "review": {
              "id": review.id,
              "date_created": review.dateCreated?.toIso8601String(),
              "formatted_date_created": review.formattedDateCreated,
              "date_created_gmt": review.dateCreatedGmt?.toIso8601String(),
              "product_id": review.productId,
              "product_name": review.productName,
              "product_permalink": review.productPermalink,
              "product_image": review.productImage != null
                  ? {
                      "id": review.productImage!.id,
                      "src": review.productImage!.src,
                      "thumbnail": review.productImage!.thumbnail,
                      "name": review.productImage!.name,
                      "alt": review.productImage!.alt,
                    }
                  : null,
              "reviewer": review.reviewer,
              "review": review.review,
              "rating": review.rating,
              "verified": review.verified,
              "reviewer_avatar_urls": review.reviewerAvatarUrls,
            },
            "api_info": {
              "endpoint":
                  "GET /wp-json/wc/store/$apiVersion/products/reviews/$reviewId",
              "method": "GET",
              "api_version": apiVersion,
              "timestamp": DateTime.now().toIso8601String(),
            }
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      } else {
        // List all product reviews
        debugPrint('📋 Listing all product reviews...');
        final reviews = await service.listProductReviews(
          apiVersion: apiVersion,
          context: context,
          page: page,
          perPage: perPage,
          search: search,
          exclude: exclude,
          include: include,
          offset: offset,
          order: order,
          orderby: orderby,
          product: product,
          reviewer: reviewer,
          reviewerEmail: reviewerEmail,
          rating: rating,
          status: status,
        );

        return {
          "status": "success",
          "message": "Product reviews retrieved successfully",
          "data": {
            "reviews": reviews
                .map((review) => {
                      "id": review.id,
                      "date_created": review.dateCreated?.toIso8601String(),
                      "formatted_date_created": review.formattedDateCreated,
                      "date_created_gmt":
                          review.dateCreatedGmt?.toIso8601String(),
                      "product_id": review.productId,
                      "product_name": review.productName,
                      "product_permalink": review.productPermalink,
                      "product_image": review.productImage != null
                          ? {
                              "id": review.productImage!.id,
                              "src": review.productImage!.src,
                              "thumbnail": review.productImage!.thumbnail,
                              "name": review.productImage!.name,
                              "alt": review.productImage!.alt,
                            }
                          : null,
                      "reviewer": review.reviewer,
                      "review": review.review,
                      "rating": review.rating,
                      "verified": review.verified,
                      "reviewer_avatar_urls": review.reviewerAvatarUrls,
                    })
                .toList(),
            "count": reviews.length,
            "api_info": {
              "endpoint": "GET /wp-json/wc/store/$apiVersion/products/reviews",
              "method": "GET",
              "api_version": apiVersion,
              "timestamp": DateTime.now().toIso8601String(),
            }
          },
          "timestamp": DateTime.now().toIso8601String(),
        };
      }
    } catch (e, stackTrace) {
      debugPrint('❌ Product reviews request failed: $e');
      debugPrint('❌ Stack trace: $stackTrace');

      return {
        "status": "error",
        "message": "Product reviews request failed: $e",
        "error_details": {
          "error": e.toString(),
          "stack_trace": stackTrace.toString(),
          "timestamp": DateTime.now().toIso8601String(),
        },
        "timestamp": DateTime.now().toIso8601String(),
      };
    }
  }

  Map<String, List<ApiField>> get requiredFields => {
        'GET': [
          const ApiField(
            name: 'api_version',
            label: 'API Version',
            hint: 'WooCommerce API version (e.g., v1, v2, v3)',
            isRequired: true,
          ),
        ],
      };

  Map<String, List<ApiField>> get optionalFields => {
        'GET': [
          const ApiField(
            name: 'review_id',
            label: 'Review ID',
            hint:
                'Specific product review ID to retrieve (leave empty for list)',
            isRequired: false,
          ),
          const ApiField(
            name: 'context',
            label: 'Context',
            hint: 'Context under which the request is made (view, edit, embed)',
            isRequired: false,
          ),
          const ApiField(
            name: 'page',
            label: 'Page',
            hint: 'Current page of the collection',
            isRequired: false,
          ),
          const ApiField(
            name: 'per_page',
            label: 'Per Page',
            hint: 'Maximum number of items to be returned in result set',
            isRequired: false,
          ),
          const ApiField(
            name: 'search',
            label: 'Search',
            hint: 'Limit results to those matching a string',
            isRequired: false,
          ),
          const ApiField(
            name: 'exclude',
            label: 'Exclude',
            hint: 'Ensure result set excludes specific IDs (comma-separated)',
            isRequired: false,
          ),
          const ApiField(
            name: 'include',
            label: 'Include',
            hint: 'Limit result set to specific IDs (comma-separated)',
            isRequired: false,
          ),
          const ApiField(
            name: 'offset',
            label: 'Offset',
            hint: 'Offset the result set by a specific number of items',
            isRequired: false,
          ),
          const ApiField(
            name: 'order',
            label: 'Order',
            hint: 'Order sort attribute ascending or descending (asc, desc)',
            isRequired: false,
          ),
          const ApiField(
            name: 'orderby',
            label: 'Order By',
            hint: 'Sort collection by object attribute (id, date, rating)',
            isRequired: false,
          ),
          const ApiField(
            name: 'product',
            label: 'Product ID',
            hint: 'Limit result set to reviews for a specific product',
            isRequired: false,
          ),
          const ApiField(
            name: 'reviewer',
            label: 'Reviewer',
            hint: 'Limit result set to reviews from a specific reviewer',
            isRequired: false,
          ),
          const ApiField(
            name: 'reviewer_email',
            label: 'Reviewer Email',
            hint: 'Limit result set to reviews from a specific email',
            isRequired: false,
          ),
          const ApiField(
            name: 'rating',
            label: 'Rating',
            hint: 'Limit result set to reviews with a specific rating (1-5)',
            isRequired: false,
          ),
          const ApiField(
            name: 'status',
            label: 'Status',
            hint: 'Limit result set to reviews with a specific status',
            isRequired: false,
          ),
        ],
      };

  String get serviceName => 'Product Reviews (Store API)';

  String get serviceDescription =>
      'Manage WooCommerce product reviews using Store API';

  String get serviceCategory => 'WooCommerce Store API';

  List<String> get supportedMethods => ['GET'];

  String get documentation => '''
# Product Reviews (Store API)

## Overview
Manage WooCommerce product reviews using the Store API endpoints.

## Endpoints

### List Product Reviews
- **Method**: GET
- **Endpoint**: `/wp-json/wc/store/{api_version}/products/reviews`
- **Description**: Retrieve a list of product reviews

### Retrieve Product Review
- **Method**: GET  
- **Endpoint**: `/wp-json/wc/store/{api_version}/products/reviews/{review_id}`
- **Description**: Retrieve a single product review by ID

## Parameters

### Required
- `api_version`: WooCommerce API version (e.g., v1, v2, v3)

### Optional
- `review_id`: Specific product review ID to retrieve
- `context`: Context under which the request is made
- `page`: Current page of the collection
- `per_page`: Maximum number of items to return
- `search`: Limit results to those matching a string
- `exclude`: Ensure result set excludes specific IDs
- `include`: Limit result set to specific IDs
- `offset`: Offset the result set by a specific number of items
- `order`: Order sort attribute (asc, desc)
- `orderby`: Sort collection by object attribute
- `product`: Limit result set to reviews for a specific product
- `reviewer`: Limit result set to reviews from a specific reviewer
- `reviewer_email`: Limit result set to reviews from a specific email
- `rating`: Limit result set to reviews with a specific rating
- `status`: Limit result set to reviews with a specific status

## Response Format
Returns product review data including ID, date created, product info, reviewer info, review content, rating, and verification status.
''';
}
