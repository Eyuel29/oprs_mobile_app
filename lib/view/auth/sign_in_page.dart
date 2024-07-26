import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/user.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/auth/restore_account_page.dart';
import 'package:oprs/view/auth/verify_page.dart';
import 'package:oprs/view/main_page.dart';
import 'package:provider/provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});
  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool signInwaiting = false;
  bool obsecureText = true;
  String email = "";
  String password = "";
  final storage = const FlutterSecureStorage();

  Map<String, String> inputErrors = {"email": "", "password": ""};
  bool isPasswordStrong(String pass) { return pass.length >= 6; }

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    void handleAccountStatus(BuildContext context, User user){
      if(user.userRole != 1000 && user.userRole != 2000){
        Navigator.pop(context);
        SnackBarMessage.make(context, "Please use the web version!");
        return;
      }
      if(user.accountStatus == 3000){
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) =>
              MainPage(authenticatedUser: user)),(route) =>
            false
        );
      }else if(user.accountStatus == 2000){
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>
            const VerifyPage(verificationAvailable: false)
          )
        );
            SnackBarMessage.make(context, "Please verify your account!");
      }else{
        Navigator.pop(context);
        SnackBarMessage.make(context, "Sorry your account! has been suspended!");
      }
    }

    void handleSignIn(context) async {
      if (checkEmptyInput()) {
        SnackBarMessage.make(context, "Please check all inputs!");
        return;
      }

      if (checkInputErrors().isNotEmpty) {
        String message = checkInputErrors();
        SnackBarMessage.make(context, message);
        return;
      }

      setState(() { signInwaiting = true; });
      var response = await AuthRepo().signIn({
            "email": email,
            "password": password
      });

      setState(() { signInwaiting = false; });

      if (response["status"] == 200) {
        var userMap = await storage.read(key: "authenticated_user");
        if (userMap == null) {
          SnackBarMessage.make(context, "Something went wrong!");
        }
        User user = User.fromJson(Map.from(jsonDecode(userMap!)));
        accountProvider.setUser(user);
        handleAccountStatus(context, user);
      } else if (response["status"] == 403) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const VerifyPage(verificationAvailable: false)),
        );
      } else {
        SnackBarMessage.make(context, response["message"]);
      }
    }

    CustomTextInput emailInput = CustomTextInput(
      hintText: 'Email',
      inputType: TextInputType.emailAddress,
      obscureText: false,
      maxValue: 100,
      initialValue: email,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && !EmailValidator.validate(text)) {
            inputErrors["email"] = "Invalid email";
          } else {
            inputErrors["email"] = "";
          }
          email = text;
        });
      },
      errorText: inputErrors["email"]!.isNotEmpty ? inputErrors["email"] : null,
    );
    CustomTextInput passwordInput = CustomTextInput(
      hintText: 'Password',
      inputType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      maxValue: 40,
      initialValue: password,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && !isPasswordStrong(text)) {
            inputErrors["password"] = "Password is weak!";
          } else {
            inputErrors["password"] = "";
          }
          password = text;
        });
      },
      errorText: inputErrors["password"]!.isNotEmpty ? inputErrors["password"] : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: MyColors.mainThemeDarkColor,
         foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: const Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 28,
                      color: MyColors. mainThemeDarkColor,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                emailInput,
                passwordInput,
                const SizedBox(height: 10),
                Row(
                  children: [
                    Checkbox(
                      value: !obsecureText,
                      onChanged: (bool? value) {
                        setState(() {
                          obsecureText = !obsecureText;
                        });
                      },
                    ),
                    const Expanded(
                        child: Text("Show Password")
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: signInwaiting ? null : () {
                          handleSignIn(context);
                        },
                        isLoading: signInwaiting,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Sign In",
                        buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor: MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 10,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    TextButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => const RestoreAccountPage())
                        );
                      },
                      child: const Text(
                        "Forgot Password",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: MyColors.mainThemeDarkColor,
                          fontSize: 14
                        ),
                      )
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkEmptyInput() { return email.isEmpty || password.isEmpty; }

  String checkInputErrors() {
    String emptyFound = "";
    inputErrors.forEach((key, value) {
      if (value.isNotEmpty) {
        emptyFound = value;
      }
    });
    return emptyFound;
  }
}
