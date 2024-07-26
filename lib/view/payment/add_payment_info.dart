import 'package:flutter/material.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/components/input/drop_down_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/repo/payment_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';

class AddPaymentInfoPage extends StatefulWidget{
  const AddPaymentInfoPage({super.key,});

  @override
  State<AddPaymentInfoPage> createState() => _AddPaymentInfoPageState();
}
class _AddPaymentInfoPageState extends State<AddPaymentInfoPage> {
  String name = "";
  String businessName ="";
  String bankName = "", bankId = "";
  String bankAccountNumber = "";

  List<Map<String, dynamic>> banks = [
    {
      "id": "971bd28c-ff80-420b-a0db-0a1a4be6ee8b",
      "slug": "abay_bank",
      "name": "Abay Bank",
      "acct_length": 16,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "29231e51-9353-4af9-b158-01af33794f8d",
      "slug": "amhara_bank",
      "name": "Amhara Bank",
      "acct_length": 13,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "80a510ea-7497-4499-8b49-ac13a3ab7d07",
      "slug": "awash_bank",
      "name": "Awash Bank",
      "acct_length": 14,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "32735b19-bb36-4cd7-b226-fb7451cd98f0",
      "slug": "boa_bank",
      "name": "Bank of Abyssinia",
      "acct_length": 8,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "153d0598-4e01-41ab-a693-t9e2g4da6u13",
      "slug": "cbebirr",
      "name": "CBEBirr",
      "acct_length": 10,
      "is_mobilemoney": 1,
      "currency": "ETB",
    },
    {
      "id": "96e41186-29ba-4e30-b013-2ca36d7e7025",
      "slug": "cbe_bank",
      "name": "Commercial Bank of Ethiopia (CBE)",
      "acct_length": 13,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "f5dd0ca8-0e84-4dbe-a147-fb153ea97d9c",
      "slug": "coop_bank",
      "name": "Cooperative Bank of Oromia (COOP)",
      "acct_length": 13,
      "is_mobilemoney": 0,
      "currency": "ETB",
    },
    {
      "id": "809814c1-ab98-4750-a5b8-3be5db7bd5f5",
      "slug": "dashen_bank",
      "name": "Dashen Bank",
      "acct_length": 13,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "800144e5-ae3d-4fc9-a25d-0632f31f5c73",
      "slug": "hibret_bank",
      "name": "Hibret Bank",
      "acct_length": 16,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "853d0598-9c01-41ab-ac99-48eab4da1513",
      "slug": "telebirr",
      "name": "telebirr",
      "acct_length": 10,
      "is_mobilemoney": 1,
      "currency": "ETB",
    },
    {
      "id": "742a2912-01e5-4e04-baab-b2cc4fc20f8b",
      "slug": "wegagen_bank",
      "name": "Wegagen Bank",
      "acct_length": 13,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
    {
      "id": "32b1c5b7-1ca3-4da0-aedf-3c0aaac5277e",
      "slug": "zemen_bank",
      "name": "Zemen Bank",
      "acct_length": 16,
      "is_mobilemoney": null,
      "currency": "ETB",
    },
  ];
  late List<String> bankNames;
  late String selectedbank;
  late int accountNumberlength;
  int bankIndex = 0;
  bool waiting = false;
  Map<String, String> inputErrors = {
    "name" : "",
    "businessName" : "",
    "bankName" : "",
    "bankId" : "",
    "bankAccountNumber" : "",
  };

  @override
  void initState() {
    super.initState();
    bankNames = banks.map((e) => e["name"] as String).toList();
    selectedbank = bankNames[0] ?? "";
    accountNumberlength = banks[0]["acct_length"];
  }

  bool checkError(){
    return inputErrors.values.map((e) => e.isNotEmpty).contains(true);
  }

  bool checkEmpty(){
    return (
      bankAccountNumber.isEmpty ||
      bankId.isEmpty ||
      bankName.isEmpty ||
      name.isEmpty ||
      businessName.isEmpty
    );
  }


  @override
  build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
        title: const Text('Add Payment Information'),
      ),
      body:  SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTextInput(
                hintText: 'Name',
                initialValue: name,
                onChanged: (value) {
                  setState(() {
                    if(value.isNotEmpty && value.length < 3){
                      inputErrors["name"] = "Name is too short!";
                    }else{
                      inputErrors["name"] = "";
                    }
                    name = value;
                  });
                },
                errorText: inputErrors["name"]!.isNotEmpty ? inputErrors["name"] : null,
              ),
              const SizedBox(height: 16.0),
              CustomTextInput(
                hintText: 'Business Name',
                initialValue: businessName,
                onChanged: (value) {
                  setState(() {
                    if(value.isNotEmpty && value.length < 3){
                      inputErrors["businessName"] = "Name is too short!";
                    }else{
                      inputErrors["businessName"] = "";
                    }
                    businessName = value;
                  });
                },
                errorText: inputErrors["businessName"]!.isNotEmpty ? inputErrors["businessName"] : null,
              ),
              const SizedBox(height: 16.0),
              DropDownButtonForm(
                allOptions: bankNames,
                initialValue: bankName.isNotEmpty ? bankNames[bankIndex] :
                bankNames[0],
                hintText: "Select Bank",
                onChanged: (selected) {
                  setState(() {
                    bankIndex = bankNames.indexOf(selected!);
                    bankAccountNumber = "";
                    bankName = banks[bankIndex]["name"];
                    bankId = banks[bankIndex]["id"];
                    accountNumberlength = banks[bankIndex]["acct_length"];
                  });
                },
                errorText: null,
              ),
              const SizedBox(height: 16.0),
              CustomTextInput(
                hintText: 'Account Number',
                initialValue: bankAccountNumber,
                maxValue: bankName.isEmpty ? banks[0]["acct_length"] :
                banks[bankIndex]["acct_length"],
                onChanged: (value) {
                  setState(() {
                    if(value.isNotEmpty && value.length < accountNumberlength){
                      inputErrors["bankAccountNumber"] = "Account number length for "
                          "$bankName must be $accountNumberlength digits!";
                    }else{
                      inputErrors["bankAccountNumber"] = "";
                    }
                    bankAccountNumber = value;
                  });
                },
                errorText: inputErrors["bankAccountNumber"]!.isNotEmpty ? inputErrors["bankAccountNumber"] : null,
              ),
              const SizedBox(height: 32.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        isLoading: false,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Cancel",
                         buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor:MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 5,
                      )
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                      child: CustomElevatedButton(
                        onPressed: () {
                          if(checkEmpty()){
                            SnackBarMessage.make(context, "Please provide full information!");
                          }else if(checkError()){
                            SnackBarMessage.make(context, "Please provide valid information!");
                          }else{
                            setState(() {waiting = true;});
                            PaymentRepo().createSubAccount({ 'account_number' : bankAccountNumber,
                              'account_owner_name' : bankId,
                              'bank_name' : bankName,
                              'bank_id' : name,
                              'business_name' : businessName
                            }).then((value) => {
                              setState(() {waiting = false;}),
                              SnackBarMessage.make(context, value["message"])
                            });
                            setState(() {waiting = false;});
                          }
                        },
                        isLoading: waiting,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Submit",
                        buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor:MyColors.mainThemeLightColor,
                        insetV: 25,
                        insetH: 10,
                        radius: 5,
                      )
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    );
  }
}