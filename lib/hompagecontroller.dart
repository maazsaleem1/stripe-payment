// ignore_for_file: avoid_print

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stripepayment/keys.dart';

class HomePageController extends GetxController {
  double amount = 20.0;

  Map<String, dynamic>? intentPaymentData;

  Future<void> showPaymentSheet(
    context,
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet().then(
        (value) {
          intentPaymentData = null;
        },
      ).onError(
        (error, stackTrace) {
          print(error.toString());
        },
      );

      print("Showing payment sheet...");
    } on StripeException catch (error) {
      if (kDebugMode) {
        print("Stripe Exception: ${error.toString()}");
      }
      showDialog(
        context: context,
        builder: (c) {
          return const AlertDialog(
            content: Text("Payment was cancelled."),
          );
        },
      );
    } catch (errorMsg) {
      if (kDebugMode) {
        print("General Error: $errorMsg");
      }
    }
  }

  paymentSheetInitialization(amountToBeCharge, currency, context) async {
    try {
      intentPaymentData =
          await makeIntentForPayment(amountToBeCharge, currency);
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
            allowsDelayedPaymentMethods: true,
            paymentIntentClientSecret: intentPaymentData!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: "comapny name example",
          ))
          .then((value) => print(value));
      showPaymentSheet(context);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg.toString());
      }
    }
  }

  makeIntentForPayment(amountToBeCharge, currency) async {
    try {
      Map<String, dynamic>? paymentInfo = {
        "amount": (double.parse(amountToBeCharge) * 100).toInt().toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };
      var responseFromStripeApi = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: paymentInfo,
          headers: {
            "Authorization": "Bearer $Secretkey",
            "Content-Type": "application/x-www-form-urlencoded",
          });
      print("response from api =${responseFromStripeApi.body}");
      return jsonDecode(responseFromStripeApi.body);
    } catch (errorMsg) {
      if (kDebugMode) {
        print(errorMsg.toString());
      }
    }
  }
}
