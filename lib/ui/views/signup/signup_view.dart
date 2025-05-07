import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stacked/stacked.dart';

import '../../widgets/custom_elevated_button.dart';
import '../../widgets/custom_text_field.dart';
import 'signup_viewmodel.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignupView extends StackedView<SignupViewModel> {
  const SignupView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    SignupViewModel viewModel,
    Widget? child,
  ) {
    return ModalProgressHUD(
        color: Colors.black54,
        opacity: 1,
        progressIndicator: LoadingAnimationWidget.discreteCircle(
          color: Colors.blueAccent,
          size: 50,
        ),
        inAsyncCall: viewModel.isBusy,
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Sign Up',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  20.verticalSpace,
                  CustomTextField(
                    hintText: 'Email',
                    controller: viewModel.emailController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,
                  CustomTextField(
                    hintText: 'Name',
                    controller: viewModel.nameController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,
                  CustomTextField(
                    hintText: 'Password',
                    controller: viewModel.passwordController,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),
                  20.verticalSpace,
                  CustomElevatedButton(
                    onPressed: () {
                      if (viewModel.formKey.currentState!.validate()) {
                        viewModel.signUp();
                      }
                    },
                    text: 'Sign Up',
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account?',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      10.horizontalSpace,
                      GestureDetector(
                        onTap: () {
                          viewModel.navigateToLogin();
                        },
                        child: Text(
                          'Login',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  SignupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      SignupViewModel();
}
