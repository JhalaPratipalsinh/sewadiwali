import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sewadiwali/block/add_gallery/add_gallery_bloc.dart';
import 'package:sewadiwali/util/custom_image.dart';
import 'package:sewadiwali/util/image_resources.dart';
import 'package:sewadiwali/util/my_text_field.dart';

import '../../block/home/home_bloc.dart';
import '../../core/color_constants.dart';
import '../../data/model/home_model.dart';
import '../../data/sessionManager/session_manager.dart';
import '../../injection_container.dart';
import '../../util/alert/alert_helper.dart';
import '../../util/common_functions.dart';
import '../../util/constants.dart';
import '../../util/image_picker_service.dart';
import '../basicWidget/custom_button.dart';
import '../basicWidget/loading_widget.dart';

class AddGalleryScreen extends StatefulWidget {
  const AddGalleryScreen({super.key});

  @override
  State<AddGalleryScreen> createState() => _AddGalleryStateScreen();
}

class _AddGalleryStateScreen extends State<AddGalleryScreen> {
  Statelist? selectedState;
  List<Statelist> stateList = [];

  DateTime? selectedMainDate;

  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();

  bool isCoverImageSelected = false;

  File? _selectedCoverImage;
  List<File> galleryImageList = [];

  ImagePickerService? imagePicker;

