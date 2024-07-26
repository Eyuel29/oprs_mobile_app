import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:oprs/components/button/custom_elevated_button.dart';
import 'package:oprs/components/input/chip_selection_input.dart';
import 'package:oprs/components/input/drop_down_input.dart';
import 'package:oprs/components/input/number_input.dart';
import 'package:oprs/constant_values.dart';
import 'package:oprs/model/filter.dart';
import 'package:oprs/provider/listing_provider.dart';
import 'package:oprs/view/view_constants.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  Filter filterModel;
  FilterPage({ super.key, required this.filterModel });
  @override
  State<FilterPage> createState() => _FilterPageState();
}
class _FilterPageState extends State<FilterPage>{
  List<SelectionChip> categories = propertyCategoryOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> leaseDuration = leaseDurationOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> paymentCurrencyOptions = paymentCurrencyOptionsConstant.map((e) => e.copy()).toList();
  List<SelectionChip> ratingFilterOptions = [
    SelectionChip("Top Rated",false),
    SelectionChip("Latest",false),
  ];
  List<String> subCityOptions = ['ANY','KOLFE KERANIO', 'ARADA', 'GULELE', 'ADDIS KETEMA', 'LEMMI KURRA',
    'LIDETA', 'N/LAFTO','BOLE', 'YEKA', 'KIRKOS', 'AKAKI KALITI' ];

