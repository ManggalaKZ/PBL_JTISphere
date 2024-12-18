import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/module/admin_pimpinan_page/profile/view/profile_view.dart';

class MainNavigationView extends StatefulWidget {
  MainNavigationView({Key? key, required this.initialindexs}) : super(key: key);
  final int initialindexs;
  Widget build(context, MainNavigationController controller) {
    controller.view = this;
    return WillPopScope(
      onWillPop: () async {
        final shouldExit = await controller.showExitConfirmationDialog(context);
        return shouldExit ??
            false; 
      },
      child: QNavigation(
        mode: QNavigationMode.nav0,
        initialIndex: initialindexs,
        pages: [
          DashboardView(),
          AktivitasView(),
          ProfileView(),
          NotifikasiView(),
        ],
        menus: [
          NavigationMenu(
            imageAsset: 'assets/dash.svg',
            label: "Dashboard",
          ),
          NavigationMenu(
            imageAsset: 'assets/aktivitas.svg',
            label: "Kegiatan",
          ),
          NavigationMenu(
            imageAsset: 'assets/User.svg',
            label: "Profile",
          ),
        ],
      ),
    );
  }

  @override
  State<MainNavigationView> createState() => MainNavigationController();
}
