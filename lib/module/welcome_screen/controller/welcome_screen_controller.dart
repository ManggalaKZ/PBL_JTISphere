import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import '../view/welcome_screen_view.dart';

class WelcomeScreenController extends State<WelcomeScreenView> {
  static late WelcomeScreenController instance;
  late WelcomeScreenView view;

  @override
  void initState() {
    super.initState();
    instance = this;
    WidgetsBinding.instance.addPostFrameCallback((_) => onReady());
  }

  void onReady() {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
