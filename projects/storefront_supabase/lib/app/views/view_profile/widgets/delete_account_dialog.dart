import 'package:core/core.dart' hide BuildContextTranslationsExtension;
import 'package:flutter/material.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

/// Delete Account Dialog (30-day scheduled deletion).
/// Shows that the account will be deleted in 30 days, not immediately.
/// Uses OsmeaComponents and context.resources for i18n.
class DeleteAccountDialog extends StatefulWidget {
  final String userEmail;
  final VoidCallback onConfirmDelete;

  const DeleteAccountDialog({
    super.key,
    required this.userEmail,
    required this.onConfirmDelete,
  });

  static Future<void> show({
    required BuildContext context,
    required String userEmail,
    required VoidCallback onConfirmDelete,
  }) {
    return showDialog(
      context: context,
      builder: (context) => DeleteAccountDialog(
        userEmail: userEmail,
        onConfirmDelete: onConfirmDelete,
      ),
    );
  }

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  bool _showFinalConfirmation = false;
  bool _isConfirmed = false;

  static Color _getDeleteColor(BuildContext context) {
    return OsmeaColors.red[400]!;
  }

  @override
  Widget build(BuildContext context) {
    if (_showFinalConfirmation) {
      return _buildFinalConfirmationDialog(context);
    }
    return _buildInitialWarningDialog(context);
  }

  Widget _buildInitialWarningDialog(BuildContext context) {
    final res = context.resources;
    final deleteColor = _getDeleteColor(context);

    return AlertDialog(
      backgroundColor: OsmeaColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: OsmeaComponents.row(
        children: [
          Icon(
            Icons.warning_outlined,
            color: deleteColor,
            size: 28,
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          Expanded(
            child: OsmeaComponents.text(
              res.deleteAccountTitle,
              textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                fontWeight: FontWeight.w600,
                color: OsmeaColors.black,
              ),
            ),
          ),
        ],
      ),
      content: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            res.deleteAccountMessage30Days,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          OsmeaComponents.text(
            res.deleteAccountWhatWillBeDeleted,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing8),
          _buildDeleteItem(context, res.deleteAccountItemProfile),
          _buildDeleteItem(context, res.deleteAccountItemOrders),
          _buildDeleteItem(context, res.deleteAccountItemAddresses),
          _buildDeleteItem(context, res.deleteAccountItemReviews),
          OsmeaComponents.sizedBox(height: context.spacing16),
          Container(
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: deleteColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: deleteColor, size: 20),
                OsmeaComponents.sizedBox(width: context.spacing8),
                Expanded(
                  child: OsmeaComponents.text(
                    res.deleteAccountCannotUndo,
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: deleteColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: OsmeaComponents.text(
            res.cancel,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _showFinalConfirmation = true;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: deleteColor,
          ),
          child: OsmeaComponents.text(
            res.deleteAccountContinue,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFinalConfirmationDialog(BuildContext context) {
    final res = context.resources;
    final deleteColor = _getDeleteColor(context);

    return AlertDialog(
      backgroundColor: OsmeaColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: OsmeaComponents.text(
        res.deleteAccountFinalConfirm,
        textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
          fontWeight: FontWeight.w600,
          color: OsmeaColors.black,
        ),
      ),
      content: OsmeaComponents.column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          OsmeaComponents.text(
            res.deleteAccountSure,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OsmeaComponents.text(
            res.deleteAccountEmailLabel.replaceAll('{email}', widget.userEmail),
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing20),
          Material(
            color: OsmeaColors.transparent,
            child: InkWell(
              onTap: () {
                setState(() {
                  _isConfirmed = !_isConfirmed;
                });
              },
              child: OsmeaComponents.row(
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _isConfirmed,
                      onChanged: (value) {
                        setState(() {
                          _isConfirmed = value ?? false;
                        });
                      },
                      activeColor: deleteColor,
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing12),
                  Expanded(
                    child: OsmeaComponents.text(
                      res.deleteAccountUnderstandPermanent,
                      textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                        color: OsmeaColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            setState(() {
              _showFinalConfirmation = false;
              _isConfirmed = false;
            });
          },
          child: OsmeaComponents.text(
            res.deleteAccountGoBack,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.grayMaterial[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _isConfirmed
              ? () {
                  Navigator.of(context).pop();
                  widget.onConfirmDelete();
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isConfirmed ? deleteColor : OsmeaColors.grayMaterial[200],
          ),
          child: OsmeaComponents.text(
            res.deleteMyAccount,
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: _isConfirmed ? OsmeaColors.white : OsmeaColors.grayMaterial[600],
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteItem(BuildContext context, String text) {
    final deleteColor = _getDeleteColor(context);

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing8),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.close, color: deleteColor, size: 18),
          OsmeaComponents.sizedBox(width: context.spacing8),
          Expanded(
            child: OsmeaComponents.text(
              text,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