  @override
  void initState() {
    super.initState();
    if(widget.filterModel.propertyTypeOption.isNotEmpty){
      categories.where(
          (element) => element.label == widget.filterModel.propertyTypeOption
      ).first.selected = true;
    }

    if(widget.filterModel.paymentCurrency.isNotEmpty){
      paymentCurrencyOptions.where(
        (element) => element.label == widget.filterModel.paymentCurrency
      ).first.selected = true;
    }

    if(widget.filterModel.leaseDurationOption != 0){
      widget.filterModel.leaseDurationOption == 1 ?
      leaseDuration[0].selected = true :
      widget.filterModel.leaseDurationOption == 7 ?
      leaseDuration[1].selected = true :
      leaseDuration[2].selected = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var listingProvider = Provider.of<ListingProvider>(context);
    NumberInput parkingCapacityInput = NumberInput(
      initialValue: widget.filterModel.parkingCapacity,
      limitValue: 999,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.parkingCapacity = val;
        });
      },
      label: 'Parking capacity',
    );
    NumberInput numberOfFloorsInput = NumberInput(
      initialValue: widget.filterModel.numberOfFloors,
      limitValue: 40,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.numberOfFloors = val;
        });
      },
      label: 'Numbe of floors',
    );
    NumberInput displaysInput = NumberInput(
      initialValue: widget.filterModel.displays,
      limitValue: 10,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.displays = val;
        });
      },
      label: 'Displays',
    );
    NumberInput customerServiceDeskInput = NumberInput(
      initialValue: widget.filterModel.customerServiceDesks,
      limitValue: 10,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.customerServiceDesks = val;
        });
      },
      label: 'Customer service desks',
    );
    NumberInput backRoomInput = NumberInput(
      initialValue: widget.filterModel.backrooms,
      limitValue: 10,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.backrooms = val;
        });
      },
      label: 'Backrooms',
    );
    NumberInput cateringRoomsInput = NumberInput(
      initialValue: widget.filterModel.cateringRooms,
      limitValue: 10,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.cateringRooms = val;
        });
      },
      label: 'Catering rooms',
    );
    NumberInput backStagesInput = NumberInput(
      initialValue: widget.filterModel.backStages,
      limitValue: 5,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.backStages = val;
        });
      },
      label: 'Backstages',
    );
    NumberInput guestCapacityInput = NumberInput(
      initialValue: widget.filterModel.guestCapacity,
      limitValue: 20000,
      changeValue: 50,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.guestCapacity = val;
        });
      },
      label: 'Guest capacity',
    );
    NumberInput ceilingHeightInMetersInput = NumberInput(
      initialValue: widget.filterModel.ceilingHeightInMeters,
      limitValue: 40,
      changeValue: 5,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.ceilingHeightInMeters = val;
        });
      },
      label: 'Height in meter',
    );
    NumberInput loadingDocksInput = NumberInput(
      initialValue: widget.filterModel.loadingDocks,
      limitValue: 100,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.loadingDocks = val;
        });
      },
      label: 'Loading docks',
    );
    NumberInput numberOfKitchensInput = NumberInput(
      initialValue: widget.filterModel.numberOfKitchens,
      limitValue: 10,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.numberOfKitchens = val;
        });
      },
      label: 'Kitchens ',
    );
    NumberInput numberOfBathroomsInput = NumberInput(
      initialValue: widget.filterModel.numberOfBathrooms,
      limitValue: 20,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.numberOfBathrooms = val;
        });
      },
      label: 'Bathrooms',
    );
    NumberInput numberOfBedroomsInput = NumberInput(
      initialValue: widget.filterModel.numberOfBedrooms,
      limitValue: 20,
      changeValue: 1,
      onValueChanged: (val) {
        setState(() {
          widget.filterModel.numberOfBedrooms = val;
        });
      },
      label: 'Bedrooms',
    );

    return Flex(
      direction: Axis.vertical,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  height: 50,
                  width: 50,
                  child: SvgPicture.asset(
                    'assets/icons/fliter.svg',
                    color: MyColors.mainThemeDarkColor,
                    height: 30,
                    width: 3,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  alignment: Alignment.center,
                  child: const
                  Text(
                    "Filters",
                    style: TextStyle(
                        fontSize: 18,
                        color: MyColors.headerFontColor,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const
                  Text(
                    "Listing category",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                    ),
                  ),
                ),
                ChipSelectionInput(
                    options: categories,
                    limit: 1,
                    onSelected: (c){
                      setState(() {
                        categories = c;
                        List<SelectionChip> selectedOptions = c.where((e) => e.selected).toList();
                        widget.filterModel.propertyTypeOption = selectedOptions.isEmpty ? "" :
                        selectedOptions[0].label;
                      });
                    },
                    radius: 10,
                    gap: 8,
                    padding: 14,
                    fontSize: 16,
                    singleSelection: true,
                    lightColor: MyColors.mainThemeLightColor,
                    darkColor:MyColors.mainThemeDarkColor
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const
                  Text(
                    "Sub City",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                    ),
                  ),
                ),
                DropDownButtonForm(
                  allOptions: subCityOptions,
                  initialValue: widget.filterModel.subCityOption.isNotEmpty ? widget.filterModel.subCityOption : subCityOptions[0],
                  hintText: "Select A Sub-city",
                  onChanged: (selected){
                    setState(() {
                      String v = selected ?? "";
                      widget.filterModel.subCityOption = v == "ANY" ? "" : v;
                    });
                  },
                  errorText: null,
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "Lease Duration",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                    ),
                  ),
                ),
                ChipSelectionInput(
                    options: leaseDuration,
                    limit: 1,
                    onSelected: (c){
                      setState(() {
                        List<SelectionChip> selectedOptions = c.where((element) => element.selected).toList();
                        String selectedOption = selectedOptions.isEmpty ? "" : selectedOptions[0].label;
                        widget.filterModel.leaseDurationOption = selectedOption == "Daily" ? 1 :
                        selectedOption == "Weekly" ? 7 :
                        selectedOption == "Monthly" ? 30 : 0;
                      });
                    },
                    radius: 10,
                    gap: 8,
                    padding: 14,
                    fontSize: 16,
                    singleSelection: true,
                    lightColor: MyColors.mainThemeLightColor,
                    darkColor:MyColors.mainThemeDarkColor
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "Currency",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                    ),
                  ),
                ),
                ChipSelectionInput(
                    options: paymentCurrencyOptions,
                    limit: 1,
                    onSelected: (c){
                      setState(() {
                        paymentCurrencyOptions = c;
                        List<SelectionChip> selectedOptions = c.where((e) => e.selected).toList();
                        widget.filterModel.paymentCurrency = selectedOptions.isEmpty ? "" :
                        selectedOptions[0].label;
                      });
                    },
                    radius: 10,
                    gap: 8,
                    padding: 14,
                    fontSize: 16,
                    singleSelection: true,
                    lightColor: MyColors.mainThemeLightColor,
                    darkColor:MyColors.mainThemeDarkColor
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: const Text(
                    "Price Range",
                    style: TextStyle(
                        fontSize: 16,
                        color: MyColors.headerFontColor,
                    ),
                  ),
                ),
                FlutterSlider(
                  values: [widget.filterModel.minimumPrice, widget.filterModel.maximumPrice],
                  rangeSlider: true,
                  max: 150000,
                  min: 1000,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  onDragging: (handlerIndex, lowerValue, upperValue){
                    setState(() {
                      widget.filterModel.minimumPrice = lowerValue;
                      widget.filterModel.maximumPrice = upperValue;
                    });
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration : BoxDecoration(
                            border: const Border.fromBorderSide(
                                BorderSide(
                                    color: MyColors.mainThemeDarkColor,
                                    width: 1,
                                    style: BorderStyle.solid,
                                    strokeAlign: BorderSide.strokeAlignInside
                                )
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('${widget.filterModel.minimumPrice} ${widget.filterModel.paymentCurrency}'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            border: const Border.fromBorderSide(BorderSide(
                                color: MyColors.mainThemeDarkColor,
                                width: 1,
                                style: BorderStyle.solid,
                                strokeAlign: BorderSide.strokeAlignInside
                            )
                            ),
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: Text('${widget.filterModel.maximumPrice} ${widget.filterModel.paymentCurrency}'),
                      ),
                    )
                  ],
                ),
                numberOfFloorsInput,
                parkingCapacityInput,
                ...(
                    widget.filterModel.propertyTypeOption == "COMMERCIAL" ?
                    [
                      displaysInput,
                      customerServiceDeskInput,
                      backRoomInput
                    ] :
                    widget.filterModel.propertyTypeOption == "STORAGE" ?
                    [
                      ceilingHeightInMetersInput,
                      loadingDocksInput
                    ] :
                    widget.filterModel.propertyTypeOption == "EVENT" ?
                    [
                      guestCapacityInput,
                      cateringRoomsInput,
                      backStagesInput
                    ] : [
                      numberOfBedroomsInput,
                      numberOfBathroomsInput,
                      numberOfKitchensInput
                    ]
                ),
                Container(
                  margin:  const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: (){
                            listingProvider.removeFilters();
                            listingProvider.loadListings();
                            Navigator.pop(context);
                          },
                          isLoading: false,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Remove",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
                          insetV: 25,
                          radius: 10,
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: CustomElevatedButton(
                          onPressed: (){
                            listingProvider.loadFilters();
                            Navigator.pop(context);
                          },
                          isLoading: listingProvider.pageLoading,
                          loadingText: "Waiting",
                          loadingTextColor: MyColors.mainThemeDarkColor,
                          buttonText: "Apply",
                          buttonTextBackgroundColor: MyColors.mainThemeDarkColor,
                          buttonTextColor: MyColors.mainThemeLightColor,
                          insetV: 25,
                          radius: 10,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          )
        )
      ],
    );
  }
}