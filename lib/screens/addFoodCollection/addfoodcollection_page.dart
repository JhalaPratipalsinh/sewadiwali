import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../block/add_food_collection/add_food_collection_bloc.dart';
import '../../block/home/home_bloc.dart';
import '../../core/color_constants.dart';
import '../../data/model/get_center_pantry_list_model.dart';
import '../../data/model/home_model.dart';
import '../../data/sessionManager/session_manager.dart';
import '../../injection_container.dart';
import '../../util/common_functions.dart';
import '../../util/constants.dart';
import '../../util/my_text_field.dart';
import '../basicWidget/custom_button.dart';
import '../basicWidget/custom_drop_down.dart';
import '../basicWidget/loading_widget.dart';

class AddFoodCollectionPage extends StatefulWidget {
  const AddFoodCollectionPage({super.key});

  @override
  State<AddFoodCollectionPage> createState() => _AddFoodCollectionPageState();
}

class _AddFoodCollectionPageState extends State<AddFoodCollectionPage> {
  Yearlist? selectedyear;
  List<Yearlist> yearList = [];

  Statelist? selectedState;
  List<Statelist> stateList = [];

  String selectedCenter = "";
  String selectedCenterId = "0";
  String selectedPantryId = "";

  // final defaultYear = Yearlist(id: "0", regYear: "Select Year");
  DateTime? selectedMainDate;

  final TextEditingController _date = TextEditingController();
  final TextEditingController _food = TextEditingController();
  final TextEditingController _eventName = TextEditingController();
  final TextEditingController _remarks = TextEditingController();

  static String _displayStringForState(Statelist item) => item.stateName;
  static String _displayStringForCenter(CenterList item) => item.orgName;
  static String _displayStringForPantry(PantryList item) => item.pantryName;
  final loginData = sl<SessionManager>().getUserDetails();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    yearList = context.read<HomeBloc>().yearlist;
    stateList = context.read<HomeBloc>().statelist;
    // yearList.removeWhere((element) => element.id == "0");
    // yearList.insert(0, defaultYear);
    selectedyear = yearList.first;

