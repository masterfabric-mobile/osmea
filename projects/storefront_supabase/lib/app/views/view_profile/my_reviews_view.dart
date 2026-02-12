/*
 * My Reviews View
 * ---------------
 * Lists the current user's product reviews (storefront_woo style).
 */

import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class MyReviewsView extends StatefulWidget {
  final Function(String) goRoute;
  final Map<String, dynamic> arguments;

  const MyReviewsView({
    super.key,
    required this.goRoute,
    this.arguments = const {},
  });

  @override
  State<MyReviewsView> createState() => _MyReviewsViewState();
}

class _MyReviewsViewState extends State<MyReviewsView> {
  List<Map<String, dynamic>> _reviews = [];
  Map<String, String> _productNames = {};
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    final client = Supabase.instance.client;
    final userId = client.auth.currentUser?.id;
    if (userId == null) {
      setState(() {
        _loading = false;
        _error = 'Please log in to see your reviews.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Load reviews; try with product name join first, fallback to plain select
      List<Map<String, dynamic>> list;
      Map<String, String> productNames = {};
      try {
        final res = await client
            .from('product_reviews')
            .select('id, product_id, rating, title, comment, created_at, products(name)')
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        list = List<Map<String, dynamic>>.from(res as List);
      } catch (_) {
        final res = await client
            .from('product_reviews')
            .select('*')
            .eq('user_id', userId)
            .order('created_at', ascending: false);
        list = List<Map<String, dynamic>>.from(res as List);
        final productIds = list
            .map((e) => e['product_id'] as String?)
            .whereType<String>()
            .toSet()
            .toList();
        if (productIds.isNotEmpty) {
          final namesRes = await client
              .from('products')
              .select('id, name')
              .inFilter('id', productIds);
          for (final row in namesRes as List) {
            final map = row as Map<String, dynamic>;
            final id = map['id'] as String?;
            final name = map['name'] as String?;
            if (id != null && name != null) productNames[id] = name;
          }
        }
      }
      setState(() {
        _reviews = list;
        _productNames = productNames;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;

    return Scaffold(
      backgroundColor: OsmeaColors.white,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          resources.myReviews,
          textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
            fontWeight: FontWeight.w600,
            color: OsmeaColors.thunder,
          ),
        ),
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.thunder,
        elevation: 0,
        leading: OsmeaComponents.iconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
          backgroundColor: OsmeaColors.transparent,
        ),
      ),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: OsmeaColors.black))
          : _error != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(context.spacing16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error_outline, size: 48, color: OsmeaColors.thunder),
                        SizedBox(height: context.spacing12),
                        OsmeaComponents.text(
                          _error!,
                          textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.spacing16),
                        OsmeaComponents.button(
                          text: resources.retry,
                          backgroundColor: OsmeaColors.black,
                          textColor: OsmeaColors.white,
                          onPressed: _loadReviews,
                        ),
                      ],
                    ),
                  ),
                )
              : _reviews.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star_outline, size: 64, color: OsmeaColors.pewter),
                          SizedBox(height: context.spacing12),
                          OsmeaComponents.text(
                            resources.noReviewsYet,
                            textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                              fontWeight: FontWeight.w600,
                              color: OsmeaColors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: context.spacing8),
                          OsmeaComponents.text(
                            'Your product reviews will appear here.',
                            textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadReviews,
                      color: OsmeaColors.black,
                      child: ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing8),
                        itemCount: _reviews.length,
                        itemBuilder: (context, index) {
                          final r = _reviews[index];
                          final productData = r['products'] ?? r['product'];
                          String productName = 'Product';
                          if (productData != null && productData is Map)
                            productName = (productData['name'] as String?) ?? 'Product';
                          else if (r['product_id'] != null)
                            productName = _productNames[r['product_id'] as String] ?? 'Product';
                          final rating = r['rating'] as int? ?? 0;
                          final title = r['title'] as String?;
                          final comment = r['comment'] as String?;
                          final createdAt = r['created_at'] != null
                              ? DateTime.tryParse(r['created_at'] as String)?.toIso8601String() ?? ''
                              : '';
                          return Container(
                            margin: EdgeInsets.only(bottom: context.spacing8),
                            padding: EdgeInsets.all(context.spacing12),
                            decoration: BoxDecoration(
                              color: OsmeaColors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: OsmeaColors.silver, width: 1),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                OsmeaComponents.text(
                                  productName,
                                  textStyle: OsmeaTextStyle.titleSmall(context).copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: OsmeaColors.black,
                                  ),
                                ),
                                SizedBox(height: context.spacing4),
                                Row(
                                  children: [
                                    ...List.generate(5, (i) => Icon(
                                      i < rating ? Icons.star : Icons.star_border,
                                      size: 18,
                                      color: OsmeaColors.black,
                                    )),
                                    if (createdAt.isNotEmpty) ...[
                                      SizedBox(width: context.spacing8),
                                      OsmeaComponents.text(
                                        createdAt.length > 10 ? createdAt.substring(0, 10) : createdAt,
                                        textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
                                      ),
                                    ],
                                  ],
                                ),
                                if (title != null && title.isNotEmpty) ...[
                                  SizedBox(height: context.spacing4),
                                  OsmeaComponents.text(
                                    title,
                                    textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: OsmeaColors.black,
                                    ),
                                  ),
                                ],
                                if (comment != null && comment.isNotEmpty) ...[
                                  SizedBox(height: context.spacing4),
                                  OsmeaComponents.text(
                                    comment,
                                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.pewter),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
    );
  }
}
