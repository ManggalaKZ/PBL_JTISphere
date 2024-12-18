import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class WelcomeScreenView extends StatefulWidget {
  const WelcomeScreenView({super.key});

  Widget build(context, WelcomeScreenController controller) {
    controller.view = this;

    return Scaffold(
        backgroundColor: primaryColor,
        body: Stack(children: [
          Positioned(
            top: -60,
            left: -140,
            child: Image.asset(
              'assets/Decor.png',
              width: 400, // Sesuaikan ukuran gambar
              height: 400, // Sesuaikan ukuran gambar
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 330),
                child: Center(
                  child: SizedBox(
                    width: 200,
                    height: 200,
                    child: Hero(
                      tag: "logo",
                      child: Image.asset(
                        'assets/Jti_polinema.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30), // Jarak antara logo dan teks
              Align(
                alignment: Alignment.centerLeft, // Mengatur posisi teks ke kiri
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Akses Mudah!",
                    style: TextStyle(
                      fontSize: 53,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft, // Mengatur posisi teks ke kiri
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    "Seimbangkan Beban, Tingkatkan Produktivitas",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 33),
              Align(
                alignment: Alignment.centerLeft, // Mengatur posisi teks ke kiri
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    height: 72,
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(12.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => LoginView()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text(
                        "Mulai",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ]));
  }

  @override
  State<WelcomeScreenView> createState() => WelcomeScreenController();
}
