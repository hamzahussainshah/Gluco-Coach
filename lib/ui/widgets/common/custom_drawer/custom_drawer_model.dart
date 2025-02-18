import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../../app/app.locator.dart';

class CustomDrawerModel extends BaseViewModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final DialogService _dialogService = locator<DialogService>();

  // void showLogOutDialog() async {
  //   await _dialogService.showCustomDialog(
  //     variant: DialogType.deleteAgreementConfirmation,
  //     barrierDismissible: true,
  //     data: {
  //       'title': 'Are you sure you want to Log Out?',
  //       'subTitle': 'This action cannot be undone',
  //     },
  //   ).then(
  //     (value) async {
  //       if (value != null && value.confirmed) {
  //         await _authService.logout();
  //       }
  //     },
  //   );
  // }
}
