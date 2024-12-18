import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  Widget build(BuildContext context, SplashScreenController controller) {
    controller.view = this;

    Future<void> checkSession() async {
      Map<String, String?> userData = await SessionManager.getUserData();
      print(userData);
      String level = userData['level'] ?? "09";

      if (level == "1" || level == "2") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainNavigationView(
                    initialindexs: 0,
                  )),
          (Route<dynamic> route) => false,
        );
      } else if (level == "3") {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainNavigationDosenView(initialindexs: 0)),
          (Route<dynamic> route) => false,
        );
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeScreenView()),
          (Route<dynamic> route) => false,
        );
      }
    }

    return Builder(builder: (context) {
      Future.delayed(const Duration(seconds: 3), () => checkSession());

      return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(
          children: [
            Positioned(
              top: -60,
              left: -140,
              child: Image.asset(
                'assets/Decor.png',
                width: 400,
                height: 400,
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        'assets/Jti_polinema.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    "JTISphere",
                    style: TextStyle(
                      fontSize: 44.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const CircularProgressIndicator(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  @override
  State<SplashScreenView> createState() => SplashScreenController();
}
