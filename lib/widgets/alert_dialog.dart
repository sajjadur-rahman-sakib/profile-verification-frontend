import 'package:flutter/material.dart';
import 'package:verify/utils/app_colors.dart';

void showAlertDialog(BuildContext context, title, content) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          title,
          style: const TextStyle(color: AppColors.primaryColor),
        ),
        content: Text(
          content,
          style: const TextStyle(color: AppColors.textColor),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.textColor),
            ),
          ),
        ],
      );
    },
  );
}
