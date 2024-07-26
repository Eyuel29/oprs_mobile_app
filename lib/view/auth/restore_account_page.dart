import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/button/custom_outlined_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/auth/restore_password_page.dart';

class RestoreAccountPage extends StatefulWidget {
  const RestoreAccountPage({super.key});
  @override
  State<RestoreAccountPage> createState() => _RestoreAccountPageState();
}

class _RestoreAccountPageState extends State<RestoreAccountPage> {
  String email = "";
  String verificationKey = "";
  bool obsecureText = true;
  bool updatePasswordWaiting = false;
  bool verificationCodeAvailable = false;
  Map<String, String> inputErrors = <String, String>{
    "email": "",
    "verificationKey" : ""
  };

  @override
  Widget build(BuildContext context) {
    CustomTextInput emailInput = CustomTextInput(
      hintText: 'Email',
      inputType: TextInputType.emailAddress,
      obscureText: false,
      maxValue: 100,
      initialValue: email,
      onChanged: (text){
        setState((){
          if(text.isNotEmpty && !EmailValidator.validate(text)){
            inputErrors["email"] = "Invalid email";
          } else {
            inputErrors["email"] = "";
          }
          email = text;
        });
      },
      errorText: inputErrors["email"]!.isNotEmpty ? inputErrors["email"] : null,
    );
    CustomTextInput verificationKeyInput = CustomTextInput(
      hintText: 'Verification Key',
      inputType: TextInputType.number,
      obscureText: false,
      initialValue: verificationKey,
      maxValue: 6,
      enabled: verificationCodeAvailable,
      onChanged: (text){
        setState(() {
          if(text.isNotEmpty && text.length < 6){
            inputErrors["verificationKey"] = "Invalid verification key";
          } else {
            inputErrors["verificationKey"] = "";
          }
          verificationKey = text;
        });
      },
      errorText: inputErrors["verificationKey"]!.isNotEmpty ? inputErrors["verificationKey"] : null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Restore Account'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 30),
                child: const Text("Restore Your Account",
                  style: TextStyle(
                    fontSize: 20,
                    color: MyColors.mainThemeDarkColor,
                    fontWeight: FontWeight.bold
                  )
                ),
              ),
              emailInput,
              verificationKeyInput,
              const SizedBox(height: 10),
              Visibility(
                visible: verificationCodeAvailable,
                child: Row(
                  children: [
                    Expanded(
                      child: CustomOutlinedButton(
                        onPressed: updatePasswordWaiting ? null : () {
                          if(email.isEmpty || inputErrors["email"] != ""){
                            SnackBarMessage.make(context,"Please Provide Valid Email!");
                            return;
                          }
                          AuthRepo().restoreAccount(email).then((value){
                            if(value["status"] == 200){
                              setState((){
                                verificationCodeAvailable = true;
                              });
                            }else{
                              setState((){
                                verificationCodeAvailable = false;
                              });
                            }
                            SnackBarMessage.make(context, value["message"] ?? "");
                          });
                        },
                        isLoading: false,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Resend",
                        buttonTextBackgroundColor: MyColors.mainThemeLightColor,
                        buttonTextColor: MyColors.mainThemeDarkColor,
                        insetV: 25,
                        radius: 10,
                      ),
                    ),
                  ],
                )
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Visibility(
                    visible: !verificationCodeAvailable,
                    child: Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          if(email.isEmpty || inputErrors["email"] != ""){
                            SnackBarMessage.make(context,"Please provide valid email!");
                            return;
                          }
                          AuthRepo().restoreAccount(email).then((value){
                            if(value["status"] == 200){
                              setState(() {
                                verificationCodeAvailable = true;
                              });
                            }
                            SnackBarMessage.make(context, value["message"] ?? "");
                          });
                        },
                        isLoading: updatePasswordWaiting,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Send",
                        buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor: MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 10,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: verificationCodeAvailable,
                    child:  Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          if(verificationKey.isEmpty || inputErrors["verificationKey"] != ""){
                            SnackBarMessage.make(context, "Verification code should be 6 digit number!");
                            return;
                          }
                          AuthRepo().verify(int.parse(verificationKey)).then((value){
                            if(value["status"] == 200){
                              SnackBarMessage.make(context, "Verification Successful!");
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const RestorePasswordPage()
                                )
                              );
                            }
                          });
                        },
                        isLoading: updatePasswordWaiting,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Verify",
                        buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor: MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 10,
                      ),
                    ),
                  )
                ]
              )
            ],
          ),
        ),
      ),
    );
  }

  bool checkEmptyInput() { return email.isEmpty || verificationKey.isEmpty; }
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
