import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:oprs/components/cards/property_card_owner.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/provider/owner_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/owner/edit_listing_page.dart';
import 'package:provider/provider.dart';

class OwnerPage extends StatefulWidget {
  const OwnerPage({super.key});
  @override
  State<OwnerPage> createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  @override
  Widget build(BuildContext context) {
    var ownerProvider = Provider.of<OwnerProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
         backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor:MyColors.mainThemeLightColor,
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: ownerProvider.pageLoading ?
              Container(
                  alignment: Alignment.topCenter,
                  margin: const EdgeInsets.only(top: 100),
                  child: const SizedBox(
                    height: 40,
                    width: 40,
                    child: CircularProgressIndicator(
                      color: MyColors.mainThemeDarkColor,
                      strokeWidth: 3,
                    ),
                  )
              ) : ownerProvider.allMyListings.isEmpty ?
              Container(
                margin: const EdgeInsets.only(top: 100),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      ownerProvider.errorMessage.isNotEmpty ?
                      ownerProvider.errorMessage :
                      "No Results",
                      style: TextStyle(fontSize: 14)
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton(
                      onPressed: () {
                        ownerProvider.loadListings().then((value) {
                          ownerProvider.errorMessage.isEmpty ? null :
                          SnackBarMessage.make(context, ownerProvider.errorMessage);
                        });
                      },
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ) :
              RefreshIndicator(
                onRefresh: onPageRefresh,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: MasonryView(
                    listOfItem: List.generate(
                        ownerProvider.allMyListings.length, (index) {
                      return PropertyCardOwner(
                        radius: 10,
                        listing: ownerProvider.allMyListings[index],
                      );
                    }),
                    itemPadding: 5,
                    itemRadius: 5,
                    numberOfColumn: 1,
                    itemBuilder: (item) {
                      return item;
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(20.0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            backgroundColor: MyColors.mainThemeDarkColor,
            foregroundColor:MyColors.mainThemeLightColor,
          ),
          onPressed: () async {
            showInputDialog(context).then((selectedOption) {
              if (selectedOption != null && selectedOption.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditListingPage(
                      listingModel: Listing(type: selectedOption)
                    ),
                  ),
                );
              }
            });
          },
          child: const Text('Create'),
        ),
      ),
    );
  }
  Future<void> onPageRefresh() async {
    await Provider.of<OwnerProvider>(context, listen: false).loadListings();
  }
  Future<String?> showInputDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Select Category'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'RESIDENTIAL');
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Residential')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'STORAGE');
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Storage')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'COMMERCIAL');
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Commercial')),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context, 'EVENT');
              },
              child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text('Event')),
            ),
          ],
        );
      },
    );
  }
}