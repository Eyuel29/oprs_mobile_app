import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/user.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/provider/agreement_provider.dart';
import 'package:oprs/provider/listing_provider.dart';
import 'package:oprs/provider/notification_provider.dart';
import 'package:oprs/provider/owner_provider.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/view/home/home_page.dart';
import 'package:oprs/view/owner/owner_page.dart';
import 'package:oprs/view/profile/my_profile_page.dart';
import 'package:oprs/view/reservation_request/reservation_request_page_tenant.dart';
import 'package:oprs/view/reservation_request/reservation_request_page_owner.dart';
import 'package:oprs/view/updates/updates_page.dart';
import 'package:provider/provider.dart';

import '../provider/payment_provider.dart';

class MainPage extends StatefulWidget {
  final User authenticatedUser;
  const MainPage({super.key, required this.authenticatedUser});
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeProviders();
    });
  }

  Future<void> _initializeProviders() async {
    final accountProvider = Provider.of<AccountProvider>(context, listen: false);
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    final listingProvider = Provider.of<ListingProvider>(context, listen: false);
    final reservationProvider = Provider.of<ReservationProvider>(context, listen: false);
    final ownerProvider = Provider.of<OwnerProvider>(context, listen: false);
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    final agreementProvider = Provider.of<AgreementProvider>(context, listen: false);

    if (accountProvider.user.userRole == 1000) {
      await Future.wait([
        notificationProvider.loadNotifications(),
        notificationProvider.loadNotificationCount(),
        reservationProvider.loadMyReservations(),
        agreementProvider.loadAgreements(),
        listingProvider.loadListings()
      ]);

    } else {
      await Future.wait([
        notificationProvider.loadNotifications(),
        notificationProvider.loadNotificationCount(),
        reservationProvider.loadReservations(),
        ownerProvider.loadListings(),
        agreementProvider.loadAgreements(),
        paymentProvider.loadMyPaymentInfo()
      ]);
    }
  }
  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    var notificationProvider = Provider.of<NotificationProvider>(context);

    List<Widget> widgetOptions = accountProvider.user.userRole == 1000 ? [
      const HomePage(),
      const UpdatesPage(),
      const ReservationRequestPageTenant(),
      const ProfilePage(),
    ] : [
      const OwnerPage(),
      const UpdatesPage(),
      const ReservationRequestPageOwner(),
      const ProfilePage()
    ];

    return Scaffold(
      body: Center(child: widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: MyColors.mainThemeDarkColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            backgroundColor: MyColors.mainThemeDarkColor,
            activeIcon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/home.svg",
              color: MyColors.mainThemeLightColor,
            ),
            icon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/home.svg",
              color: MyColors.mainThemeLightColor.withOpacity(0.3),
            ),
            label: accountProvider.user.userRole == 2000 ? "Home" : 'Home',
          ),
          BottomNavigationBarItem(
            activeIcon: Stack(
              alignment: Alignment.topLeft,
              children: [
                SvgPicture.asset(
                  width: 24,
                  height: 24,
                  "assets/icons/notification.svg",
                  color: MyColors.mainThemeLightColor,
                ),
                notificationProvider.pageLoading || notificationProvider.unseenNotificationCount < 1
                    ? const SizedBox(height: 0,width: 0) :
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                      color: MyColors.mainThemeLightColor,
                      borderRadius: BorderRadius.all(
                          Radius.circular(
                              10
                          )
                      )
                  ),

                  child: Text(
                      '${notificationProvider.unseenNotificationCount}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: MyColors.headerFontColor,
                        fontWeight: FontWeight.bold
                      )
                  ),
                )
              ],
            ),
            icon: Stack(
              alignment: Alignment.topLeft,
              children: [
                SvgPicture.asset(
                  width: 24,
                  height: 24,
                  "assets/icons/notification.svg",
                  color: MyColors.mainThemeLightColor.withOpacity(0.3),
                ),
                notificationProvider.pageLoading || notificationProvider.unseenNotificationCount < 1
                ? const SizedBox(height: 0,width: 0) :
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    color: MyColors.mainThemeLightColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  child : Text(
                    '${notificationProvider.unseenNotificationCount}',
                     style: const TextStyle(
                          fontSize: 11,
                          color: MyColors.headerFontColor,
                          fontWeight: FontWeight.bold
                      )
                  ),
                )
              ],
            ),
            label: 'Updates',
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/request.svg",
              color: MyColors.mainThemeLightColor,
            ),
            icon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/request.svg",
              color: MyColors.mainThemeLightColor.withOpacity(0.3),
            ),
            label: accountProvider.user.userRole == 2000 ? 'Requests' : "Requests",
          ),
          BottomNavigationBarItem(
            activeIcon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/profile.svg",
              color: MyColors.mainThemeLightColor,
            ),
            icon: SvgPicture.asset(
              width: 20,
              height: 20,
              "assets/icons/profile.svg",
              color: MyColors.mainThemeLightColor.withOpacity(0.3),
            ),
            label: 'Profile',
          ),
        ],
        currentIndex: selectedIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: MyColors.mainThemeLightColor,
        unselectedItemColor: MyColors.mainThemeLightColor.withOpacity(0.3),
        onTap: _onItemTapped,
      ),
    );
  }
}
