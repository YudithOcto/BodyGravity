
import 'package:bodygravity/common/extension.dart';
import 'package:flutter/material.dart';

import 'custom_filled_button.dart';
import 'customtextstyle.dart';

class TemplateDialog extends StatefulWidget {
  final String? title;
  final Widget child;
  final String closeButtonTitle;
  final String confirmButtonTitle;
  final bool isConfirmButtonEnabled;
  final bool isConfirmButtonVisible;
  final void Function() onClick;

  const TemplateDialog({
    super.key,
    this.title,
    required this.child,
    this.closeButtonTitle = "Tutup",
    this.confirmButtonTitle = "Tambahkan",
    this.isConfirmButtonEnabled = true,
    this.isConfirmButtonVisible = true,
    required this.onClick,
  });

  @override
  State<TemplateDialog> createState() => _TemplateDialogState();
}

class _TemplateDialogState extends State<TemplateDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      contentPadding: const EdgeInsets.only(bottom: 16.0),
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      insetPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Visibility(
              visible: widget.title.isNotNullOrEmpty,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: const Color(0xFFF3F6F9),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title ?? "",
                      style: CustomTextStyle.body3.copyWith(
                        color: const Color(0xFF495056),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        size: 20.0,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: widget.child)
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: !widget.title.isNotNullOrEmpty,
          child: CustomFilledButton(
            buttonText: widget.closeButtonTitle,
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: const Color(0xFFF3F6F9),
            radius: 8.0,
            intrinsicWidthEnabled: true,
          ),
        ),
        const SizedBox(width: 8.0),
        Visibility(
          visible: widget.isConfirmButtonVisible,
          child: CustomFilledButton(
            buttonText: widget.confirmButtonTitle,
            onPressed: () {
              widget.onClick();
            },
            isEnabled: widget.isConfirmButtonEnabled,
            color: Colors.teal,
            intrinsicWidthEnabled: true,
            radius: 8.0,
            textStyle: CustomTextStyle.body3,
          ),
        )
      ],
    );
  }
}

// class DeleteDataDialog extends StatelessWidget {
//   final void Function() onRemoveClick;
//   final String title;
//   final String subtitle;
//   const DeleteDataDialog({
//     super.key,
//     required this.title,
//     required this.subtitle,
//     required this.onRemoveClick,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       contentPadding: const EdgeInsets.all(0.0),
//       backgroundColor: AppColors.whiteColor,
//       content: Container(
//         padding: EdgeInsets.only(
//             top: 24.0,
//             bottom: 16.0,
//             left: Get.width * 0.02,
//             right: Get.width * 0.01),
//         decoration: BoxDecoration(
//           color: AppColors.whiteColor,
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.start,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   width: 36.0,
//                   height: 36.0,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     color: AppColors.primaryRed100,
//                   ),
//                   padding: const EdgeInsets.all(4.0),
//                   child: const Icon(
//                     Icons.warning_rounded,
//                     color: AppColors.primaryRed300,
//                     size: 20.0,
//                   ),
//                 ),
//                 const SizedBox(width: 12.0),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: CustomTextStyle.label,
//                       ),
//                       const SizedBox(height: 4.0),
//                       Text(subtitle,
//                           style: CustomTextStyle.label.copyWith(
//                             color: Colors.black38,
//                           ))
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 36.0),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 CustomOutlineButton(
//                     text: "Batalkan",
//                     onPressed: () {
//                       Get.back();
//                     }),
//                 const SizedBox(width: 8.0),
//                 CustomFilledButton(
//                     radius: Constants.dashboardCardRadius,
//                     buttonText: "Hapus",
//                     intrinsicWidthEnabled: true,
//                     textStyle: CustomTextStyle.buttonLabel.copyWith(
//                       color: AppColors.whiteColor,
//                     ),
//                     onPressed: onRemoveClick,
//                     color: AppColors.primaryRed500),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
