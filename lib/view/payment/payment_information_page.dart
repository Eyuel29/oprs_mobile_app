import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/cards/paymet_info_card_owner.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/payment_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/payment/add_payment_info.dart';
import 'package:provider/provider.dart';

class PaymentInfoPage extends StatefulWidget {
  const PaymentInfoPage({super.key});
  @override
  State<PaymentInfoPage> createState() => _PaymentInfoPageState();
}

class _PaymentInfoPageState extends State<PaymentInfoPage> {
  @override
  Widget build(BuildContext context) {
    var paymentProvider = Provider.of<PaymentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Info'),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: Container(
        child: Column(
	crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: paymentProvider.loadMyPaymentInfo,
              child: paymentProvider.pageLoading ? Container(
                alignment: Alignment.topCenter,
                margin: const EdgeInsets.only(top: 100),
                child: const SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(
                    color: MyColors.mainThemeDarkColor,
                    strokeWidth: 3,
                  ),
                ),
              ) : paymentProvider.myPaymentInfo.isEmpty ?
              Container(
                height: 300,
                margin: const EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      paymentProvider.errorMessage.isNotEmpty
                        ? paymentProvider.errorMessage : "No Payment Information!",
                      style: const TextStyle(fontSize: 14)
                    ),
                    const SizedBox(height: 30),
                    OutlinedButton(
                      onPressed: () {
                        paymentProvider.loadMyPaymentInfo().then((value) {
                          paymentProvider.errorMessage.isNotEmpty? null :
                          SnackBarMessage.make(context, paymentProvider.errorMessage);
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ) :
              ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                itemCount: paymentProvider.myPaymentInfo.length,
                itemBuilder: (context, index) {
                  var paymentInfo = paymentProvider.myPaymentInfo[index];
                  return PaymentInfoCardOwner(
                    paymentInfo: paymentInfo,
                    onDelete: () {
                      validateDeletePaymentInfo(context).then((value){
                      if(value ?? false){
                        paymentProvider.deleteSubAccount().then((value) {
                          if (mounted) {
                            SnackBarMessage.make(context, paymentProvider.errorMessage);
                          }
                        });
                      }
                      });
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
      ),
      floatingActionButton: paymentProvider.myPaymentInfo.isEmpty
          ? CustomElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPaymentInfoPage(),
            ),
          );
        },
        isLoading: false,
        loadingText: "Loading",
        loadingTextColor:MyColors.mainThemeLightColor,
        buttonText: "Create",
        buttonTextColor:MyColors.mainThemeLightColor,
         buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
      ) : Container(),
    );
  }

  Future<bool?> validateDeletePaymentInfo(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.center,
          title: const Text('Delete Payment Information?'),
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
