import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Delete Account Dialog
/// 
/// A two-step confirmation dialog for account deletion.
/// Shows clear information about what will be deleted and requires
/// explicit user confirmation before proceeding.
class DeleteAccountDialog extends StatefulWidget {
  final String userEmail;
  final VoidCallback onConfirmDelete;

  const DeleteAccountDialog({
    super.key,
    required this.userEmail,
    required this.onConfirmDelete,
  });

  /// Show the delete account dialog
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

  @override
  Widget build(BuildContext context) {
    if (_showFinalConfirmation) {
      return _buildFinalConfirmationDialog(context);
    }
    return _buildInitialWarningDialog(context);
  }

  Widget _buildInitialWarningDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: OsmeaColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: OsmeaComponents.row(
        children: [
          Icon(
            Icons.warning_outlined,
            color: OsmeaColors.red,
            size: 28,
          ),
          OsmeaComponents.sizedBox(width: context.spacing12),
          Expanded(
            child: OsmeaComponents.text(
              'Delete Account?',
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
            'This action will permanently delete:',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing16),
          _buildDeleteItem(context, 'Your profile and personal information'),
          _buildDeleteItem(context, 'All your orders and order history'),
          _buildDeleteItem(context, 'Your saved addresses'),
          _buildDeleteItem(context, 'All your reviews and ratings'),
          _buildDeleteItem(context, 'Your preferences and settings'),
          OsmeaComponents.sizedBox(height: context.spacing20),
          Container(
            padding: EdgeInsets.all(context.spacing12),
            decoration: BoxDecoration(
              color: OsmeaColors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: OsmeaComponents.row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: OsmeaColors.red,
                  size: 20,
                ),
                OsmeaComponents.sizedBox(width: context.spacing8),
                Expanded(
                  child: OsmeaComponents.text(
                    'This action cannot be undone. All your data will be permanently deleted.',
                    textStyle: OsmeaTextStyle.bodySmall(context).copyWith(
                      color: OsmeaColors.red,
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
            'Cancel',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.steel,
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
            backgroundColor: OsmeaColors.red,
          ),
          child: OsmeaComponents.text(
            'Continue',
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
    return AlertDialog(
      backgroundColor: OsmeaColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: OsmeaComponents.text(
        'Final Confirmation',
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
            'Are you absolutely sure you want to delete your account?',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.black,
            ),
          ),
          OsmeaComponents.sizedBox(height: context.spacing12),
          OsmeaComponents.text(
            'Account: ${widget.userEmail}',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.pewter,
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
                      activeColor: OsmeaColors.red,
                    ),
                  ),
                  OsmeaComponents.sizedBox(width: context.spacing12),
                  Expanded(
                    child: OsmeaComponents.text(
                      'I understand this action is permanent and cannot be undone',
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
            'Go Back',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.steel,
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
            backgroundColor:
                _isConfirmed ? OsmeaColors.red : OsmeaColors.silver,
          ),
          child: OsmeaComponents.text(
            'Delete My Account',
            textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
              color: OsmeaColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteItem(BuildContext context, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing8),
      child: OsmeaComponents.row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.close,
            color: OsmeaColors.red,
            size: 18,
          ),
          OsmeaComponents.sizedBox(width: context.spacing8),
          Expanded(
            child: OsmeaComponents.text(
              text,
              textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                color: OsmeaColors.thunder,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
