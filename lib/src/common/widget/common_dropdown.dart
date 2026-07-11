
import 'package:al_hair_app/src/common/extension/widget_extension.dart';
import 'package:al_hair_app/src/common/widget/common_text_field.dart';
import 'package:al_hair_app/src/constants/app_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CommonDropDownField extends StatefulWidget {
  final TextEditingController controller;
  final String placeholder;
  final String? hintText;
  final List values;
  final TextEditingController checkedValue;
  final String listMapName;
  final String listMapId;
  final bool readOnly;
  final bool isIconShow;
  final Function? doCallback;
  final Color borderColor;
  final Color? fillColor;
  final Widget? prefixIcon;
  final bool isUnderlineBorder;
  final bool isBorderShow;
  final double? width;
  final double height;
  final double? fontSize;
  final double borderRadius;

  const CommonDropDownField({
    super.key,
    required this.controller,
    required this.placeholder,
    required this.values,
    this.hintText,
    required this.checkedValue,
    this.listMapName = 'name',
    this.listMapId = 'id',
    this.prefixIcon,
    this.borderColor = AppColors.lightGrey,
    this.fillColor,
    this.width,
    this.fontSize,
    this.readOnly = false,
    this.isIconShow = true,
    this.doCallback,
    this.isUnderlineBorder = false,
    this.isBorderShow = true,
    this.borderRadius = 30.0,
    this.height = 30.0,
  });

  @override
  State<CommonDropDownField> createState() => _CommonDropDownFieldState();
}

class _CommonDropDownFieldState extends State<CommonDropDownField> {
  late String? selectedValue;

  @override
  void initState() {
    super.initState();
    final listOfIds = widget.values
        .map((e) => e[widget.listMapId].toString())
        .toList();

    final checked = widget.checkedValue.text;

    if (listOfIds.where((id) => id == checked).length == 1) {
      selectedValue = checked;
    } else if (listOfIds.isNotEmpty) {
      selectedValue = listOfIds[0];
    } else {
      selectedValue = null;
    }
  }

  @override
  Widget build(BuildContext context) {

    final validIds = widget.values.map((e) => e[widget.listMapId].toString()).toList();
    if (!validIds.contains(selectedValue)) {
      selectedValue = null; // prevent crash
    }


    TextEditingController terminalName = TextEditingController();

    if (widget.readOnly) {
      for (var list in widget.values) {
        if (widget.checkedValue.text == list[widget.listMapId].toString()) {
          terminalName.text = list[widget.listMapName];
        }
      }
    }

    if (widget.readOnly) {
      return CommonTextField(
        controller: terminalName,
        readOnly: true,
        labelText: widget.placeholder,
      );
    }

    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height,
      child: InputDecorator(
        baseStyle: const TextStyle(fontSize: 10 , color: AppColors.primaryColorWhite),
        decoration: InputDecoration(
          labelText: widget.placeholder,
          fillColor: widget.fillColor ?? AppColors.transparentColor,
          filled: true,
          focusColor: Colors.black,
          hoverColor: Colors.black,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 9,
            fontWeight: FontWeight.w400,
            fontFamily: 'Roboto',
          ),
          enabledBorder: widget.isBorderShow
              ? widget.isUnderlineBorder
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
          )
              : OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          )
              : InputBorder.none,
          focusedBorder: widget.isBorderShow
              ? widget.isUnderlineBorder
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
          )
              : OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius: BorderRadius.circular(widget.borderRadius),
          )
              : InputBorder.none,
          border: widget.isBorderShow
              ? widget.isUnderlineBorder
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius)),
          )
              : OutlineInputBorder(
            borderSide: BorderSide(color: widget.borderColor),
            borderRadius:
            BorderRadius.all(Radius.circular(widget.borderRadius)),
          )
              : InputBorder.none,
          prefixIcon: widget.prefixIcon,
          labelStyle: const TextStyle(
            color: Color(0xffB7BCCA),
            fontSize: 10.0,
          ),

        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: widget.isIconShow
                ? const Icon(
              Icons.arrow_drop_down_sharp,
              size: 15.0,
              color: Color(0xffB2B2B2),
            )
                : 0.0.spaceH,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w400,
              color: AppColors.primaryColorWhite,
            ),
            value: selectedValue,
            isDense: true,
            isExpanded: true,
            dropdownColor: AppColors.primaryColorBlack,
            items: widget.values.map((list) {
              final id = list[widget.listMapId].toString();
              final name = list[widget.listMapName];

              return DropdownMenuItem<String>(
                value: id,
                child: Text(
                  name != '' ? name : 'not found',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: widget.fontSize,
                    color: AppColors.primaryColorWhite,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              if (kDebugMode) {
                print('Dropdown value Selected: $value');
              }
              setState(() {
                selectedValue = value;
                widget.controller.text = value!;
              });
              if (widget.doCallback != null) {
                widget.doCallback!();
              } else {
                if (kDebugMode) {
                  print('no callback');
                }
              }
            },
          ),
        ),
      ),
    );
  }
}
