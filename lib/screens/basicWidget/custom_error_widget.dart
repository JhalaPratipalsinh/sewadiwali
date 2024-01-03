import 'package:flutter/material.dart';

import '../../core/color_constants.dart';

class CustomErrorWidget extends StatelessWidget {
  Function()? onRetryTap;
  String title;
  CustomErrorWidget({super.key, this.onRetryTap, this.title = "No Data Found"});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 100,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            InkWell(
              onTap: onRetryTap,
              child: const Text(
                "Retry",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: ColorConstants.greyDark),
              ),
            )
          ],
        ),
      ),
    );
  }
}
