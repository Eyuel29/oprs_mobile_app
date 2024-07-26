import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:intl/intl.dart';
import 'package:oprs/components/button/custom_outlined_button.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/reservation.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/provider/reservation_provider.dart';
import 'package:oprs/repo/listing_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/home/property_detail_page.dart';
import 'package:oprs/view/profile/user_profile.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:timeago/timeago.dart' as timeago;

class ReservationRequestDetailPage extends StatefulWidget {
  final Reservation reservation;
  const ReservationRequestDetailPage({super.key, required this.reservation});

  @override
  State<StatefulWidget> createState() => _ReservationRequestDetailPageState();
}

class _ReservationRequestDetailPageState extends State<ReservationRequestDetailPage> {
  late Reservation reservation;
  @override
  void initState() {
    reservation = widget.reservation;
    super.initState();
  }

  DateTime formatDate (String date){
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm:ss");
    DateTime parsedDate = format.parse(date);
    return parsedDate;
  }

  @override
  Widget build(BuildContext context) {

    timeago.setLocaleMessages('ru', timeago.RuMessages());
    var reservationProvider = Provider.of<ReservationProvider>(context);
    var accountProvider = Provider.of<AccountProvider>(context);
    TableCalendar stayDates = TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      rangeStartDay: formatDate(reservation.stayingDates[0]),
      rangeEndDay: formatDate(reservation.stayingDates[reservation.stayingDates.length - 1]),
      focusedDay: DateTime.now(),
    );
    TableCalendar arrivalDate = TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      rangeStartDay: formatDate(reservation.stayingDates[0]),
      rangeEndDay: formatDate(reservation.stayingDates[0]),
      focusedDay: DateTime.now(),
    );
    var selectedPaymentMethod = Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Selected Payment Method",
            style: TextStyle(
              fontSize: 16,
              color: MyColors.headerFontColor
            ),
          ),
          const SizedBox(height : 20),
          Text(reservation.selectedPaymentMethod)
        ],
      )
    );
    var additionalMessageView = Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.symmetric(vertical: 20),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Additional Message",
            style: TextStyle(
              fontSize: 16,
              color: MyColors.headerFontColor
            ),
          ),
          const SizedBox(height : 20),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(
                Radius.circular(10)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  spreadRadius: 2,
                )
              ],
            ),
            padding: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: accountProvider.user.photoUrl.isEmpty ?
                  Icon  (
                      Icons.account_circle_rounded,
                      color: MyColors.bodyFontColor.withOpacity(0.2),
                      size: 80
                  ) :
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: CachedNetworkImage(
                      height: 60,
                      width: 60,
                      imageUrl: accountProvider.user.photoUrl,
                      placeholder: (context, url) => const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
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
                          height: 80,
                          width: 80,
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Icon(
                              Icons.error,
                              size: 60,
                            )
                          ),
                        );
                      }, // Widget to display on error
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Wrap(
                  children: [
                    Expanded(
                      child: Text(
                        reservation.additionalMessage.isNotEmpty ?
                        reservation.additionalMessage :
                        "The tenant has no additional messages!",
                        style: const TextStyle(
                            color: MyColors.mainThemeLightColor
                        ),
                      )
                    )
                  ],
                )
              ],
            ),
          )
        ],
      )
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('${reservation.tenantName}\'s Request'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
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
                          reservation.tenant.fullName,
                          style: const TextStyle(
                            fontSize: 18,
                            color: MyColors.headerFontColor
                          )
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          reservation.tenant.userRole == 1000 ? "Tenant" : "Property Owner",
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
              const SizedBox(height: 20),
              Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Visibility(
                    visible:  accountProvider.user.userRole == 2000,
                    child: Row(
                      children: [
                        Expanded(
                          child: CustomOutlinedButton(
                          onPressed: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserProfile(user: reservation.tenant)
                                )
                            );
                          },
                          isLoading: false,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "View Profile",
                          buttonTextBackgroundColor: MyColors.mainThemeLightColor,
                          buttonTextColor: MyColors.mainThemeDarkColor,
                          insetV: 25,
                          radius: 10,
                        )
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: accountProvider.user.userRole == 2000,
                    child: const SizedBox(height: 20)
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                            onPressed: (){
                              ListingRepo().getListing(reservation.listingId).then((value){
                                if(value["listing"] != null){
                                  Navigator.push(
                                      context, MaterialPageRoute(
                                      builder: (context) => DetailsScreen(listing: value["listing"], reserved : true))
                                  );
                                }else{
                                  SnackBarMessage.make(context, "Can not load the listing!");
                                }
                              }).catchError((error){
                                SnackBarMessage.make(context, "Can not load the listing!");
                              });
                            },
                            isLoading: false,
                            loadingText: "Waiting",
                            loadingTextColor: MyColors.mainThemeDarkColor,
                            buttonText: "View Listing",
                            buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                            buttonTextColor: MyColors.mainThemeLightColor,
                            insetV: 25,
                            radius: 10,
                          )
                      )
                    ],
                  )
                ],
              ),
              const SizedBox(height: 25),
              const Divider(height: 1),
              Visibility(
                visible: reservation.leaseDurationDays > 1,
                replacement: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        "Stay Dates",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor
                        ),
                      ),
                      stayDates
                    ],
                  )
                ),
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Arrival Date",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor
                        ),
                      ),
                      arrivalDate
                    ],
                  )
                ),
              ),
              const Divider(height: 1),
              selectedPaymentMethod,
              const Divider(height: 1),
              additionalMessageView,
              const Divider(height: 1),
              Visibility(
                visible: accountProvider.user.userRole == 1000,
                replacement: Container(
                  margin:  const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: reservationProvider.approvalWaiting || reservationProvider.declineWaiting ? null : () {
                            validateReject(context).then((val){
                              if(val ?? false){
                                reservationProvider.declineRequest(reservation.reservationId).then((value){
                                  if(reservationProvider.errorMessage.isEmpty){
                                    SnackBarMessage.make(context, "Reservation request rejected!");
                                    reservationProvider.loadReservations();
                                    Navigator.pop(context);
                                  }else{
                                    SnackBarMessage.make(context, reservationProvider.errorMessage);
                                  }
                                });
                              }
                            });
                          },
                          isLoading: reservationProvider.declineWaiting,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Reject",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
                          insetV: 25,
                          radius: 10,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: reservationProvider.approvalWaiting || reservationProvider.declineWaiting ?
                          null : () {
                            validateApprove(context).then((value) {
                              if(value ?? false){
                                reservationProvider.approveReservation(reservation.reservationId)
                                    .then((value){
                                  if(reservationProvider.errorMessage.isEmpty){
                                    SnackBarMessage.make(context, "Reservation request approved!");
                                    reservationProvider.loadReservations();
                                    Navigator.pop(context);
                                  }else{
                                    SnackBarMessage.make(context, reservationProvider.errorMessage);
                                  }
                                });
                              }
                            });
                          },
                          isLoading: reservationProvider.approvalWaiting,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Approve",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
                          insetV: 25,
                          radius: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                child: Container(
                  margin:  const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: reservationProvider.cancelWaiting ? null : () {
                            validateCancel(context).then((value) {
                              if(value ?? false){
                                reservationProvider.cancelMyRequest(reservation.reservationId).then((value){
                                  if(reservationProvider.errorMessage.isEmpty){
                                    SnackBarMessage.make(context, "Reservation request cancelled!");
                                    reservationProvider.loadMyReservations();
                                    Navigator.pop(context);
                                  }else{
                                    SnackBarMessage.make(context, reservationProvider.errorMessage);
                                  }
                                });
                              }
                            });
                          },
                          isLoading: reservationProvider.cancelWaiting,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Cancel",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
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
        ),
      )
    );
  }

  Future<bool?> validateReject(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Reject request?'),
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
  Future<bool?> validateApprove(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Approve request?'),
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
  Future<bool?> validateCancel(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Cancel request?'),
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