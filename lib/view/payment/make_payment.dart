import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/repo/payment_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/payment/payment_web.dart';
class MakePaymentPage extends StatefulWidget {
  final int receiverId;
  final String amount;
  final String currency;
  const MakePaymentPage({super.key, required this.receiverId, required this.amount, required this.currency});
  @override
  State<MakePaymentPage> createState() => _MakePaymentPageState();
}
class _MakePaymentPageState extends State<MakePaymentPage> {
  bool waiting = false;
  String reason = "Rent";
  String description = "Rent payment with chapa!";
  Map<String, String> inputErrors = {
    "reason" : "",
    "description" : "",
    "amount" : "",
    "currency" : ""
  };
  List<SelectionChip> paymentCurrencyOptions = [
    SelectionChip("ETB",false),
    SelectionChip("USD",false),
    SelectionChip("EUR",false),
  ];

  void handleInitialize(context) async {
    if (checkEmptyInput()) {
      SnackBarMessage.make(context, "Please check all inputs!");
      return;
    }
    setState(() { waiting = true; });
    PaymentRepo().initializePayment({
      "title" : "Rent",
      "description" : "Rent Payment!",
      "amount" : widget.amount,
      "currency" : widget.currency,
      "receiver_id" : widget.receiverId
    }).then((value) => {
      setState(() {waiting = false;}),
      if(value["checkOutLink"] != "" && value["checkOutLink"] != null){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewMainPage(checkOutUrl: value["checkOutLink"] ?? "")
          )
        )
      }else{
        SnackBarMessage.make(context,"Sorry the owner has no payment information!"),
        Navigator.pop(context)
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make payment'),
        backgroundColor: Colors.indigo,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 30),
                  child: const Text(
                    "Make Payment",
                    style: TextStyle(
                      fontSize: 28,
                      color: Colors.indigoAccent,
                      fontWeight: FontWeight.bold
                    )
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: CustomElevatedButton(
                                onPressed: waiting ? null : () {
                                  handleInitialize(context);
                                },
                                isLoading: waiting,
                                loadingText: "Waiting",
                                loadingTextColor: MyColors.mainThemeDarkColor,
                                buttonText: "Pay ${widget.amount} ${widget.currency} with Chapa",
                                buttonTextBackgroundColor: Colors.redAccent,
                                buttonTextColor:MyColors.mainThemeLightColor,
                                insetV: 25,
                                radius: 5,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool checkEmptyInput() { return widget.amount.isEmpty || widget.currency.isEmpty; }
  String checkInputErrors() {
    String emptyFound = "";
    inputErrors.forEach((key, value) {
      if (value.isNotEmpty) {
        emptyFound = value;
      }
    });
    return emptyFound;
  }
}
