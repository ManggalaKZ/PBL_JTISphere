import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';

class LoginController extends State<LoginView> {
  bool isLoading = false;

  static late LoginController instance;
  late LoginView view;
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscuredPassword = true;
  Map<String, dynamic>? userData;
  String? token;

  @override
  void initState() {
    super.initState();
    instance = this;
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  void onReady() {}

  void togglePasswordVisibility() {
    setState(() {
      isObscuredPassword = !isObscuredPassword;
    });
  }

  Future<void> login() async {
    setState(() {
      isLoading = true;
    });

    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username / Password tidak boleh kosong')),
      );
      setState(() {
        isLoading = false;
      });
      return;
    }

    try {
      final response = await Dio().post(
        Endpoints.postLogin,
        data: {
          "username": usernameController.text,
          "password": passwordController.text,
        },
        options: Options(
          headers: {'Content-Type': 'application/json'},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data['success'] == true) {
          userData = response.data['user'];
          token = response.data['token'];
          int userLevel = userData?['level'] ?? 0;

          await SessionManager.saveLoginSession(userData?['username']);
          await SessionManager.saveRole(userLevel);
          await SessionManager.saveUserData(
            userData?['user_id'],
            userData?['username'],
            response.data['token'],
            userData?['level'] ?? 999,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Login Berhasil')),
          );

          if (userLevel == 1 || userLevel == 0) {
            Get.to(MainNavigationView(initialindexs: 0));
          } else {
            Get.to(MainNavigationDosenView(initialindexs: 0));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('${response.data['message'] ?? 'Login gagal'}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan pada server')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username / Password Anda Salah')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
