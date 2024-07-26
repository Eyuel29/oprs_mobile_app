import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/repo/user_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/welcome_page.dart';

class RestorePasswordPage extends StatefulWidget {
  const RestorePasswordPage({super.key});
  @override State<RestorePasswordPage> createState() => _RestorePasswordPageState();
}

class _RestorePasswordPageState extends State<RestorePasswordPage> {
  String password1 = "";
  String password2 = "";
  bool obsecureText = true;
  bool updatePasswordWaiting = false;
  Map<String, String> inputErrors = { "password1": "", "password2": "" };

  @override
  Widget build(BuildContext context) {
    CustomTextInput password1Input = CustomTextInput(
      hintText: 'Password',
      inputType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      initialValue: password1,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && !isPasswordStrong(text)) {
            inputErrors["password1"] = "Password is weak!";
          } else {
            inputErrors["password1"] = "";
          }
          password1 = text;
        });
      },
      errorText: inputErrors["password1"]!.isNotEmpty ? inputErrors["password1"] : null,
    );
    CustomTextInput password2Input = CustomTextInput(
      hintText: 'Repeat Password',
      inputType: TextInputType.visiblePassword,
      obscureText: obsecureText,
      initialValue: password2,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && password1 != text) {
            inputErrors["password2"] = "Passwords do not march!";
          } else {
            inputErrors["password2"] = "";
          }
          password2 = text;
        });
      },
      errorText: inputErrors["password2"]!.isNotEmpty ? inputErrors["password2"] : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify your account!'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      //const SizedBox(height: 15),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: const Text(
                    "Restore Account",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.mainThemeDarkColor,
                        fontWeight: FontWeight.bold
                    )
                ),
              ),
              const SizedBox(height: 20),
              password1Input,
              password2Input,
              const SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: !obsecureText,
                    onChanged: (bool? value) {
                      setState(() { obsecureText = !obsecureText; });
                    },
                  ),
                  const Expanded(
                      child: Text("Show Password")
                  )
                ],
              ),
              const SizedBox(height: 25),
              Row(children: [
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: updatePasswordWaiting ? null : () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const WelcomePage()),
                        (route) => false
                      );
                    },
                    isLoading: false,
                    loadingText: "Waiting",
                    loadingTextColor: MyColors.mainThemeDarkColor,
                    buttonText: "Cancel",
                    buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                    buttonTextColor: MyColors.mainThemeLightColor,
                    insetV: 25,
                    radius: 10,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: CustomElevatedButton(
                    onPressed: () {
                      if(checkEmptyInput()){
                        SnackBarMessage.make(context, "Please Provide Full Information!");
                        return;
                      }

                      if(checkInputErrors().isNotEmpty){
                        SnackBarMessage.make(context, checkInputErrors());
                        return;
                      }

                      UserRepo().updatePasswordRestore({
                        "password1" : password1,
                        "password2" : password2,
                      }).then((value){
                        if(value["status"] == 200){
                          SnackBarMessage.make(context, "Password Updated Successfully!");
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const WelcomePage()),
                            (route) => false
                          );
                        }else{
                          SnackBarMessage.make(context, value["message"]);
                        }
                      });
                    },
                    isLoading: updatePasswordWaiting,
                    loadingText: "Waiting",
                    loadingTextColor: MyColors.mainThemeDarkColor,
                    buttonText: "Update",
                    buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                    buttonTextColor: MyColors.mainThemeLightColor,
                    insetV: 25,
                    radius: 10,
                  ),
                )
              ])
            ],
          ),
        ),
      ),
    );
  }

  bool checkEmptyInput() {
    return password1.isEmpty || password2.isEmpty;
  }

  bool isPasswordStrong(String input) {
    if (input.length < 6) return false;
    bool hasNumeric = input.contains(RegExp(r'[0-9]'));
    bool hasCapital = input.contains(RegExp(r'[A-Z]'));
    return hasNumeric && hasCapital;
  }

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