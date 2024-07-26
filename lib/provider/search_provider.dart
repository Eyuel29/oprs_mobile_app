import 'package:flutter/material.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/repo/listing_repo.dart';

class SearchProvider extends ChangeNotifier{
  List<Listing> allListings = [];
  int currentPage = 1, totalPages = 1;
  bool pageLoading = false;
  int randomNumber = 0;
  String errorMessage = "";
  String searchQuery = "";
  TextEditingController controller = TextEditingController();

  void updateQuery (String query){
    searchQuery = controller.text;
    notifyListeners();
  }

  void clearQuery (){
    controller.text = "";
    searchQuery = "";
    notifyListeners();
  }

  void previousPage() {
    currentPage--;
    loadMatchingListings();
    notifyListeners();
  }

  void nextPage() {
    currentPage++;
    loadMatchingListings();
    notifyListeners();
  }

  Future<void> onPageRefresh() async {
    await loadMatchingListings();
    notifyListeners();
  }

  Future<void> loadMatchingListings() async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().getPageMatchingResults(currentPage, searchQuery);
    if (value["status"] == 200) {
      allListings = value["listings"];
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }
}