import 'package:flutter/material.dart';
import 'package:core/core.dart' hide BuildContextTranslationsExtension, AppLocaleUtils, LocaleSettings, TranslationProvider;
import 'package:storefront_supabase/app/api/admin/admin_routes.dart';
import 'package:storefront_supabase/app/api/admin/abstract/admin_reviews_service.dart';
import 'package:storefront_supabase/app/core/config/config_di.dart';
import 'package:storefront_supabase/app/models/product_review.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';
import 'package:intl/intl.dart';

class AdminReviewsView extends StatefulWidget {
  const AdminReviewsView({
    super.key,
    required this.goRoute,
  });

  final void Function(String path) goRoute;

  @override
  State<AdminReviewsView> createState() => _AdminReviewsViewState();
}

class _AdminReviewsViewState extends State<AdminReviewsView> {
  late Future<List<ProductReview>> _reviews;
  bool? _filterApproved;

  AdminReviewsService get _reviewsService => getIt<AdminReviewsService>();

  @override
  void initState() {
    super.initState();
    _reviews = _reviewsService.listReviews(isApproved: _filterApproved);
  }

  Future<void> _refresh() async {
    setState(() {
      _reviews = _reviewsService.listReviews(isApproved: _filterApproved);
    });
  }

  Future<void> _setApproved(ProductReview review, bool approved) async {
    try {
      await _reviewsService.updateReview(review.id, {'is_approved': approved});
      _refresh();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${context.resources.errorPrefix}Failed to update')),
        );
      }
    }
  }

  void _applyFilter(bool? approved) {
    setState(() {
      _filterApproved = approved;
      _reviews = _reviewsService.listReviews(isApproved: _filterApproved);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resources = context.resources;
    return OsmeaComponents.scaffold(
      backgroundColor: OsmeaColors.paperWhite,
      appBar: OsmeaComponents.appBar(
        title: OsmeaComponents.text(
          'Reviews',
          color: OsmeaColors.black,
        ),
        variant: AppBarVariant.primary,
        backgroundColor: OsmeaColors.white,
        foregroundColor: OsmeaColors.black,
        leading: OsmeaComponents.iconButton(
          onPressed: () => widget.goRoute(AdminRoutes.dashboard),
          icon: Icon(Icons.arrow_back, color: OsmeaColors.black),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.paddingNormal.left, vertical: 8),
            child: Row(
              children: [
                OsmeaComponents.text(
                  'Filter: ',
                  textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                ),
                _filterChip(context, 'All', null),
                const SizedBox(width: 8),
                _filterChip(context, 'Approved', true),
                const SizedBox(width: 8),
                _filterChip(context, 'Pending', false),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              child: FutureBuilder<List<ProductReview>>(
                future: _reviews,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return OsmeaComponents.center(
                      child: OsmeaComponents.loading(
                        type: LoadingType.circularFade,
                        size: 36,
                        color: OsmeaColors.black,
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return OsmeaComponents.center(
                      child: OsmeaComponents.text(
                        '${resources.errorPrefix}${snapshot.error}',
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                      ),
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return OsmeaComponents.center(
                      child: OsmeaComponents.text(
                        'No reviews found.',
                        textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.thunder),
                      ),
                    );
                  }
                  final reviews = snapshot.data!;
                  return ListView.builder(
                    padding: context.paddingNormal,
                    itemCount: reviews.length,
                    itemBuilder: (context, index) {
                      final review = reviews[index];
                      return _buildReviewCard(context, review);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filterChip(BuildContext context, String label, bool? value) {
    final selected = _filterApproved == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => _applyFilter(value),
    );
  }

  Widget _buildReviewCard(BuildContext context, ProductReview review) {
    return OsmeaComponents.container(
      margin: EdgeInsets.only(bottom: context.spacing12),
      decoration: BoxDecoration(
        color: OsmeaColors.white,
        borderRadius: context.borderRadiusNormal,
        border: Border.all(color: OsmeaColors.silver.withOpacity(0.5)),
      ),
      padding: context.paddingNormal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OsmeaComponents.text(
                  '${review.authorName} · ${review.rating}/5',
                  textStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: OsmeaColors.black,
                      ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  OsmeaComponents.text(
                    review.isApproved ? 'Approved' : 'Pending',
                    textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: review.isApproved ? OsmeaColors.black : OsmeaColors.thunder,
                        ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: Icon(
                      review.isApproved ? Icons.check_circle : Icons.pending_actions,
                      color: OsmeaColors.black,
                      size: 22,
                    ),
                    onPressed: () => _setApproved(review, !review.isApproved),
                    tooltip: review.isApproved ? 'Unapprove' : 'Approve',
                  ),
                ],
              ),
            ],
          ),
          if (review.title != null && review.title!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.text(
              review.title!,
              textStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: OsmeaColors.black),
            ),
          ],
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            OsmeaComponents.sizedBox(height: 4),
            OsmeaComponents.text(
              review.comment!,
              textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.thunder),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          OsmeaComponents.sizedBox(height: 4),
          OsmeaComponents.text(
            DateFormat.yMMMd().format(review.createdAt),
            textStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: OsmeaColors.slate),
          ),
        ],
      ),
    );
  }
}
