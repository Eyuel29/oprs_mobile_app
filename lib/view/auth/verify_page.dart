import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/welcome_page.dart';
import 'package:provider/provider.dart';


class VerificationRequestCodes{
  // ignore: constant_identifier_names
  static const int UPDATE_PASSWORD = 0;
  // ignore: constant_identifier_names
  static const int VERIFY_EMAIL = 1;
}

class VerifyPage extends StatefulWidget {
  final bool verificationAvailable;
  final int requestCode;
  const VerifyPage({
    super.key,
    required this.verificationAvailable,
    this.requestCode = VerificationRequestCodes.VERIFY_EMAIL
  });
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage>{
  late bool verificationAvailable;
  bool verifyWaiting = false;
  bool getVerifyWaiting = false;
  String verificationKey = "";
  Map<String, String> inputErrors = <String, String>{
    "verificationKey" : ""
  };

  @override
  void initState() {
    verificationAvailable = widget.verificationAvailable;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    FlutterSecureStorage storage = FlutterSecureStorage();
    CustomTextInput verificationKeyInput = CustomTextInput(
      hintText: 'Verification Key',
      inputType: TextInputType.number,
      obscureText: false,
      initialValue: verificationKey,
      maxValue: 6,
      enabled: widget.verificationAvailable && !verifyWaiting,
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
        title: const Text('Verify your account!'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      //const SizedBox(height: 15),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical : 10.0, horizontal: 20.0),
          child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child:
                  const Text(
                    "Verify Your Account",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                        fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    "A verification code was sent to your email ****${accountProvider.user.email.substring(4)} use that code to verify your account!",
                    style: const TextStyle(
                      color: MyColors.bodyFontColor,
                      fontSize: 16,
                    )
                  ),
                ),
                verificationKeyInput,
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(child: CustomElevatedButton(
                      onPressed: (){
                        setState(() { getVerifyWaiting = true; });
                        AuthRepo().verifyGet().then((response){
                          setState(() { getVerifyWaiting = false; });
                          if(response["status"] != 200){
                            SnackBarMessage.make(context, response["message"]);
                          }else{
                            setState(() {
                              verificationAvailable = true;
                              verificationKey = "";
                              SnackBarMessage.make(context, "Verification sent!");
                            });
                          }
                        });
                      },
                      isLoading: getVerifyWaiting,
                      loadingText: "Sending...",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Resend",
                      buttonTextColor: MyColors.mainThemeLightColor,
                      buttonTextBackgroundColor: Colors.redAccent,
                      insetV: 25,
                          radius: 10,
                    ))
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: verifyWaiting ? null : (){
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => const WelcomePage()), (route) => false);
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
                          onPressed: !widget.verificationAvailable || verifyWaiting ? null : () {
                            if(checkEmptyInput()){
                              SnackBarMessage.make(context, "Please provide verification code!");
                              return;
                            }
                            setState(() { verifyWaiting = true; });
                            AuthRepo().verify(int.tryParse(verificationKey) ?? 123456)
                                .then((value){
                              setState(() { verifyWaiting = false; });
                              if(value["status"] == 200){
                                storage.delete( key: "authenticated_user").then((v){
                                  SnackBarMessage.make(context, "Your account has been verified!");
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(builder: (context) => const WelcomePage()), (route) => false);
                                  });
                              }else if(value["status"] == 408){
                                setState(() {
                                  verificationAvailable = false;
                                });
                                SnackBarMessage.make(context, value["message"]);
                              }else{
                                SnackBarMessage.make(context, value["message"]);
                              }
                            });
                          },
                          isLoading: verifyWaiting,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Verify",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
                          insetV: 25,
                          radius: 10,
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

  bool checkEmptyInput(){
    return verificationKey.isEmpty;
  }

  String checkInputErrors(){
    String emptyFound = "";
    inputErrors.forEach((key, value){
      if(value.isNotEmpty){
        emptyFound = value;
      }
    });
    return emptyFound;
  }
}