    if (loginData != null && (loginData?.stateId != "0")) {
      // user is not super admin
      selectedyear = yearList.first;
      context.read<AddFoodCollectionBloc>().add(GetCenterAndPantryListEvent(
          (loginData!.stateId), (selectedyear?.id ?? "0")));
      selectedState =
          stateList.firstWhere((item) => item.id == (loginData!.stateId));
      if (loginData?.useType != "admin") {
        selectedCenterId = loginData?.id ?? "";
      }
    } else if (loginData != null && loginData?.type == "2") {
      // its admin
      selectedyear = yearList.first;
      context.read<AddFoodCollectionBloc>().add(GetCenterAndPantryListEvent(
          (loginData!.stateId), (selectedyear?.id ?? "0")));
      selectedState =
          stateList.firstWhere((item) => item.id == (loginData!.stateId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddFoodCollectionBloc, AddFoodCollectionState>(
      listener: (context, state) {
        if (state is AddFoodCollectionErrorState) {
          showErrorSnackbar(state.message);
        } else if (state is AddFoodCollectionSuccessState) {
          // selectedyear = defaultYear;
          // selectedState = null;
          // selectedCenter = "";
          // selectedCenterId = "";
          // selectedPantryId = "";
          sl<CommonFunctions>().showSnackBar(
              context: context,
              message: state.response.message,
              bgColor: Colors.green,
              textColor: Colors.white);
          Navigator.pop(context, 'refresh');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConstants.appColor,
          iconTheme: const IconThemeData(color: Colors.white),
          title: const Text(
            'Add Collected Food',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomDropDown<Yearlist?>(
                    value: selectedyear,
                    itemsList: yearList,
                    dropdownColor: Colors.white,
                    showDropdown: true,
                    dropDownMenuItems: yearList
                        .map((item) => DropdownMenuItem<Yearlist>(
                              value: item,
                              child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.regYear,
                                    textAlign: TextAlign.left,
                                  )),
                            ))
                        .toList(),
                    onChanged: (Yearlist value) {
                      selectedyear = value;
                      if (selectedState != null) {
                        context.read<AddFoodCollectionBloc>().add(
                            GetCenterAndPantryListEvent((selectedState!.id),
                                (selectedyear?.id ?? "0")));
                      }
                    }),
                SizedBox(
                  height: loginData?.stateId == "0" ? 20 : 0,
                ),
                loginData?.stateId == "0"
                    ? _buildStateField() // user is super admin
                    : const SizedBox(),
                const SizedBox(
                  height: 20,
                ),
                BlocBuilder<AddFoodCollectionBloc, AddFoodCollectionState>(
                  buildWhen: (previous, current) {
                    if (current is GetCenterAndPatryLoadingState ||
                        current is GetCenterAndPatrySuccessState ||
                        current is GetCenterAndPatryErrorState) {
                      return true;
                    }
                    return false;
                  },
                  builder: (context, state) {
                    if (state is GetCenterAndPatryLoadingState) {
                      return const LoadingWidget();
                    } else if (state is GetCenterAndPatrySuccessState) {
                      final pantryList = state.response.pantries ?? [];
                      final centerList = state.response.centers ?? [];
                      print("Pantry List ---- $pantryList");
                      print("User Type = ${loginData?.useType}");
                      return Column(
                        children: [
                          loginData?.useType == "admin"
                              ? _buildCenterField(centerList) // user is admin
                              : const SizedBox(),
                          SizedBox(
                            height: loginData?.useType == "admin" ? 20 : 0,
                          ),
                          _buildPantryField(pantryList),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
                // _buildTextWidget(
                //     _eventName, 'Event Name', TextInputType.name),
                MyTextfield(
                  hint: "Event Name",
                  textEditingController: _eventName,
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                  hint: "Enter event date",
                  textEditingController: _date,
                  readonly: true,
                  ontap: () {
                    selectDate();
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                    hint: "Enter collected food(lbs)",
                    textEditingController: _food,
                    keyboardtype: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                    ]),
                const SizedBox(
                  height: 20,
                ),
                MyTextfield(
                  height: 100,
                  hint: "Remarks",
                  textEditingController: _remarks,
                  maxLine: 3,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 55,
                  child: BlocBuilder<AddFoodCollectionBloc,
                      AddFoodCollectionState>(
                    builder: (context, state) {
                      if (state is AddFoodCollectionLoadingState) {
                        return const LoadingWidget();
                      }
                      return ButtonWidget(
                          buttonText: 'Add food collection',
                          onPressButton: () {
                            //Navigator.of(context).pushNamed(homePage);
                            if (validation()) {
                              context.read<AddFoodCollectionBloc>().add(
                                  AddAddFoodCollectionEvent(
                                      _food.text,
                                      selectedState!.id,
                                      _eventName.text,
                                      _date.text,
                                      selectedCenterId,
                                      selectedCenter,
                                      _remarks.text,
                                      selectedPantryId));
                            }
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void selectDate() async {
    await showDatePicker(
            context: context,
            initialDatePickerMode: DatePickerMode.day,
            initialDate:
                selectedMainDate == null ? DateTime.now() : selectedMainDate!,
            firstDate: DateTime.now().add(const Duration(days: -365)),
            lastDate: DateTime.now())
        .then((newDate) {
      if (newDate != null) {
        selectedMainDate = newDate;
        String formattedDate = dateMMDDYYYYFormat.format(newDate);
        _date.text = formattedDate;
      }
    });
  }

  Widget _buildStateField() {
    return SizedBox(
      height: 50,
      child: Autocomplete<Statelist>(
        displayStringForOption: _displayStringForState,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          textEditingController.text = selectedState?.stateName ?? "";
          return MyTextfield(
            hint: "Search State",
            textEditingController: textEditingController,
            // readonly: (loginData?.useType == "admin" && loginData?.type == "1")
            //     ? false
            //     : true,
            focusNode: focusNode,
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          // if (loginData?.type == "2") {
          //   return const Iterable<Statelist>.empty();
          // }
          return stateList.where((Statelist option) {
            return option.stateName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (Statelist selectedItem) {
          debugPrint('You just selected $selectedItem');
          selectedState = selectedItem;
          if (selectedyear != null) {
            context.read<AddFoodCollectionBloc>().add(
                GetCenterAndPantryListEvent(
                    (selectedState?.id ?? "0"), (selectedyear?.id ?? "0")));
          }

          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildCenterField(List<CenterList> centerList) {
    return SizedBox(
      height: 50,
      child: Autocomplete<CenterList>(
        displayStringForOption: _displayStringForCenter,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          return MyTextfield(
            hint: 'Search Center',
            // readonly: (loginData?.useType == "admin") ? false : true,
            textEditingController: textEditingController,
            focusNode: focusNode,
          );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          print("Center Text ${textEditingValue.text}");
          selectedCenter = textEditingValue.text;
          selectedCenterId = "0";
          return centerList.where((CenterList option) {
            return option.orgName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (CenterList selectedItem) {
          debugPrint('You just selected $selectedItem');
          selectedCenter = selectedItem.orgName;
          selectedCenterId = selectedItem.centerId;
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildPantryField(List<PantryList> pantryList) {
    return SizedBox(
      height: 50,
      child: Autocomplete<PantryList>(
        displayStringForOption: _displayStringForPantry,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          return MyTextfield(
            hint: 'Search Pantry',
            textEditingController: textEditingController,
            focusNode: focusNode,
          );
          // return TextFormField(
          //   controller: textEditingController,
          //   focusNode: focusNode,
          //   decoration: InputDecoration(
          //     border:
          //         OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
          //     labelText: 'Search Pantry',
          //     contentPadding:
          //         EdgeInsets.symmetric(horizontal: 10, vertical: 2.h),
          //   ),
          //   onFieldSubmitted: (String value) {
          //     onFieldSubmitted();
          //   },
          // );
        },
        optionsBuilder: (TextEditingValue textEditingValue) {
          selectedPantryId = "";
          return pantryList.where((PantryList option) {
            return option.pantryName
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
        },
        onSelected: (PantryList selectedItem) {
          debugPrint('You just selected $selectedItem');
          selectedPantryId = selectedItem.pantryId;
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  bool validation() {
    if (selectedyear == null) {
      showErrorSnackbar('Please select year');
      return false;
    } else if (selectedState == null) {
      showErrorSnackbar('Please select state');
      return false;
    } else if (selectedPantryId == "") {
      showErrorSnackbar('Please select Pantry');
      return false;
    } else if (_date.text == "") {
      showErrorSnackbar('Please select event date');
      return false;
    } else if (_food.text == "") {
      showErrorSnackbar('Please enter collected food');
      return false;
    }
    return true;
  }

  void showErrorSnackbar(String msg) {
    sl<CommonFunctions>().showSnackBar(
        context: context,
        message: msg,
        bgColor: ColorConstants.red,
        textColor: Colors.white);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _date.dispose();
    _food.dispose();
    _eventName.dispose();
    _remarks.dispose();
    super.dispose();
  }
}
