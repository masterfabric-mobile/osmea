import 'package:flutter/material.dart';
import 'package:core/core.dart'
    hide
        BuildContextTranslationsExtension,
        AppLocaleUtils,
        LocaleSettings,
        TranslationProvider;
import 'package:go_router/go_router.dart';
import 'package:storefront_supabase/app/views/view_profile/models/states.dart';
import 'package:storefront_supabase/app/views/view_profile/models/view_model.dart';
import 'package:storefront_supabase/src/resources/resources.g.dart';

class PersonalInfoView extends MasterViewCubit<ProfileViewModel, ProfileState> {
  PersonalInfoView({
    super.key,
    super.arguments = const {'init': true},
    required super.goRoute,
  }) : super(
         horizontalPadding: const PaddingVisibility.enabled(value: 16.0),
         appBarPadding: const AppBarPaddingVisibility.disabled(),
         coreAppBar: (context, viewModel) => OsmeaComponents.appBar(
             title: OsmeaComponents.text(
               context.resources.myInformation,
               textStyle: OsmeaTextStyle.titleLarge(context).copyWith(
                 fontWeight: FontWeight.w600,
                 color: OsmeaColors.thunder,
               ),
             ),
             variant: AppBarVariant.primary,
             backgroundColor: OsmeaColors.white,
             foregroundColor: OsmeaColors.thunder,
             elevation: 0,
             leading: OsmeaComponents.iconButton(
               onPressed: () => context.pop(),
               icon: Icon(Icons.arrow_back, color: OsmeaColors.thunder),
               backgroundColor: OsmeaColors.transparent,
             ),
           ),
       );

  @override
  void initialContent(ProfileViewModel viewModel, BuildContext context) {
    // Populate controllers when entering the view
    viewModel.populateUserInfo();
  }

  @override
  Widget viewContent(
    BuildContext context,
    ProfileViewModel viewModel,
    ProfileState state,
  ) {
    final resources = context.resources;
    if (state is ProfileLoading) {
      return Center(child: CircularProgressIndicator(color: OsmeaColors.black));
    }

    if (state is ProfileAuthenticated) {
      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: context.spacing16, vertical: context.spacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.all(context.spacing12),
              decoration: BoxDecoration(
                color: OsmeaColors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: OsmeaColors.silver, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildEditableField(context, viewModel.usernameController, resources.username),
                  SizedBox(height: context.spacing16),
                  _buildEditableField(context, viewModel.emailController, resources.email, readOnly: true),
                  Padding(
                    padding: EdgeInsets.only(left: context.spacing4, top: context.spacing4, bottom: context.spacing16),
                    child: OsmeaComponents.text(
                      resources.emailCannotBeChanged,
                      textStyle: OsmeaTextStyle.bodySmall(context).copyWith(color: OsmeaColors.grayMaterial[400]),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => viewModel.pickBirthdate(context),
                    child: AbsorbPointer(
                      child: _buildEditableField(context, viewModel.birthdateController, resources.dateOfBirth),
                    ),
                  ),
                  SizedBox(height: context.spacing16),
                  OsmeaComponents.dropdown<String>(
                    items: [
                      resources.genderMale,
                      resources.genderFemale,
                      resources.genderOther,
                      resources.genderPreferNotToSay,
                    ],
                    value: viewModel.selectedGender,
                    onChanged: viewModel.setGender,
                    hint: resources.selectGender,
                    label: resources.selectGender,
                    variant: DropdownVariant.outlined,
                    fullWidth: true,
                  ),
                  SizedBox(height: context.spacing24),
                  OsmeaComponents.button(
                    text: resources.savePersonalInfo,
                    variant: ButtonVariant.primary,
                    backgroundColor: OsmeaColors.black,
                    textColor: OsmeaColors.white,
                    fullWidth: true,
                    onPressed: () async {
                      await viewModel.updateProfile();
                      if (context.mounted) {
                        context.showSnackbar(
                          message: resources.profileUpdated,
                          type: SnackbarType.success,
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacing32),
          ],
        ),
      );
    }
    return Center(
      child: OsmeaComponents.text(
        resources.loginToViewInfo,
        textStyle: OsmeaTextStyle.bodyMedium(context).copyWith(color: OsmeaColors.black),
      ),
    );
  }

  Widget _buildEditableField(
    BuildContext context,
    TextEditingController controller,
    String label, {
    bool readOnly = false,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return OsmeaComponents.textField(
      controller: controller,
      label: label,
      variant: TextFieldVariant.outlined,
      focusColor: OsmeaColors.black,
      readOnly: readOnly,
      obscureText: obscureText,
      type: keyboardType == TextInputType.number ? TextFieldType.number : TextFieldType.text,
    );
  }
}
