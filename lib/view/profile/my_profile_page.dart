import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/cards/profile_options_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/auth_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/auth/update_password_page.dart';
import 'package:oprs/view/payment/payment_information_page.dart';
import 'package:oprs/view/profile/agreement_page.dart';
import 'package:oprs/view/profile/edit_profile_page.dart';
import 'package:oprs/view/profile/user_profile.dart';
import 'package:oprs/view/welcome_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override State<ProfilePage> createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  bool signOutWaiting = false;
  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    void deleteUserData() async {
      setState(() {
        signOutWaiting = true;
      });
      await AuthRepo().signOut();
      setState(() { signOutWaiting = true; });
      accountProvider.deleteUserData().then((value) {
        if (accountProvider.errorMessage.isEmpty) {
          SnackBarMessage.make(context, "You are signed out!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const WelcomePage()),
            (route) => false
          );
        } else {
          SnackBarMessage.make(context, accountProvider.errorMessage);
        }
      }).catchError((error) {
        setState(() {
          signOutWaiting = true;
        });
        SnackBarMessage.make(context, "Something went wrong!");
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: Container(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: accountProvider.pageLoading ? Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 300),
            padding: const EdgeInsets.all(20),
            child: const SizedBox(
              height: 60,
              width: 60,
              child: CircularProgressIndicator(
                color: MyColors.mainThemeDarkColor,
                strokeWidth: 3,
              ),
            )
          ) : Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 20, bottom: 10, right: 15, left: 15),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: accountProvider.user.photoUrl.isEmpty ?
                      Icon  (
                        Icons.account_circle_rounded,
                        color: MyColors.bodyFontColor.withOpacity(0.2),
                        size: 120
                      ) :
                      ClipRRect(
                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                        child: CachedNetworkImage(
                          height: 100,
                          width: 100,
                          imageUrl: accountProvider.user.photoUrl,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                              height: 100,
                              width: 100,
                              child: Padding(
                                padding: EdgeInsets.all(20),
                                child: CircularProgressIndicator(
                                  color:
                                  MyColors.mainThemeDarkColor,
                                  strokeWidth: 1,
                                )
                              )
                            )
                          ),
                          errorWidget: (context, url, error) {
                            return const SizedBox(
                              height: 120,
                              width: 120,
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Icon(Icons.error)
                              ),
                            );
                          }, // Widget to display on error
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                              accountProvider.user.fullName,
                              style: const TextStyle(
                                  fontSize: 18,
                                  color: MyColors.headerFontColor
                              )
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            accountProvider.user.userRole == 1000 ? "Tenant" : "Property Owner",
                            style: const TextStyle(
                                fontSize: 14,
                                color: MyColors.bodyFontColor
                            )
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              Column(
                children: [
                  ProfileOption(
                    child: const Text("Edit Profile",
                      style: TextStyle(fontSize: 14)
                    ),
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfilePage(
                            user: accountProvider.user
                          )
                        )
                      );
                    }
                  ),
                  const Divider(height: 1),
                  ProfileOption(
                    child: const Text(
                      "Change Password",
                      style: TextStyle(fontSize: 14)
                    ),
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const UpdatePasswordPage()
                        )
                      );
                    }
                  ),
                  const Divider(height: 1),
                  ProfileOption(
                    child: const Text(
                      "Profile Information",
                      style: TextStyle(fontSize: 14)
                    ),
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            user: accountProvider.user
                          )
                        )
                      );
                    }
                  ),
                  const Divider(height: 1),
                  Visibility(
                    visible: accountProvider.user.userRole == 2000,
                    child: ProfileOption(
                      child: const Text("Payment Information",
                        style: TextStyle(
                          fontSize: 14,
                        )
                      ),
                      onTapped: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                            const PaymentInfoPage()
                          )
                        );
                      }
                    )
                  ),
                  Visibility(
                    visible: accountProvider.user.userRole == 2000,
                    child: const Divider(height: 1)
                  ),
                  ProfileOption(
                    child: const Text(
                      "Rental Agreements",
                      style: TextStyle(
                        fontSize: 14,
                      )
                    ),
                    onTapped: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AgreementPage(
                            userId: accountProvider.user.userId
                          )
                        )
                      );
                    }
                  ),
                  const Divider(height: 1)
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: signOutWaiting ? null : () {
                          validateSignout(context).then((val){
                            if(val ?? false){
                              deleteUserData();
                            }
                          });
                        },
                        isLoading: signOutWaiting,
                        loadingText: "Waiting",
                        loadingTextColor: Colors.red,
                        buttonText: "Sign Out",
                        buttonTextBackgroundColor: Colors.red,
                        buttonTextColor: MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 10,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> validateSignout(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Are you sure?'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('Yes'),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: const Text('No'),
              ),
            ),
          ],
        );
      },
    );
  }
}