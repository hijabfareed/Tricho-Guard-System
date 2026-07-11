import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../constants/app_color.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final double? width;
  final double? height;
  final String? labelText;
  final Color? fillColor;
  final Color? borderColor;
  final Color? hintTextColor;
  final bool isTextHidden;
  final String? hintText;
  final IconData? buttonIcon;
  final Widget? prefixIcon;
  final bool? togglePassword;
  final int? maxLines;
  final TextAlign? textAlign;
  final int? maxLength;
  final Function()? toggleFunction;
  final IconData? toggleIcon;
  final TextInputType? keyboardType;
  final bool readOnly;
  final Function()? onTap;
  final Function()? prefixIconTap;
  final Function(String)? onChanged;
  final Function(String)? onStopTyping;
  final Function()? onPaste;
  final List<TextInputFormatter>? inputFormatters;
  final FocusNode? focus;
  final TextInputAction? textInputAction;
  final Widget? suffixIcon;
  final double? radius;
  final changeObscureStatus;
  final void Function(String)? onFieldSubmitted;
  final TextStyle? labelStyle;
  final bool showBorder;
  final bool isUnderLineBorder;
  final TextStyle? hintStyle;
  final TextStyle? style;
  final bool enabled;
  final EdgeInsets? contentPadding;
  final double fontSize;

  CommonTextField({
    super.key,
    this.controller,
    this.width,
    this.height,
    this.contentPadding,
    this.validator,
    this.radius,
    this.borderColor,
    this.hintTextColor,
    this.labelText,
    this.fillColor,
    this.maxLines = 1,
    this.hintText,
    this.textAlign,
    this.isTextHidden = false,
    this.buttonIcon,
    this.prefixIcon,
    this.onChanged,
    this.onStopTyping,
    this.togglePassword = false,
    this.enabled = true,
    this.toggleFunction,
    this.toggleIcon,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.prefixIconTap,
    this.changeObscureStatus,
    this.focus,
    this.suffixIcon,
    this.onFieldSubmitted,
    this.maxLength,
    this.labelStyle,
    this.showBorder = true,
    this.isUnderLineBorder = false,
    this.hintStyle,
    this.style,
    this.onPaste,
    this.fontSize = 14.0,
  });

  final Debouncer _debouncer = Debouncer(milliseconds: 500);

  @override
  Widget build(BuildContext context) {
    TextStyle errorTextStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
          fontWeight: FontWeight.w500,
          color: AppColors.primaryRed,
        );
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
          return AdaptiveTextSelectionToolbar.editable(
            onLiveTextInput: () {},
            onLookUp: () {},
            onSearchWeb: () {},
            onShare: () {},
            anchors: editableTextState.contextMenuAnchors,
            clipboardStatus: ClipboardStatus.pasteable,
            // to apply the normal behavior when click on copy (copy in clipboard close toolbar)
            // use an empty function `() {}` to hide this option from the toolbar
            onCopy: () => editableTextState.copySelection(SelectionChangedCause.toolbar),
            // to apply the normal behavior when click on cut
            onCut: () => editableTextState.cutSelection(SelectionChangedCause.toolbar),
            onPaste: () {
              onPaste?.call() ?? editableTextState.pasteText(SelectionChangedCause.toolbar);
            },
            // to apply the normal behavior when click on select all
            onSelectAll: () => editableTextState.selectAll(SelectionChangedCause.toolbar),
          );
        },
        maxLines: maxLines,
        textAlign: textAlign ?? TextAlign.left,
        cursorColor: AppColors.primaryColorBlack,
        textAlignVertical: TextAlignVertical.center,
        onChanged: onStopTyping != null
            ? (string) {
                _debouncer.run(() {
                  onStopTyping?.call(string);
                  //perform search here
                });
              }
            : onChanged,
        inputFormatters: inputFormatters,
        obscureText: isTextHidden,
        onFieldSubmitted: onFieldSubmitted,
        readOnly: readOnly,
        onTap: onTap,
        maxLength: maxLength,
        enabled: enabled,
        focusNode: focus,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        decoration: InputDecoration(
          errorMaxLines: 10,
          counterText: '',
          contentPadding: contentPadding,
          prefixIcon: prefixIcon,
          prefixIconConstraints: const BoxConstraints(),
          suffixIcon: togglePassword!
              ? GestureDetector(
                  onTap: toggleFunction,
                  child: Icon(
                    toggleIcon,
                  ))
              : suffixIcon,
          enabledBorder: showBorder
              ? isUnderLineBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4),
                      ),
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4)),
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius ?? 15.0),
                      ),
                    )
              : InputBorder.none,
          focusedBorder: showBorder
              ? isUnderLineBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4),
                      ),
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(radius ?? 15.0),
                      ),
                    )
              : InputBorder.none,
          hintText: hintText,
          fillColor: fillColor ?? AppColors.primaryColorWhite,
          filled: true,
          hintStyle: hintStyle ??
              TextStyle(
                    color: hintTextColor ?? AppColors.lightGray,
                    fontWeight: FontWeight.w400,
                    fontSize: fontSize,
                  ),
          labelText: labelText,
          labelStyle: labelStyle ??
              TextStyle(
                    color: AppColors.lightGray,
                    fontWeight: FontWeight.w400,
                fontSize: fontSize,
                  ),
          errorStyle: errorTextStyle,
          errorBorder: showBorder
              ? isUnderLineBorder
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.primaryRed,
                      ),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.primaryRed,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 15.0)),
                    )
              : InputBorder.none,
          focusedErrorBorder: showBorder
              ? isUnderLineBorder
                  ? const UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: AppColors.gray,
                      ),
                    )
                  : OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColors.gray,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 15.0)),
                    )
              : InputBorder.none,
          border: showBorder
              ? isUnderLineBorder
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4),
                      ),
                    )
                  : OutlineInputBorder(
                      borderSide: BorderSide(
                        color: borderColor ?? AppColors.lightGray.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(radius ?? 15.0)),
                    )
              : InputBorder.none,
        ),
        style: style ?? TextStyle(
          fontSize: fontSize,
        ),
        controller: controller,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

class Debouncer {
  final int milliseconds;

  Timer? _timer;

  Debouncer({this.milliseconds = 200});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
