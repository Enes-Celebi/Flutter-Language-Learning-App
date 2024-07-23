import 'package:flutter/material.dart';
import 'package:lingoneer_beta_0_0_1/pages/settings_page.dart';

// custom_app_bar.dart
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(80); // Standard AppBar height

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(80),
      child: Stack(
        children: [
          Column(
            children: [
              AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).colorScheme.tertiary, // COLOR
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: GestureDetector(
              onTap: () {
                _navigateToSettingsPage(context);
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.background, //COLOR
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background, //COLOR
                    width: 8,
                  ),
                ),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.primary, // COLOR
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToSettingsPage(BuildContext context) {
    final navigatorKey = Navigator.of(context).widget.key as GlobalKey<NavigatorState>;
    final settingsPageRoute = ModalRoute.of(context);
    bool settingsPageExists = settingsPageRoute?.settings.name == '/settings';

    if (settingsPageExists) {
      navigatorKey.currentState?.popUntil(ModalRoute.withName('/settings'));
    } else {
      navigatorKey.currentState?.push(MaterialPageRoute(builder: (context) => SettingsPage()));
    }
  }
}
