import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/module/admin_pimpinan_page/profile/view/profile_view.dart';
import '../controller/main_navigation_dosen_controller.dart';

class MainNavigationDosenView extends StatefulWidget {
  const MainNavigationDosenView({super.key, required this.initialindexs});
  final int initialindexs;

  Widget build(context, MainNavigationDosenController controller) {
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
          DashboardDosenView(),
          AktivitasDosenView(),
          ProfileView(),
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
  State<MainNavigationDosenView> createState() =>
      MainNavigationDosenController();
}
