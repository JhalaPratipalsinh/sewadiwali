import 'package:flutter/material.dart';

import '../../splash_page.dart';

class GridBoxWidget extends StatelessWidget {
  GridData data;
  GridBoxWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: data.onPressed,
      child: Card(
        elevation: 3,
        color: data.backgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(data.icon, size: 40, color: Colors.white),
              const SizedBox(
                height: 5,
              ),
              Text(data.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }
}
