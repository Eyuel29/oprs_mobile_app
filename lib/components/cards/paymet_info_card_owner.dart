import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/payment_info.dart';
import 'package:oprs/provider/account_provider.dart';
import 'package:provider/provider.dart';

class PaymentInfoCardOwner extends StatelessWidget {
  final PaymentInfo paymentInfo;
  final void Function() onDelete;
  const PaymentInfoCardOwner({
    super.key, required this.paymentInfo, required this.onDelete
  });

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
            margin: const EdgeInsets.symmetric(vertical: 10),
            alignment: Alignment.centerLeft,
            child: const Text(
              "Payment Info",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MyColors.mainThemeDarkColor,
                  fontSize: 18
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bank",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                paymentInfo.bankName,
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
                "Account Owner",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                paymentInfo.accountOwnerName,
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
                "Business Name",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                paymentInfo.businessName,
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
                "Account Number",
                style: TextStyle(
                  fontSize: 16,
                  color: MyColors.headerFontColor,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                paymentInfo.accountNumber,
                style: const TextStyle(
                  fontSize: 13,
                  color: MyColors.bodyFontColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Visibility(
            visible: accountProvider.user.userRole == 2000,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: CustomElevatedButton(
                        onPressed: onDelete,
                        isLoading: false,
                        loadingText: "Loading",
                        loadingTextColor:MyColors.mainThemeLightColor,
                        buttonText: "Delete",
                        buttonTextColor:MyColors.mainThemeLightColor,
                        buttonTextBackgroundColor: Colors.redAccent
                    )
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
