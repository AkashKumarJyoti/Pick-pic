import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message, IconData icon, BuildContext context) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: const Color(0xFF66BB6A)),
          const SizedBox(
            width: 12.0,
          ),
          Text(
            message,
            style: const TextStyle(
              color: Color(0xFF66BB6A),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
    FToast().showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );
  }

