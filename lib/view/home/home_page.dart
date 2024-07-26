import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oprs/components/cards/property_card_tenant.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/listing_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/home/filter_page.dart';
import 'package:oprs/view/home/search_page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
    const HomePage({super.key});
    @override
    State<HomePage> createState() => _HomePageState();
  }

class _HomePageState extends State<HomePage>{
  @override
  Widget build(BuildContext context) {
    var listingProvider = Provider.of<ListingProvider>(context);
    void showFilterBottomSheeet() {
      showModalBottomSheet(
        context: context,
        scrollControlDisabledMaxHeightRatio: 0.9,
        builder: (context) {
          return FilterPage(filterModel: listingProvider.filterModel);
        }
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text("Neway"),
           backgroundColor: MyColors.mainThemeDarkColor,
          foregroundColor:MyColors.mainThemeLightColor,
          actions: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: const Icon(Icons.search, color:MyColors.mainThemeLightColor),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SearchPage()),
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              child: IconButton(
                icon: SvgPicture.asset(
                  "assets/icons/fliter.svg",
                  color:MyColors.mainThemeLightColor,
                ),
                onPressed: () {
                  showFilterBottomSheeet();
                },
              ),
            )
          ],
        ),
        body: Flex(
        direction: Axis.vertical,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            color: MyColors.mainThemeDarkColor,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      direction: Axis.horizontal,
                      spacing: 5,
                      runSpacing: 5,
                      children: List.generate(listingProvider.feedOptions.length,(index) {
                        return ChoiceChip(
                          label: Text(
                            listingProvider.feedOptions[index].label
                          ),
                          showCheckmark: false,
                          selected: listingProvider.feedOptions[index].selected,
                          padding: const EdgeInsets.all(18),
                           backgroundColor: MyColors.mainThemeDarkColor.withOpacity(0.8),
                          selectedColor:MyColors.mainThemeLightColor,
                          onSelected: (val) {
                            listingProvider.updateFeed(index, val);
                          },
                          labelStyle: TextStyle(
                            color: listingProvider.feedOptions[index].selected ?
                              MyColors.mainThemeDarkColor :
                              MyColors.mainThemeLightColor,
                              fontSize: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                              side: const BorderSide(
                                width: 0,
                                color: MyColors.mainThemeDarkColor,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside),
                            ),
                          );
                        }
                      )
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: listingProvider.onPageRefresh,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: listingProvider.pageLoading ? Container(
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
                ) : listingProvider.allListings.isEmpty || listingProvider.errorMessage.isNotEmpty ?
                Container(
                  margin: const EdgeInsets.only(top: 100),
                  alignment: Alignment.topCenter,
                  child: Column(
                    children: [
                      Text(
                        listingProvider.errorMessage.isNotEmpty ? listingProvider.errorMessage : "No results",
                        style: const TextStyle(fontSize: 14)
                      ),
                      const SizedBox(height: 20),
                      OutlinedButton(
                        onPressed: () {
                          listingProvider.loadListings().then((value){
                            listingProvider.errorMessage.isEmpty ? null :
                            SnackBarMessage.make(context, listingProvider.errorMessage);
                          });
                        },
                        child: const Text("Retry"),
                      ),
                    ],
                  )
                ) : Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          listingProvider.selectedFeed.isEmpty ? "All Categories" : listingProvider.selectedFeed,
                          style: const TextStyle(
                            fontSize: 20,
                            color: MyColors.headerFontColor,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                      MasonryView(
                        listOfItem: List.generate(listingProvider.feedListings.length, (index) {
                          return PropertyCardTenant(listing: listingProvider.feedListings[index]);
                        }),
                        itemPadding: 5,
                        itemRadius: 5,
                        numberOfColumn: 2,
                        itemBuilder: (item) {
                          return item;
                        },
                      ),
                      listingProvider.totalPages >  1?
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        child: Row(
                          crossAxisAlignment:CrossAxisAlignment.center,
                          mainAxisAlignment:MainAxisAlignment.center,
                          children: [
                            Wrap(
                              children: [
                                IconButton.outlined(
                                  onPressed: () {
                                    listingProvider.previousPage();
                                  },
                                  icon: const Icon(Icons.arrow_back)
                                ),
                                Container(
                                  width: 50,
                                  height: 40,
                                  margin: const EdgeInsets.symmetric(horizontal: 20),
                                  alignment: Alignment.center,
                                  child: Text('Page ${listingProvider.currentPage}'),
                                ),
                                IconButton.outlined(
                                  onPressed: () {
                                    listingProvider.nextPage();
                                  },
                                  icon: const Icon(Icons.arrow_forward),
                                )
                              ],
                            )
                          ],
                        ),
                      ) :
                    Container()
                  ],
                )
              ),
            ),
          ),
        ],
      )
    );
  }
}
