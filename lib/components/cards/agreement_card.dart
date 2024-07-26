import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/agreement.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/payment/make_payment.dart';
import 'package:provider/provider.dart';

class AgreementCard extends StatefulWidget {
  final Agreement agreement;
  const AgreementCard({ super.key, required this.agreement});
  @override
  State<AgreementCard> createState() => _AgreementCardState();
}

class _AgreementCardState extends State<AgreementCard> {
  var waiting = false;
  @override
  Widget build(BuildContext context) {
    var accountProvider = Provider.of<AccountProvider>(context);
    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: MyColors.bodyFontColor.withOpacity(0.06),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 2),
          )
        ],
        color:MyColors.mainThemeLightColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Rental Agreement",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: MyColors.mainThemeDarkColor,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Owner",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.agreement.owner.fullName,
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tenant",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.agreement.tenant.fullName,
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Status",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.agreement.leaseEndDate.difference(DateTime.now()).inDays > 1 ? "Active" : "Inactive",
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Lease duration",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "From ${widget.agreement.leaseStartDate.toString().substring(0,10)} to "
                    "${widget.agreement.leaseEndDate.toString().substring(0,10)}",
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Price",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "${widget.agreement.pricePerDuration} ${widget.agreement.paymentCurrency}",
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Payment status",
                style: TextStyle(
                  fontSize: 14,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                getPaymentStatus(),
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          accountProvider.user.userRole == 1000 ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: CustomElevatedButton(
                      onPressed: (){
                        if(widget.agreement.leaseEndDate.isBefore(DateTime.now())){
                          Navigator.push(
                              context, MaterialPageRoute(
                              builder: (context) => MakePaymentPage(
                                  receiverId: widget.agreement.ownerId,
                                  amount: widget.agreement.pricePerDuration,
                                  currency: widget.agreement.paymentCurrency
                              )
                          )
                          );
                        }else{
                          SnackBarMessage.make(context, "Payment is not due!");
                        }
                      },
                      isLoading: false,
                      loadingText: "Loading",
                      loadingTextColor: MyColors.mainThemeDarkColor,
                      buttonTextColor: MyColors.mainThemeLightColor,
                      buttonText: "Go to payment",
                      buttonTextBackgroundColor: Colors.green
                  )
              )
            ],
          ) : Container(),
        ],
      ),
    );
  }

  String getPaymentStatus() {
    DateTime today = DateTime.now();
    int daysToNextPayment = widget.agreement.leaseEndDate.difference(today).inDays;
    int daysLate = today.difference(widget.agreement.leaseEndDate).inDays;

    if (daysToNextPayment > 0) {
      return "after $daysToNextPayment days";
    } else if (daysLate > 0) {
      return "$daysLate days late";
    } else {
      return "today";
    }
  }

}
