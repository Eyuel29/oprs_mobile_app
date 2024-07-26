import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oprs/model/listing.dart';
import 'package:oprs/repo/listing_repo.dart';

class OwnerProvider extends ChangeNotifier {
  List<Listing> allMyListings = [];
  bool pageLoading = false;
  String errorMessage = "";

  Future<void> onPageRefresh() async {
    await loadListings();
    notifyListeners();
  }

  Future<void> loadListings() async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().getOwnerListing();
    if (value["status"] == 200) {
      allMyListings = value["listings"];
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    notifyListeners();
  }

  Future<void> deleteListing(int listingId) async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().deleteListing(listingId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    await loadListings();
    notifyListeners();
  }

  Future<void> setAvailable(int listingId) async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().setAvailable(listingId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    await loadListings();
    notifyListeners();
  }

  Future<void> setUnAvailable(int listingId) async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().setUnAvailable(listingId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    await loadListings();
    notifyListeners();
  }

  Future<void> modifyListing(int listingId, FormData formData) async {
    pageLoading = true;
    notifyListeners();
    final value = await ListingRepo().modifyListing(formData,listingId);
    if (value["status"] == 200) {
      errorMessage = "";
    } else {
      errorMessage = value["message"] ?? "Something went wrong!";
    }
    pageLoading = false;
    await loadListings();
    notifyListeners();
  }
}