  static String _displayStringForState(Statelist item) => item.stateName;
  final loginData = sl<SessionManager>().getUserDetails();

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    imagePicker = ImagePickerService(context: context);
    stateList = context.read<HomeBloc>().statelist;
    print("My State List --- $stateList");
    if (loginData != null && loginData?.stateId != "0") {
      // user is not super admin
      selectedState =
          stateList.firstWhere((item) => item.id == (loginData!.stateId));
    } else {
      context.read<HomeBloc>().add(const GetStateListEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is HomeErrorState) {
          showErrorSnackbar(state.message);
        } else if (state is HomeSuccessState) {
          stateList = state.response.statelist ?? [];
        }
      },
      child: BlocListener<AddGalleryBloc, AddGalleryState>(
        listener: (context, state) {
          if (state is AddGalleryErrorState) {
            showErrorSnackbar(state.message);
          } else if (state is AddGallerySuccessState) {
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
              'Upload Photos',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // _buildTextWidget(_name, 'Name', TextInputType.name),
                      MyTextfield(hint: "Name", textEditingController: _name),
                      const SizedBox(
                        height: 20,
                      ),

                      BlocBuilder<HomeBloc, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoadingState) {
                            return const LoadingWidget();
                          } else if (state is HomeSuccessState) {
                            stateList = state.response.statelist ?? [];
                            return loginData == null
                                ? _buildStateField()
                                : loginData?.stateId == "0"
                                    ? _buildStateField()
                                    : const SizedBox();
                          } else {
                            return const SizedBox();
                          }
                        },
                      ),
                      SizedBox(
                        height: loginData == null
                            ? 20
                            : (loginData?.stateId == "0")
                                ? 20
                                : 0,
                      ),
                      MyTextfield(
                        hint: "Gallery date",
                        textEditingController: _date,
                        readonly: true,
                        ontap: () {
                          selectDate();
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Select Cover Image : ",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 100,
                        width: 100,
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(color: ColorConstants.greyDark),
                        ),
                        child: InkWell(
                          onTap: () {
                            AlertHelper.getInstance()!.showImagePickerAlert(
                              context: context,
                              onPressed: (isCamera) {
                                // imagePicker?.pickAndCropImage(fromCamera: isCamera);
                                openImagePicker(isCamera: isCamera);
                              },
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: CustomImage(
                              height: _selectedCoverImage == null
                                  ? 40
                                  : double.infinity,
                              width: _selectedCoverImage == null
                                  ? 40
                                  : double.infinity,
                              imgURL: _selectedCoverImage == null
                                  ? ImageResources.icCamera
                                  : (_selectedCoverImage?.path ?? ""),
                              imgColor: _selectedCoverImage == null
                                  ? ColorConstants.appColor
                                  : null,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Select Gallery Images (8) : ",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 120,
                        clipBehavior: Clip.hardEdge,
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                            // borderRadius: BorderRadius.circular(5),
                            // border: Border.all(color: ColorConstants.greyDark),
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                if (galleryImageList.length >= 8) {
                                  showErrorSnackbar('Maximum images selected');
                                } else {
                                  AlertHelper.getInstance()!
                                      .showImagePickerAlert(
                                    context: context,
                                    onPressed: (isCamera) {
                                      // imagePicker?.pickAndCropImage(fromCamera: isCamera);
                                      openImagePickerForGallery(
                                          isCamera: isCamera);
                                    },
                                  );
                                }
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: ColorConstants.appColor),
                                child: const Icon(
                                  Icons.add,
                                  size: 50,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return Stack(
                                      children: [
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: ColorConstants.greyDark),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: CustomImage(
                                              imgURL:
                                                  galleryImageList[index].path,
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 0,
                                          child: InkWell(
                                            child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 20,
                                                  color:
                                                      ColorConstants.appColor,
                                                )),
                                            onTap: () {
                                              setState(() {
                                                galleryImageList
                                                    .removeAt(index);
                                              });
                                            },
                                          ),
                                        ),
                                        // Positioned(
                                        //     child: InkWell(
                                        //   onTap: () {},
                                        //   child: const CustomImage(
                                        //     imgURL: ImageResources.icCamera,
                                        //     height: 20,
                                        //   ),
                                        // ))
                                      ],
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(
                                      width: 10,
                                    );
                                  },
                                  itemCount: galleryImageList.length),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: 55,
                        child: BlocBuilder<AddGalleryBloc, AddGalleryState>(
                          builder: (context, state) {
                            if (state is AddGalleryLoadingState) {
                              return const LoadingWidget();
                            }
                            return ButtonWidget(
                                buttonText: 'Add Gallery',
                                onPressButton: () {
                                  if (validation()) {
                                    final parameter = {
                                      'name': _name.text,
                                      'state_id': selectedState!.id,
                                      'gallery_date': _date.text,
                                      'description': '',
                                      "usertype": loginData?.useType,
                                    };
                                    final List<Map<String, File>> imageFiles = [
                                      {'image': _selectedCoverImage!}
                                    ];

                                    for (var i = 0;
                                        i < galleryImageList.length;
                                        i++) {
                                      imageFiles.add({
                                        'images${i + 1}': galleryImageList[i]
                                      });
                                    }
                                    context.read<AddGalleryBloc>().add(
                                        AddAddGalleryEvent(
                                            parameter, imageFiles));
                                  }
                                });
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
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
      lastDate: DateTime.now(),
    ).then((newDate) {
      if (newDate != null) {
        selectedMainDate = newDate;
        String formattedDate = dateMMDDYYYYFormat.format(newDate);
        _date.text = formattedDate;
      }
    });
  }

  Widget _buildStateField() {
    return SizedBox(
      // margin: const EdgeInsets.symmetric(horizontal: 10),
      height: 50,
      child: Autocomplete<Statelist>(
        displayStringForOption: _displayStringForState,
        fieldViewBuilder:
            (context, textEditingController, focusNode, onFieldSubmitted) {
          textEditingController.text = selectedState?.stateName ?? "";
          return MyTextfield(
            hint: 'Search State',
            textEditingController: textEditingController,
            // readonly: loginData?.type == "2" ? true : false,
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
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  bool validation() {
    if (_name.text == "") {
      showErrorSnackbar('Please enter name');
      return false;
    } else if (selectedState == null) {
      showErrorSnackbar('Please select state');
      return false;
    } else if (_date.text == "") {
      showErrorSnackbar('Please select gallery date');
      return false;
    } else if (isCoverImageSelected == false) {
      showErrorSnackbar('Please select cover image');
      return false;
    } else if (galleryImageList.isEmpty) {
      showErrorSnackbar('Please select atleast one gallery image');
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

  void openImagePicker({bool isCamera = false}) async {
    _selectedCoverImage =
        await imagePicker?.pickAndCropImage(fromCamera: isCamera);
    if (_selectedCoverImage != null) {
      final fileSize = _selectedCoverImage!.getFileSizeInMB();
      print("File Size -- $fileSize");
      if (fileSize > 5) {
        showErrorSnackbar('File size must less than 5 MB');
        setState(() {
          _selectedCoverImage = null;
          isCoverImageSelected = false;
        });
      } else {
        setState(() {
          isCoverImageSelected = true;
        });
      }
    }
  }

  void openImagePickerForGallery({bool isCamera = false}) async {
    final selectedImage =
        await imagePicker?.pickAndCropImage(fromCamera: isCamera);
    if (selectedImage != null) {
      final fileSize = selectedImage.getFileSizeInMB();
      print("File Size -- $fileSize");
      if (fileSize > 5) {
        showErrorSnackbar('File size must less than 5 MB');
      } else {
        setState(() {
          // galleryImageList.add(selectedImage);
          galleryImageList.insert(0, selectedImage);
        });
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _date.dispose();
    _name.dispose();
    super.dispose();
  }
}
