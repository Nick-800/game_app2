import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_app2/helpers/consts.dart';
import 'package:game_app2/main.dart';
import 'package:game_app2/providers/auth_provider.dart';
import 'package:game_app2/providers/dark_mode_provider.dart';
import 'package:game_app2/screens/register.dart';
import 'package:game_app2/widgets/clickables/buttons/main_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {


  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkModeProvider>(builder: (context, dmc, _) {
      return Scaffold(
        body: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                shadowColor: greyColor,
                color: Colors.white54,
                child: Form(
                  key: formKey,
                  child: SizedBox(
                    height: 480,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            "Login Screen",
                            style: largeTitle.copyWith(
                                color:
                                    dmc.isDark ? Colors.white : Colors.black),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Email Cannot Be Empty.";
                              }

                              if (!value.contains("@")) {
                                return "Please Enter Valid Email.";
                              }

                              return null;
                            },
                            controller: emailController,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                color: blackColor,
                              )),
                              hintText: "Email",
                              labelText: "Email",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: blueColor),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Password Cannot Be Empty.";
                              }

                              if (value.length < 8) {
                                return "Password Must Be At Least 8 Characters.";
                              }

                              return null;
                            },
                            controller: passwordController,
                            decoration: InputDecoration(
                              hintText: "Password",
                              labelText: "Password",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 24,
                          ),
                          MainButton(
                            label: "Login",
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Provider.of<AuthenticationProvider>(context,
                                        listen: false)
                                    .login(emailController.text,
                                        passwordController.text)
                                    .then((loggedIn) {
                                  if (loggedIn) {
                                    Navigator.pushAndRemoveUntil(
                                      // ignore: use_build_context_synchronously
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            const ScreenRouter(),
                                      ),
                                      (route) => false,
                                    );
                                  }
                                });
                              } else {
                                printDebug("FORM NOT VALID");
                              }
                            },
                          ),
                          const SizedBox(height: 64,),
                          TextButton(onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => const RegisterScreen(),
                                  ),
                                  (route) => false,
                                );


                          }, child: Text("Don't have an account?", style: TextStyle(color: blueColor),))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
