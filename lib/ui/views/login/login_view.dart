import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gluco_coach/ui/widgets/custom_elevated_button.dart';
import 'package:gluco_coach/ui/widgets/custom_text_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
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
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Login',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  controller: viewModel.emailController,
                ),
                20.verticalSpace,
                CustomTextField(
                  hintText: 'Password',
                  controller: viewModel.passwordController,
                ),
                5.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password?',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ),
                10.verticalSpace,
                CustomElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    viewModel.login();
                  },
                  text: 'Login',
                ),
                20.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    10.horizontalSpace,
                    GestureDetector(
                      onTap: () {
                        viewModel.navigateToSignUp();
                      },
                      child: Text(
                        'Sign Up',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}
