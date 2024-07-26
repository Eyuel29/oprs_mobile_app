import 'package:flutter/material.dart';
import 'package:oprs/components/cards/agreement_card.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/agreement.dart';
import 'package:oprs/provider/agreement_provider.dart';
import 'package:provider/provider.dart';

class AgreementPage extends StatefulWidget {
  final int userId;
  const AgreementPage({super.key, required this.userId});

  @override
  State<AgreementPage> createState() => AgreementPageState();
}

class AgreementPageState extends State<AgreementPage> {
  @override
  Widget build(BuildContext context) {
    var agreementProvider = Provider.of<AgreementProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Agreements"),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: RefreshIndicator(
        onRefresh: agreementProvider.loadAgreements,
        child: agreementProvider.pageLoading
            ? Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(20),
          child: const SizedBox(
            height: 60,
            width: 60,
            child: CircularProgressIndicator(
              color: MyColors.mainThemeDarkColor,
              strokeWidth: 3,
            ),
          ),
        )
            : agreementProvider.allAgreements.isEmpty
            ? Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 50),
          padding: const EdgeInsets.all(20),
          child: const Text("No Agreements"),
        )
            : ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
          itemCount: agreementProvider.allAgreements.length,
          itemBuilder: (context, index) {
            var agreement = agreementProvider.allAgreements.reversed.toList()[index];
            return AgreementCard(
              agreement: agreement,
            );
          },
        ),
      ),
    );
  }
}
