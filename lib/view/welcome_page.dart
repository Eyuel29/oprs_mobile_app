import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/button/custom_outlined_button.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/view/auth/register_page.dart';
import 'package:oprs/view/auth/sign_in_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body:
      Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              SizedBox(
                height: 200,
                child : Image.asset(
                  'assets/images/addis_ababa.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                child :
                  Text(
                    "Neway Property Rental",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: MyColors.mainThemeDarkColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 23,
                    ),
                  )
              ),
            ],
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 15.0),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 0),
                    alignment: Alignment.center,
                    child: const Text(
                      "Welcome to Neway, the app where you can find the perfect rental property. "
                      "Whether you’re looking for a new place to call home or you're a property "
                      "owner wanting to list your property for rent.",
                      overflow: TextOverflow.clip,
                      maxLines: 10,
                      textAlign: TextAlign.justify,
                      style: TextStyle(color: Color(0xff7D7F88)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: CustomElevatedButton(
                      onPressed : () {
                        Navigator.push(context,
                          MaterialPageRoute(builder : (context) => const SignInPage())
                        );
                      },
                      isLoading: false,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Sign In",
                      buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                      buttonTextColor: MyColors.mainThemeLightColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: CustomOutlinedButton(
                      onPressed : () {
                        Navigator.push(context,
                          MaterialPageRoute(builder : (context) => const RegisterPage())
                        );
                      },
                      isLoading: false,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Register",
                      buttonTextBackgroundColor: MyColors.mainThemeLightColor,
                      buttonTextColor: MyColors.mainThemeDarkColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
