import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// Account Danger Zone Widget
/// 
/// A prominent section containing dangerous account actions like deletion.
/// Styled with red colors to indicate the severity of the actions.
class AccountDangerZone extends StatelessWidget {
  final VoidCallback onDeleteAccount;
  final bool isLoading;

  const AccountDangerZone({
    super.key,
    required this.onDeleteAccount,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(context.spacing20),
      decoration: BoxDecoration(
        border: Border.all(
          color: OsmeaColors.red.withOpacity(0.3),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
        color: OsmeaColors.red.withOpacity(0.05),
      ),
      child: OsmeaComponents.column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: EdgeInsets.all(context.spacing16),
            decoration: BoxDecoration(
              color: OsmeaColors.red.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: OsmeaComponents.row(
              children: [
                Icon(
                  Icons.warning_outlined,
                  color: OsmeaColors.red,
                  size: 24,
                ),
                OsmeaComponents.sizedBox(width: context.spacing12),
                Expanded(
                  child: OsmeaComponents.text(
                    'DANGER ZONE',
                    textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                      color: OsmeaColors.red,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: EdgeInsets.all(context.spacing16),
            child: OsmeaComponents.column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                OsmeaComponents.text(
                  'Delete Account',
                  textStyle: OsmeaTextStyle.titleMedium(context).copyWith(
                    color: OsmeaColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing8),
                OsmeaComponents.text(
                  'Permanently delete your account and all associated data. This action cannot be undone.',
                  textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(
                    color: OsmeaColors.pewter,
                  ),
                ),
                OsmeaComponents.sizedBox(height: context.spacing16),
                
                // Delete button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: isLoading
                      ? Center(
                          child: SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                OsmeaColors.red,
                              ),
                            ),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: onDeleteAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: OsmeaColors.red,
                          ),
                          child: OsmeaComponents.row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_forever_outlined,
                                color: OsmeaColors.white,
                                size: 20,
                              ),
                              OsmeaComponents.sizedBox(width: context.spacing8),
                              OsmeaComponents.text(
                                'Delete My Account',
                                textStyle:
                                    OsmeaTextStyle.bodyLarge(context).copyWith(
                                  color: OsmeaColors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
