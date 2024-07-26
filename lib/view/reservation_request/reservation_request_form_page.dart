import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/components/input/number_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/repo/reservation_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:provider/provider.dart';

class ReservationRequestFormPage extends StatefulWidget{
  final Listing listing;
  const ReservationRequestFormPage({
    super.key, required this.listing
  });
  @override
  State<ReservationRequestFormPage> createState() => ReservationRequestFormPageState();
}
class ReservationRequestFormPageState extends State<ReservationRequestFormPage>{
  bool waiting = false, agreedToTerms = false;
  DateTime checkInDate = DateTime.now();
  List<String> conditions = [
    "1. Rent must be paid in full and on time each month; late payments may incur a fee.",
    "2. Tenants must maintain the property and are responsible for repairs of any damage they cause.",
    "3. Only individuals listed in the lease may occupy the property; subletting is prohibited without permission.",
    "4. Tenants are responsible for all utility bills unless otherwise stated in the lease.",
    "5. Tenants must keep noise to a minimum and avoid disturbances to neighbors.",
    "6. Landlords may enter the property for inspections or repairs with reasonable notice.",
    "7. Tenants must keep the property clean and dispose of trash properly.",
    "8. Tenants are encouraged to obtain renter’s insurance for personal belongings and liability.",
    "9.The lease can be terminated with proper notice as outlined in the agreement; early termination may incur penalties."
  ];
  String additionalMessage = "", selectedPaymentMethod = "Online Payment";
  int numberOfPeople = 0;
  final datesConfig = CalendarDatePicker2Config(
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(
      const Duration(days: 7)
    ),
    calendarType: CalendarDatePicker2Type.range,
    selectedDayHighlightColor: MyColors.mainThemeDarkColor,
    weekdayLabelTextStyle: const TextStyle(color: MyColors.headerFontColor, fontSize: 13),
    controlsTextStyle: const TextStyle(fontSize: 13),
  );

  final arrivalConfig = CalendarDatePicker2Config(
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(
        const Duration(days: 7)
    ),
    calendarType: CalendarDatePicker2Type.single,
    selectedDayHighlightColor: MyColors.mainThemeDarkColor,
    weekdayLabelTextStyle: const TextStyle(color: MyColors.headerFontColor, fontSize: 13),
    controlsTextStyle: const TextStyle(fontSize: 13),
  );

  List<DateTime?> initialSelectedDates = [
    DateTime.now(),
    DateTime.now().add(const Duration(days: 1)),
  ];

  List<SelectionChip> paymentOptions = [
    SelectionChip("Online payment", true),
    SelectionChip("Cash payment", false),
  ];

  @override
  Widget build(BuildContext context) {
    final accountProvider = Provider.of<AccountProvider>(context);
    CustomTextInput additionalMessageInput = CustomTextInput(
      hintText: "Additional Message",
      maxLines: 15,
      minLines: 5,
      maxValue: 500,
      inputType: TextInputType.text,
      obscureText: false,
      initialValue: additionalMessage,
      onChanged: (text){
        setState(() {
          additionalMessage = text;
        });
      },
      errorText: null,
    );
    Row checkboxAgreedToTerms = Row(
      children: [
        const Text(
          "I agree to the terms and conditions"
        ),
        const SizedBox(width: 20),
        Checkbox(
          value: agreedToTerms,
          onChanged: (bool? value) {
            setState(() {
              agreedToTerms = value!;
            });
          },
        )
      ],
    );
    NumberInput numberOfInabitabtsinput = NumberInput(
      initialValue: numberOfPeople,
      onValueChanged: (v) {
        setState(() {
          numberOfPeople = v;
        });
      },
      label: 'Number of People',
      limitValue: 20,
    );
    ChipSelectionInput paymentMethodInput = ChipSelectionInput(
      options: paymentOptions,
      onSelected: (options){
        for (var element in options) {
          if(element.selected){
            setState(() {
              selectedPaymentMethod = element.label;
            });
          } } setState(() {
          paymentOptions = options;
        });
      },
      radius: 5,
      gap: 5,
      padding: 15,
      fontSize: 15,
      singleSelection: true,
      lightColor:MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: 1,
    );
    Column stayingDatesInput = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        CalendarDatePicker2(
          config: datesConfig,
          value: initialSelectedDates,
          onValueChanged: (dates) =>
              setState(() => initialSelectedDates = dates),
        ),
        const SizedBox(height: 10),
      ],
    );
    Column arrivalDateInput = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 10),
        CalendarDatePicker2(
          config: arrivalConfig,
          value: [checkInDate],
          onValueChanged: (dates) =>
              setState(() => checkInDate = dates[0] ?? DateTime.now()),
        ),
        const SizedBox(height: 10),
      ],
    );
    bool checkEmpty(){
      if(agreedToTerms && selectedPaymentMethod.isNotEmpty){
        return false;
      }else{
        return true;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Reservation'),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical : 10.0, horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              widget.listing.leaseDurationDays == 1 ?
              const Text("Select your staying days",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ) : const Text("Select arrival date",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(height: 15),
              widget.listing.leaseDurationDays == 1 ?
              stayingDatesInput : arrivalDateInput,
              const SizedBox(height: 15),
              const Text("Which payment method you prefer",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(height: 15),
              paymentMethodInput,
              const SizedBox(height: 15),
              numberOfInabitabtsinput,
              const SizedBox(height: 15),
              const Text("Additional message (optional)",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(height: 15),
              additionalMessageInput,
              const SizedBox(height: 15),
              const Text("Conditions",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(height: 5),
              ...(List.generate(conditions.length, (index) => Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      child: Text(
                        conditions[index],
                        textAlign: TextAlign.justify,
                        style : const TextStyle(fontSize : 12)
                      ),
                    )
                  ),
                ],
              )).toList()
              ),
              const SizedBox(height: 15),
              checkboxAgreedToTerms,
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: waiting ? null : (){
                        Navigator.pop(context);
                      },
                      isLoading: false,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Cancel",
                       buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                      buttonTextColor:MyColors.mainThemeLightColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: CustomElevatedButton(
                      onPressed: waiting ? null : (){
                        List<String> stayDates = initialSelectedDates.map((e){
                          return e.toString();
                        }).toList();
                        if(!checkEmpty()){
                          ReservationRepo().makeReservationRequest({
                              "tenant_id" : accountProvider.user.userId,
                              "tenant_name" : accountProvider.user.fullName,
                              "listing_id" : widget.listing.listingId,
                              "owner_id" : widget.listing.ownerId,
                              "selected_payment_method" : selectedPaymentMethod,
                              "stay_dates" : widget.listing.leaseDurationDays != 1 ?
                              [checkInDate.toString()] : stayDates,
                              "date" : DateTime.now().toString(),
                              'additional_message' : additionalMessage,
                              'price_offer' : numberOfPeople,
                            }).then((value){
                            if(value["status"] == 200){
                              SnackBarMessage.make(context, "Successfully made reservation request!");
                              Navigator.pop(context);
                            }else{
                              SnackBarMessage.make(context, value["message"]);
                            }
                          });
                        }else{
                          SnackBarMessage.make(context, "Please check all inputs and agree to the terms!");
                        }
                      },
                      isLoading: waiting,
                      loadingText: "Waiting",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonText: "Submit",
                      buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                      buttonTextColor:MyColors.mainThemeLightColor,
                      insetV: 25,
                      radius: 10,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}