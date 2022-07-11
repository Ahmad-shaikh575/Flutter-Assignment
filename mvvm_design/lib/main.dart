import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_design/firebase_options.dart';
import 'package:mvvm_design/viewmodels/product_list_view_model.dart';
import 'package:mvvm_design/views/auth_screen.dart';
import 'package:mvvm_design/views/product_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppStateWidget(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Shopping',
        theme: ThemeData(
          primarySwatch: Colors.yellow,
        ),
        home: const SignCheck(),
      ),
    );
  }
}

class SignCheck extends StatelessWidget {
  const SignCheck({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    User? user = AppStateScope.of(context).user;
    if (user != null) {
      return const ProductList();
    }
    return const AuthScreen();
  }
}
