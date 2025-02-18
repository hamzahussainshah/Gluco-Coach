import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import 'forgot_password_viewmodel.dart';

class ForgotPasswordView extends StackedView<ForgotPasswordViewModel> {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ForgotPasswordViewModel viewModel,
    Widget? child,
  ) {
    return ModalProgressHUD(
      color: Colors.black54,
      opacity: 1,
      progressIndicator: LoadingAnimationWidget.newtonCradle(
        color: Colors.blueAccent,
        size: 50,
      ),
      inAsyncCall: viewModel.isBusy,
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Text(
                  'Forgot Password',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                20.verticalSpace,
                Text('Password reset link will be sent to your email.'),
                CustomTextField(
                  hintText: 'Email',
                  controller: viewModel.emailController,
                ),
                20.verticalSpace,
                CustomElevatedButton(
                  onPressed: () {
                    viewModel.forgotPassword();
                  },
                  text: 'Send Email',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  ForgotPasswordViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ForgotPasswordViewModel();
}
