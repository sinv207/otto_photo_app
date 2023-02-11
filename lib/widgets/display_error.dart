import 'package:flutter/material.dart';

SnackBar getSnackBar([String? msg]) => SnackBar(
      content: Text(
        msg ?? '',
        textAlign: TextAlign.center,
      ),
    );
