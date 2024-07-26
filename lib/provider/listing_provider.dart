import 'package:flutter/cupertino.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/model/filter.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/repo/listing_repo.dart';

class ListingProvider extends ChangeNotifier {
  List<Listing> allListings = [];
  List<Listing> feedListings = [];

  Filter filterModel = Filter();
  int currentPage = 1;
  int totalPages = 1;

  bool pageLoading = false;
  List<SelectionChip> feedOptions  = [
    SelectionChip("Mansion", false),
    SelectionChip("Apartment", false),
    SelectionChip("Condominium", false),
    SelectionChip("Villa", false),
    SelectionChip("Shared Room", false),
    SelectionChip("Single Room", false),
    SelectionChip("Shop", false),
    SelectionChip("Display", false),
    SelectionChip("Retail store", false),
    SelectionChip("Office", false),
    SelectionChip("Cafe", false),
    SelectionChip("Restaurant", false),
    SelectionChip("Wedding hall", false),
    SelectionChip("Events hall", false),
  ];

  String selectedFeed = "";
  String errorMessage = "";
  bool applyFilters = false;

  void previousPage() {
    if (currentPage > 1) {
      currentPage--;
      loadListings();
    }
  }

  void nextPage() {
    if (currentPage < totalPages) {
      currentPage++;
      loadListings();
    }
  }

  Future<void> onPageRefresh() async {
    await loadListings();
    feedListings = allListings;
  }

  void setPageLoading(bool value) {
    pageLoading = value;
    notifyListeners();
  }

  void updateFeed(int index, bool val) {
    final updatedFeedOptions = List.from(feedOptions);
    for (var i = 0; i < updatedFeedOptions.length; i++) {
      updatedFeedOptions[i].selected = false;
    }
    updatedFeedOptions[index].selected = val;
    selectedFeed = updatedFeedOptions[index].selected ? updatedFeedOptions[index].label : "";
    feedListings = selectedFeed.isEmpty
        ? allListings
        : allListings.where((listing) => listing.describingTerms.contains(selectedFeed)).toList();
    notifyListeners();
  }

  Future<void> loadListings() async {
    setPageLoading(true);
    try {
      final value = await ListingRepo().getPageListing(currentPage, filterModel);
      if (value["status"] == 200) {
        allListings = value["listings"];
        feedListings = allListings;
        totalPages = (value["totalListings"] ?? 0) ~/ 10;
        errorMessage = "";
      } else {
        errorMessage = value["message"] ?? "Something went wrong!";
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      setPageLoading(false);
    }
    notifyListeners();
  }

  Future<void> loadFilters() async {
    setPageLoading(true);
    try {
      final value = await ListingRepo().getPageListing(currentPage, filterModel);
      if (value["status"] == 200) {
        allListings = value["listings"];
        feedListings = allListings;
        errorMessage = "";
      } else {
        errorMessage = value["message"] ?? "Something went wrong!";
      }
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      setPageLoading(false);
    }
  }

  void removeFilters() {
    filterModel = Filter();
    notifyListeners();
  }
}
