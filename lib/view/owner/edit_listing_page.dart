import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/components/input/listing_image_input.dart';
import 'package:oprs/components/input/map_marker_input.dart';
import 'package:oprs/components/input/number_input.dart';
import 'package:oprs/components/input/custom_text_input.dart';
import 'package:oprs/components/input/drop_down_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/listing.dart';
import 'package:dio/dio.dart' as dio;
import 'package:oprs/provider/owner_provider.dart';
import 'package:oprs/repo/listing_repo.dart';
import 'package:oprs/utils/snack_bar_message.dart';
import 'package:oprs/view/view_constants.dart';
import 'package:provider/provider.dart';

class EditListingPage extends StatefulWidget {
  final Listing listingModel;
  const EditListingPage({super.key, required this.listingModel});
  @override
  State<EditListingPage> createState() => EditListingPageState();
}

class EditListingPageState extends State<EditListingPage> {
  int currentStep = 0;
  List<XFile> photos = <XFile>[];
  ScrollController controller = ScrollController();
  bool waiting = false;
  final List<String> subCityOptions = List.from(subCityOptionsConstant);
  Map<String, String> inputErrors = Map.from(editListingInputErrorsConstant);
  List<SelectionChip> leaseDurationOptions =
      leaseDurationOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> paymentCurrencyOptions =
      paymentCurrencyOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> propertyCategoryOptions =
      propertyCategoryOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> warehouseOptions =
      warehouseOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> eventOptions =
      eventOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> commercialOptions =
      commercialOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> residentalOptions =
      residentalOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> residentalAmenities =
      residentalAmenitiesConstant.map((e) => e.copy()).toList();
  List<SelectionChip> warehouseAmenities =
      warehouseAmenitiesConstant.map((e) => e.copy()).toList();
  List<SelectionChip> eventAmenities =
      eventAmenitiesConstant.map((e) => e.copy()).toList();
  List<SelectionChip> commercialAmenities =
      commercialAmenitiesConstant.map((e) => e.copy()).toList();

  @override
  void initState() {
    super.initState();
    widget.listingModel.latLng ??=
        const LatLng(9.031189291103262, 38.752624277434705);
    assignLeaseDuration();
    assignSelectionChips();
  }

  bool isInteger(String input) {
    RegExp regExp = RegExp(r'^-?\d+$');
    return regExp.hasMatch(input);
  }

  void assignLeaseDuration() {
    if (widget.listingModel.leaseDurationDays == 1) {
      leaseDurationOptions[0].selected = true;
    } else if (widget.listingModel.leaseDurationDays == 7) {
      leaseDurationOptions[1].selected = true;
    } else if (widget.listingModel.leaseDurationDays == 30) {
      leaseDurationOptions[2].selected = true;
    } else {
      leaseDurationOptions[3].selected = true;
    }
  }

