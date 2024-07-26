import 'package:flutter/material.dart';
import 'package:flutter_masonry_view/flutter_masonry_view.dart';
import 'package:oprs/components/cards/property_card_tenant.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/provider/search_provider.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    var searchProvider = Provider.of<SearchProvider>(context);
    return Scaffold(
      appBar: AppBar(
       foregroundColor: MyColors.mainThemeLightColor,
       backgroundColor: MyColors.mainThemeDarkColor,
      title: TextField(
          controller: searchProvider.controller,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 15,
            color: MyColors.mainThemeLightColor,
            fontStyle: FontStyle.normal
          ),
          cursorColor: MyColors.mainThemeLightColor,
          decoration: InputDecoration(
            border : InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            hintText: "Search",
            hintStyle: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 15,
              color: MyColors.mainThemeLightColor.withOpacity(0.8),
              fontStyle: FontStyle.normal,
            ),
            suffixIcon: Visibility(
              visible: searchProvider.searchQuery.isNotEmpty,
              child: IconButton(
                onPressed: (){searchProvider.clearQuery();},
                icon: Icon(
                  Icons.close,
                  color: MyColors.mainThemeLightColor.withOpacity(0.5),
                  size: 20,
                ),
              ),
            ),
          ),
          onChanged: (query){
            searchProvider.updateQuery(query); },
          onSubmitted: (query) async {
            if(query.isNotEmpty){
              searchProvider.loadMatchingListings().then((value){
                if(searchProvider.errorMessage.isNotEmpty) {
                  SnackBarMessage.make(context, searchProvider.errorMessage);
                }
              });
            }
          },
        ),
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
              child: searchProvider.pageLoading ?
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
              ) : searchProvider.allListings.isEmpty || searchProvider.errorMessage.isNotEmpty ?
              Container(
                  height: 300,
                  margin: const EdgeInsets.only(top: 100),
                  child: Column(
                    children: [
                      Text(
                          searchProvider.errorMessage.isNotEmpty ? searchProvider.errorMessage : "No results",
                          style: TextStyle(fontSize: 14)
                      ),
                      const SizedBox(height: 20),
                      searchProvider.errorMessage.isNotEmpty ?
                      OutlinedButton(
                        onPressed: () {
                          searchProvider.loadMatchingListings().then((value){
                            searchProvider.errorMessage.isEmpty ? null :
                            SnackBarMessage.make(context, searchProvider.errorMessage);
                          });
                        },
                        child: const Text("Retry"),
                      ) : Container(),
                    ],
                  )
              ) : Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    alignment: Alignment.centerLeft,
                    child: const
                    Text(
                      "All Categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: MyColors.headerFontColor,
                      ),
                    ),
                  ),
                  MasonryView(
                    listOfItem: List.generate(searchProvider.allListings.length, (index) {
                      return PropertyCardTenant(listing: searchProvider.allListings[index]);
                    }),
                    itemPadding: 5,
                    itemRadius: 5,
                    numberOfColumn: 2,
                    itemBuilder: (item) {
                      return item;
                    },
                  ),
                  searchProvider.allListings.length > 10 ?
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
                                  searchProvider.previousPage();
                                },
                                icon: const Icon(Icons.arrow_back)
                            ),
                            Container(
                              width: 50,
                              height: 40,
                              margin: const EdgeInsets.symmetric(horizontal: 20),
                              alignment: Alignment.center,
                              child: Text('Page ${searchProvider.currentPage}'),
                            ),
                            IconButton.outlined(
                              onPressed: () {
                                searchProvider.nextPage();
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
        ],
      ),
    );
  }
}