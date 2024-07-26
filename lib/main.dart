import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/user.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/provider/agreement_provider.dart';
import 'package:oprs/provider/listing_provider.dart';
import 'package:oprs/provider/notification_provider.dart';
import 'package:oprs/provider/owner_provider.dart';
import 'package:oprs/provider/payment_provider.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/provider/search_provider.dart';
import 'package:oprs/view/auth/verify_page.dart';
import 'package:oprs/view/main_page.dart';
import 'package:oprs/view/welcome_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const Oprs());
}

class Oprs extends StatefulWidget {
  const Oprs({super.key});
  @override State<Oprs> createState() => _OprsState();
}

class _OprsState extends State<Oprs>{
 final storage = const FlutterSecureStorage();
 late Future<User> authenticatedUser;
 late Future<String> userSession;

 @override
 void initState() {
   super.initState();
   authenticatedUser = storage.read(
     key: "authenticated_user"
   ).then((value) {
     if (value != null && value.isNotEmpty) {
       return User.fromJson(Map.from(jsonDecode(value)));
     } else {
       return User(userId: 0);
     }
   }).catchError((error) {
     return User(userId: 0);
   });
 }

 @override
  Widget build(BuildContext context){
    return FutureBuilder(
        future: authenticatedUser,
        builder: (context, snapShot){
          if(snapShot.connectionState == ConnectionState.waiting){
            return Center(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Loading", style: TextStyle(fontSize: 15)),
                      SizedBox(width: 10),
                      SizedBox(
                        height: 15, width: 15,
                        child: CircularProgressIndicator(
                          color: MyColors.mainThemeDarkColor,
                          strokeWidth: 3,
                        ),
                      )
                    ],
                  )
                )
              )
            );
          }else if(snapShot.hasError){
            return Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(
                top: 300
              ),
              padding: const EdgeInsets.all(20),
              child: const SizedBox(
                height: 60,
                width: 60,
                child: Text("Error occured while authentication!")
              )
            );
          }
          return MultiProvider(
            providers:[
              ChangeNotifierProvider<OwnerProvider>(create: (context) => OwnerProvider()),
              ChangeNotifierProvider<ListingProvider>(create: (context) => ListingProvider()),
              ChangeNotifierProvider<ReservationProvider>(create: (context) => ReservationProvider()),
              ChangeNotifierProvider<SearchProvider>(create: (context) => SearchProvider()),
              ChangeNotifierProvider<NotificationProvider>(create: (context) => NotificationProvider()),
              ChangeNotifierProvider<AccountProvider>(create: (context) => AccountProvider(user: snapShot.data!)),
              ChangeNotifierProvider<PaymentProvider>(create: (context) => PaymentProvider()),
              ChangeNotifierProvider<AgreementProvider>(create: (context) => AgreementProvider())
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Neway Property Rental',
              theme: ThemeData(
                fontFamily: 'Poppins'
              ),
              home: (
                snapShot.data!.userId < 1 ||
                snapShot.data!.userRole == 3000 ||
                snapShot.data!.accountStatus == 1000
              ) ? const WelcomePage() :
              snapShot.data!.accountStatus == 2000 ?
              const VerifyPage(verificationAvailable: false) :
              MainPage(authenticatedUser: snapShot.data!)
            )
          );
       }
    );
  }
}