  void assignSelectionChips() {
    List<SelectionChip> propertyAmenities;
    List<SelectionChip> propertyDescribingTerms;
    switch (widget.listingModel.type) {
      case "RESIDENTIAL":
        propertyAmenities = residentalAmenities;
        propertyDescribingTerms = residentalOptions;
        break;
      case "COMMERCIAL":
        propertyAmenities = commercialAmenities;
        propertyDescribingTerms = commercialOptions;
        break;
      case "EVENT":
        propertyAmenities = eventAmenities;
        propertyDescribingTerms = eventOptions;
        break;
      case "STORAGE":
        propertyAmenities = warehouseAmenities;
        propertyDescribingTerms = warehouseOptions;
        break;
      default:
        propertyAmenities = [];
        propertyDescribingTerms = [];
        break;
    }
    for (var element in propertyAmenities) {
      if (widget.listingModel.amenities.contains(element.label)) {
        element.selected = true;
      }
    }

    for (var element in propertyDescribingTerms) {
      if (widget.listingModel.describingTerms.contains(element.label)) {
        element.selected = true;
      }
    }

    for (var element in paymentCurrencyOptions) {
      if (widget.listingModel.paymentCurrency == element.label) {
        element.selected = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var ownerProvider = Provider.of<OwnerProvider>(context);
    CustomTextInput titleInput = CustomTextInput(
      hintText: 'Title',
      inputType: TextInputType.name,
      obscureText: false,
      initialValue: widget.listingModel.title,
      onChanged: (text) {
        setState(() {
          widget.listingModel.title = text;
        });
      },
      errorText: inputErrors["title"]!.isNotEmpty ? inputErrors["title"] : null,
    );
    CustomTextInput descriptionInput = CustomTextInput(
      hintText: 'Description',
      inputType: TextInputType.name,
      maxLines: 15,
      minLines: 5,
      maxValue: 500,
      obscureText: false,
      initialValue: widget.listingModel.description,
      onChanged: (text) {
        setState(() {
          widget.listingModel.description = text;
        });
      },
      errorText: inputErrors["description"]!.isNotEmpty
          ? inputErrors["description"]
          : null,
    );
    ChipSelectionInput describingTermInput = ChipSelectionInput(
      options: widget.listingModel.type == "RESIDENTIAL"
          ? residentalOptions
          : widget.listingModel.type == "STORAGE"
              ? warehouseOptions
              : widget.listingModel.type == "EVENT"
                  ? eventOptions
                  : commercialOptions,
      onSelected: (options) {
        List<String> newDescribingTerms = [];
        for (var element in options) {
          if (element.selected) {
            newDescribingTerms.add(element.label);
          }
        }
        setState(() {
          widget.listingModel.describingTerms = newDescribingTerms;
          widget.listingModel.type == "RESIDENTIAL"
              ? residentalOptions = options
              : widget.listingModel.type == "STORAGE"
                  ? warehouseOptions = options
                  : widget.listingModel.type == "COMMERCIAL"
                      ? commercialOptions = options
                      : eventOptions = options;
        });
      },
      radius: 10,
      gap: 8,
      padding: 14,
      fontSize: 16,
      singleSelection: false,
      lightColor: MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: 3,
    );

    DropDownButtonForm subCityInput = DropDownButtonForm(
      allOptions: subCityOptions,
      initialValue: widget.listingModel.subCity.isNotEmpty
          ? widget.listingModel.subCity
          : subCityOptions[0],
      hintText: "Sub City",
      onChanged: (selected) {
        setState(() {
          widget.listingModel.subCity = selected!;
        });
      },
      errorText: null,
    );
    CustomTextInput woredaInput = CustomTextInput(
      hintText: 'Woreda',
      inputType: TextInputType.text,
      obscureText: false,
      initialValue: widget.listingModel.woreda,
      onChanged: (text) {
        setState(() {
          widget.listingModel.woreda = text;
        });
      },
      errorText:
          inputErrors["woreda"]!.isNotEmpty ? inputErrors["woreda"] : null,
    );
    NumberInput distanceFromRoadInput = NumberInput(
      initialValue: widget.listingModel.distanceFromRoadInMeters,
      limitValue: 999,
      changeValue: 10,
      onValueChanged: (val) {
        setState(() {
          widget.listingModel.distanceFromRoadInMeters = val;
        });
      },
      label: 'Distance from Road (Meter)',
    );
    CustomTextInput areaNameInput = CustomTextInput(
      hintText: 'Specific Area',
      inputType: TextInputType.name,
      obscureText: false,
      initialValue: widget.listingModel.areaName,
      onChanged: (text) {
        setState(() {
          widget.listingModel.areaName = text;
        });
      },
      errorText:
          inputErrors["areaName"]!.isNotEmpty ? inputErrors["areaName"] : null,
    );
    CustomTextInput totalAreaSquareMeterInput = CustomTextInput(
      hintText: 'Total Area(sqm)',
      inputType: TextInputType.number,
      obscureText: false,
      initialValue: widget.listingModel.totalAreaSquareMeter == 0
          ? ""
          : widget.listingModel.totalAreaSquareMeter.toString(),
      onChanged: (text) {
        setState(() {
          widget.listingModel.totalAreaSquareMeter =
              isInteger(text) ? int.parse(text) : 0;
        });
      },
      errorText: inputErrors["totalAreaSquareMeter"]!.isNotEmpty
          ? inputErrors["totalAreaSquareMeter"]
          : null,
    );
    ChipSelectionInput leaseDurationInput = ChipSelectionInput(
      options: leaseDurationOptions,
      onSelected: (options) {
        List<String> newDurationDays = [];
        setState(() {
          for (var element in options) {
            if (element.selected) {
              newDurationDays.add(element.label);
            }
          }
          widget.listingModel.leaseDurationDays = newDurationDays.isEmpty
              ? 0
              : newDurationDays[0] == "Daily"
                  ? 1
                  : newDurationDays[0] == "Weekly"
                      ? 7
                      : newDurationDays[0] == "Monthly"
                          ? 30
                          : 1;
          leaseDurationOptions = options;
        });
      },
      radius: 10,
      gap: 8,
      padding: 14,
      fontSize: 16,
      singleSelection: true,
      lightColor: MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: 1,
    );
    CustomTextInput priceInput = CustomTextInput(
      hintText: "Price per Duration",
      inputType: TextInputType.number,
      obscureText: false,
      initialValue: widget.listingModel.pricePerDuration,
      onChanged: (text) {
        setState(() {
          if (text.isNotEmpty && text.length < 3) {
            inputErrors["pricePerDuration"] =
                "Price atleast should be three digits";
          } else {
            inputErrors["pricePerDuration"] = "";
          }
          widget.listingModel.pricePerDuration = text;
        });
      },
      errorText: inputErrors["pricePerDuration"]!.isNotEmpty
          ? inputErrors["pricePerDuration"]
          : null,
    );
    ChipSelectionInput currencyInput = ChipSelectionInput(
      options: paymentCurrencyOptions,
      onSelected: (options) {
        setState(() {
          widget.listingModel.paymentCurrency = "";
          for (var element in options) {
            if (element.selected) {
              widget.listingModel.paymentCurrency = element.label;
            }
          }
          paymentCurrencyOptions = options;
        });
      },
      radius: 10,
      gap: 8,
      padding: 14,
      fontSize: 16,
      singleSelection: true,
      lightColor: MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: 1,
    );
    NumberInput parkingCapacityInput = NumberInput(
      initialValue: widget.listingModel.parkingCapacity,
      limitValue: 999,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.listingModel.parkingCapacity = val;
        });
      },
      label: 'Parking Capacity',
    );
    ChipSelectionInput amenitiesInput = ChipSelectionInput(
      options: widget.listingModel.type == "RESIDENTIAL"
          ? residentalAmenities
          : widget.listingModel.type == "EVENT"
              ? eventAmenities
              : widget.listingModel.type == "STORAGE"
                  ? warehouseAmenities
                  : commercialAmenities,
      onSelected: (options) {
        List<String> newAmenities = [];
        for (var element in options) {
          if (element.selected) {
            newAmenities.add(element.label);
          }
        }
        setState(() {
          widget.listingModel.amenities = newAmenities;
          widget.listingModel.type == "RESIDENTIAL"
              ? residentalAmenities = options
              : widget.listingModel.type == "EVENT"
                  ? eventAmenities = options
                  : widget.listingModel.type == "STORAGE"
                      ? warehouseAmenities = options
                      : commercialAmenities = options;
        });
      },
      radius: 10,
      gap: 8,
      padding: 14,
      fontSize: 16,
      singleSelection: false,
      lightColor: MyColors.mainThemeLightColor,
      darkColor: MyColors.mainThemeDarkColor,
      limit: residentalAmenities.length,
    );
    Container mapMarkerInput = Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        height: MediaQuery.of(context).size.height * 0.5,
        child: MapMarkerInput(
          initialPoint: widget.listingModel.latLng ??
              const LatLng(9.031189291103262, 38.752624277434705),
          onMarkerChanged: (position, latLng) {
            setState(() {
              widget.listingModel.latLng = latLng;
            });
          },
        ));

    void handleCreateListing() async {
      dio.FormData listingData = await createListingData();
      setState(() {
        waiting = true;
      });
      ListingRepo().createListing(listingData).then((response) {
        setState(() {
          waiting = false;
        });
        if (response["status"] != 200) {
          SnackBarMessage.make(context, response["message"]);
        } else {
          SnackBarMessage.make(context, response["message"]);
          ownerProvider.loadListings();
          Navigator.pop(context);
        }
      });
    }

    void handleUpdateListing() async {
      dio.FormData listingData = await createListingData();
      setState(() {
        waiting = true;
      });
      ListingRepo()
          .modifyListing(listingData, widget.listingModel.listingId)
          .then((response) {
        setState(() {
          waiting = false;
        });
        if (response["status"] != 200) {
          SnackBarMessage.make(context, response["message"]);
        } else {
          SnackBarMessage.make(context, response["message"]);
          ownerProvider.loadListings();
          Navigator.pop(context);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.listingModel.listingId > 0
            ? 'Edit Listing'
            : 'Create Listing'),
        backgroundColor: MyColors.mainThemeDarkColor,
        foregroundColor: MyColors.mainThemeLightColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              child: ConstrainedBox(
            constraints: BoxConstraints.expand(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
            ),
            child: Stepper(
              type: StepperType.horizontal,
              controller: controller,
              currentStep: currentStep,
              onStepTapped: (step) {
                setState(() {
                  currentStep = step;
                });
              },
              controlsBuilder: (context, details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: CustomElevatedButton(
                        onPressed: waiting || currentStep < 1
                            ? null
                            : details.onStepCancel,
                        isLoading: false,
                        loadingText: "Waiting",
                        loadingTextColor: MyColors.mainThemeDarkColor,
                        buttonText: "Back",
                        buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                        buttonTextColor: MyColors.mainThemeLightColor,
                        insetV: 25,
                        radius: 5,
                      ),
                    ),
                    const SizedBox(width: 10),
                    currentStep != 5
                        ? Expanded(
                            child: CustomElevatedButton(
                              onPressed: details.onStepContinue,
                              isLoading: false,
                              loadingText: "Waiting",
                              loadingTextColor: MyColors.mainThemeDarkColor,
                              buttonText: "Next",
                              buttonTextBackgroundColor:
                                  MyColors.mainThemeDarkColor,
                              buttonTextColor: MyColors.mainThemeLightColor,
                              insetV: 25,
                              radius: 5,
                            ),
                          )
                        : Expanded(
                            child: CustomElevatedButton(
                              onPressed: waiting
                                  ? null
                                  : () {
                                      if (checkEmptyInput()) {
                                        SnackBarMessage.make(context,
                                            "Please provide the required information!");
                                        return;
                                      }
                                      if (widget.listingModel.listingId < 1) {
                                        handleCreateListing();
                                      } else {
                                        handleUpdateListing();
                                      }
                                    },
                              isLoading: waiting,
                              loadingText: "Waiting",
                              loadingTextColor: MyColors.mainThemeDarkColor,
                              buttonText: "Finish",
                              buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                              buttonTextColor: MyColors.mainThemeLightColor,
                              insetV: 25,
                              radius: 5,
                            ),
                          ),
                  ],
                );
              },
              onStepContinue: () {
                setState(() {
                  if (currentStep < 5) {
                    controller.jumpTo(0.0);
                    currentStep += 1;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (currentStep > 0) {
                    controller.jumpTo(0.0);
                    currentStep -= 1;
                  }
                });
              },
              steps: <Step>[
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text("Property basic information (required)",
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.headerFontColor,
                          )),
                      const SizedBox(height: 25),
                      titleInput,
                      descriptionInput,
                      const SizedBox(height: 15),
                      const Text("Which of these terms describe your property?",
                          style: TextStyle(
                            fontSize: 16,
                            color: MyColors.headerFontColor,
                          )),
                      const SizedBox(height: 25),
                      describingTermInput,
                      const SizedBox(height: 25),
                    ],
                  ),
                  isActive: currentStep == 0,
                ),
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Property location details (required)",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 25),
                      subCityInput,
                      const SizedBox(height: 15),
                      woredaInput,
                      totalAreaSquareMeterInput,
                      areaNameInput,
                      distanceFromRoadInput,
                      const SizedBox(height: 15),
                      const Text(
                        "Mark the location on map",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      mapMarkerInput,
                      const SizedBox(height: 15),
                    ],
                  ),
                  isActive: currentStep == 1,
                ),
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Property feature details (required)",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 25),
                      ...(widget.listingModel.type == "COMMERCIAL"
                          ? [
                              CustomTextInput(
                                hintText: "Building Name(optional)",
                                inputType: TextInputType.number,
                                obscureText: false,
                                initialValue: widget.listingModel.buildingName,
                                onChanged: (text) {
                                  setState(() {
                                    if (text.isNotEmpty && text.length < 3) {
                                      inputErrors["buildingName"] =
                                          "Name too short!";
                                    } else {
                                      inputErrors["buildingName"] = "";
                                    }
                                    widget.listingModel.buildingName = text;
                                  });
                                },
                                errorText:
                                    inputErrors["buildingName"]!.isNotEmpty
                                        ? inputErrors["buildingName"]
                                        : null,
                              ),
                              NumberInput(
                                initialValue:
                                    widget.listingModel.numberOfFloors,
                                limitValue: 80,
                                changeValue: 1,
                                onValueChanged: (val) {
                                  setState(() {
                                    if (val <= 1) {
                                      widget.listingModel.floorNumber = 1;
                                    }
                                    widget.listingModel.numberOfFloors = val;
                                  });
                                },
                                label: 'Floors',
                              ),
                              widget.listingModel.numberOfFloors > 1
                                  ? NumberInput(
                                      initialValue:
                                          widget.listingModel.floorNumber,
                                      limitValue: 80,
                                      changeValue: 1,
                                      onValueChanged: (val) {
                                        setState(() {
                                          widget.listingModel.floorNumber = val;
                                        });
                                      },
                                      label: 'Floor number',
                                    )
                                  : Container(),
                              const Text("Tax Responsibility",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: MyColors.headerFontColor,
                                  )),
                              DropDownButtonForm(
                                allOptions: const ["Owner", "Tenant"],
                                initialValue: widget.listingModel
                                        .taxResponsibility.isNotEmpty
                                    ? widget.listingModel.taxResponsibility
                                    : "Owner",
                                hintText: "Tax Payer",
                                onChanged: (selected) {
                                  setState(() {
                                    widget.listingModel.taxResponsibility =
                                        selected!;
                                  });
                                },
                                errorText: null,
                              ),
                              NumberInput(
                                initialValue: widget.listingModel.backrooms,
                                limitValue: 10,
                                changeValue: 1,
                                onValueChanged: (val) {
                                  setState(() {
                                    widget.listingModel.backrooms = val;
                                  });
                                },
                                label: 'Backrooms',
                              ),
                              parkingCapacityInput,
                              NumberInput(
                                initialValue: widget.listingModel.displays,
                                limitValue: 10,
                                changeValue: 1,
                                onValueChanged: (val) {
                                  setState(() {
                                    widget.listingModel.displays = val;
                                  });
                                },
                                label: 'Displays',
                              ),
                              NumberInput(
                                initialValue:
                                    widget.listingModel.customerServiceDesks,
                                limitValue: 10,
                                changeValue: 1,
                                onValueChanged: (val) {
                                  setState(() {
                                    widget.listingModel.customerServiceDesks =
                                        val;
                                  });
                                },
                                label: 'Customer Service Desks',
                              ),
                              const SizedBox(height: 15),
                            ]
                          : widget.listingModel.type == "EVENT"
                              ? [
                                  CustomTextInput(
                                    hintText: "Building Name(optional)",
                                    inputType: TextInputType.number,
                                    obscureText: false,
                                    initialValue:
                                        widget.listingModel.buildingName,
                                    onChanged: (text) {
                                      setState(() {
                                        if (text.isNotEmpty &&
                                            text.length < 3) {
                                          inputErrors["buildingName"] =
                                              "Name too short!";
                                        } else {
                                          inputErrors["buildingName"] = "";
                                        }
                                        widget.listingModel.buildingName = text;
                                      });
                                    },
                                    errorText:
                                        inputErrors["buildingName"]!.isNotEmpty
                                            ? inputErrors["buildingName"]
                                            : null,
                                  ),
                                  NumberInput(
                                    initialValue:
                                        widget.listingModel.guestCapacity,
                                    limitValue: 20000,
                                    changeValue: 100,
                                    onValueChanged: (val) {
                                      setState(() {
                                        widget.listingModel.guestCapacity = val;
                                      });
                                    },
                                    label: 'Number of Guests',
                                  ),
                                  parkingCapacityInput,
                                  NumberInput(
                                    initialValue:
                                        widget.listingModel.backStages,
                                    limitValue: 10,
                                    changeValue: 1,
                                    onValueChanged: (val) {
                                      setState(() {
                                        widget.listingModel.backStages = val;
                                      });
                                    },
                                    label: 'Backstages',
                                  ),
                                  NumberInput(
                                    initialValue:
                                        widget.listingModel.cateringRooms,
                                    limitValue: 10,
                                    changeValue: 1,
                                    onValueChanged: (val) {
                                      setState(() {
                                        widget.listingModel.cateringRooms = val;
                                      });
                                    },
                                    label: 'Catering rooms',
                                  ),
                                  NumberInput(
                                    initialValue:
                                        widget.listingModel.floorNumber,
                                    limitValue: 80,
                                    changeValue: 1,
                                    onValueChanged: (val) {
                                      setState(() {
                                        widget.listingModel.floorNumber = val;
                                      });
                                    },
                                    label: 'Floor number',
                                  ),
                                  const SizedBox(height: 15),
                                ]
                              : widget.listingModel.type == "STORAGE"
                                  ? [
                                      NumberInput(
                                        initialValue: widget.listingModel
                                            .storageCapacitySquareMeter,
                                        limitValue: 1500,
                                        changeValue: 50,
                                        onValueChanged: (val) {
                                          setState(() {
                                            widget.listingModel
                                                    .storageCapacitySquareMeter =
                                                val;
                                          });
                                        },
                                        label: 'Capcity (Square meter)',
                                      ),
                                      NumberInput(
                                        initialValue:
                                            widget.listingModel.loadingDocks,
                                        limitValue: 50,
                                        changeValue: 1,
                                        onValueChanged: (val) {
                                          setState(() {
                                            widget.listingModel.loadingDocks =
                                                val;
                                          });
                                        },
                                        label: 'Loading Docks',
                                      ),
                                      NumberInput(
                                        initialValue:
                                            widget.listingModel.securityGuards,
                                        limitValue: 50,
                                        changeValue: 1,
                                        onValueChanged: (val) {
                                          setState(() {
                                            widget.listingModel.securityGuards =
                                                val;
                                          });
                                        },
                                        label: 'Security Guards',
                                      ),
                                      parkingCapacityInput,
                                      NumberInput(
                                        initialValue: widget
                                            .listingModel.ceilingHeightInMeters,
                                        limitValue: 30,
                                        changeValue: 1,
                                        onValueChanged: (val) {
                                          setState(() {
                                            widget.listingModel
                                                .ceilingHeightInMeters = val;
                                          });
                                        },
                                        label: 'Ceiling Height',
                                      ),
                                      const SizedBox(height: 15),
                                    ]
                                  : widget.listingModel.type == "RESIDENTIAL"
                                      ? [
                                          NumberInput(
                                            initialValue: widget
                                                .listingModel.numberOfBedrooms,
                                            limitValue: 20,
                                            changeValue: 1,
                                            onValueChanged: (val) {
                                              setState(() {
                                                widget.listingModel
                                                    .numberOfBedrooms = val;
                                              });
                                            },
                                            label: 'Bedrooms',
                                          ),
                                          NumberInput(
                                            initialValue: widget
                                                .listingModel.numberOfBathrooms,
                                            limitValue: 20,
                                            changeValue: 1,
                                            onValueChanged: (val) {
                                              setState(() {
                                                widget.listingModel
                                                    .numberOfBathrooms = val;
                                              });
                                            },
                                            label: 'Bathrooms',
                                          ),
                                          NumberInput(
                                            initialValue: widget
                                                .listingModel.numberOfKitchens,
                                            limitValue: 20,
                                            changeValue: 1,
                                            onValueChanged: (val) {
                                              setState(() {
                                                widget.listingModel
                                                    .numberOfKitchens = val;
                                              });
                                            },
                                            label: 'Kitchens',
                                          ),
                                          parkingCapacityInput,
                                          NumberInput(
                                            initialValue: widget
                                                .listingModel.numberOfFloors,
                                            limitValue: 80,
                                            changeValue: 1,
                                            onValueChanged: (val) {
                                              setState(() {
                                                if (val <= 1) {
                                                  widget.listingModel
                                                      .floorNumber = 1;
                                                }
                                                widget.listingModel
                                                    .numberOfFloors = val;
                                              });
                                            },
                                            label: 'Floors',
                                          ),
                                          widget.listingModel.numberOfFloors > 1
                                              ? NumberInput(
                                                  initialValue: widget
                                                      .listingModel.floorNumber,
                                                  limitValue: 80,
                                                  changeValue: 1,
                                                  onValueChanged: (val) {
                                                    setState(() {
                                                      widget.listingModel
                                                          .floorNumber = val;
                                                    });
                                                  },
                                                  label: 'Floor number',
                                                )
                                              : Container(),
                                          const SizedBox(height: 15),
                                        ]
                                      : [Container()]),
                    ],
                  ),
                  isActive: currentStep == 2,
                ),
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Property payment information (required)",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text("Lease duration",
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.headerFontColor,
                          )),
                      const SizedBox(height: 15),
                      leaseDurationInput,
                      const SizedBox(height: 30),
                      const Text("Price",
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.headerFontColor,
                          )),
                      priceInput,
                      const Text("Select currency",
                          style: TextStyle(
                            fontSize: 14,
                            color: MyColors.headerFontColor,
                          )),
                      const SizedBox(height: 15),
                      currencyInput,
                      const SizedBox(height: 30),
                    ],
                  ),
                  isActive: currentStep == 3,
                ),
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Select photos (required)",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      MultiImageInput(
                        onImagesSelected: (images) {
                          setState(() {
                            photos = images;
                          });
                        },
                      ),
                      const SizedBox(height: 15),
                    ],
                  ),
                  isActive: currentStep == 4,
                ),
                Step(
                  title: const Text(''),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 15),
                      const Text(
                        "Add additional utilities or services",
                        style: TextStyle(
                          fontSize: 16,
                          color: MyColors.headerFontColor,
                        ),
                      ),
                      const SizedBox(height: 15),
                      amenitiesInput,
                      const SizedBox(height: 30),
                    ],
                  ),
                  isActive: currentStep == 5,
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }

  bool checkEmptyInput() {
    if (widget.listingModel.title.isEmpty ||
        widget.listingModel.description.isEmpty ||
        widget.listingModel.type.isEmpty ||
        photos.isEmpty ||
        widget.listingModel.subCity.isEmpty ||
        widget.listingModel.woreda.isEmpty ||
        widget.listingModel.areaName.isEmpty ||
        widget.listingModel.paymentCurrency.isEmpty ||
        widget.listingModel.totalAreaSquareMeter < 1 ||
        widget.listingModel.leaseDurationDays < 1 ||
        widget.listingModel.pricePerDuration.isEmpty) {
      return true;
    }
    return false;
  }

  String checkInputErrors() {
    String emptyFound = "";
    inputErrors.forEach((key, value) {
      if (value.isNotEmpty) {
        emptyFound = value;
      }
    });
    return emptyFound;
  }

  Future<dio.FormData> createListingData() async {
    List<dio.MultipartFile> files = [];
    if (photos.isNotEmpty) {
      for (var photo in photos) {
        List<int> bytes = await photo.readAsBytes();
        dio.MultipartFile mFile = dio.MultipartFile.fromBytes(bytes,
            filename: photo.name, contentType: MediaType("image", "jpeg"));
        files.add(mFile);
      }
    }

    dio.FormData result = dio.FormData.fromMap({
      "title": widget.listingModel.title,
      "description": widget.listingModel.description,
      "listing_id": widget.listingModel.listingId,
      "total_area_square_meter": widget.listingModel.totalAreaSquareMeter,
      "sub_city": widget.listingModel.subCity,
      "woreda": widget.listingModel.woreda,
      "area_name": widget.listingModel.areaName,
      "price_per_duration": widget.listingModel.pricePerDuration,
      "payment_currency": widget.listingModel.paymentCurrency,
      "building_name": widget.listingModel.buildingName,
      "tax_responsibility": widget.listingModel.taxResponsibility,
      "type": widget.listingModel.type,
      "latitude": widget.listingModel.latLng?.latitude.toString() ??
          (9.031189291103262).toString(),
      "longitude": widget.listingModel.latLng?.longitude.toString() ??
          (38.752624277434705).toString(),
      "catering_rooms": widget.listingModel.cateringRooms,
      "back_stages": widget.listingModel.backStages,
      "floor_number": widget.listingModel.floorNumber,
      "distance_from_road_in_meters":
          widget.listingModel.distanceFromRoadInMeters,
      "lease_duration_days": widget.listingModel.leaseDurationDays,
      "backrooms": widget.listingModel.backrooms,
      "displays": widget.listingModel.displays,
      "customer_service_desks": widget.listingModel.customerServiceDesks,
      "number_of_bedrooms": widget.listingModel.numberOfBedrooms,
      "number_of_bathrooms": widget.listingModel.numberOfBathrooms,
      "number_of_kitchens": widget.listingModel.numberOfKitchens,
      "number_of_floors": widget.listingModel.numberOfFloors,
      "ceiling_height_in_meters": widget.listingModel.ceilingHeightInMeters,
      "storage_capacity_square_meter":
          widget.listingModel.storageCapacitySquareMeter,
      "security_guards": widget.listingModel.securityGuards,
      "loading_docks": widget.listingModel.loadingDocks,
      "guest_capacity": widget.listingModel.guestCapacity,
      "parking_capacity": widget.listingModel.parkingCapacity,
      "amenities": widget.listingModel.amenities,
      "describing_terms": widget.listingModel.describingTerms,
      "files": files,
    });

    return result;
  }
}
