import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stripepayment/hompagecontroller.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  double amount = 20.0;

  final hc = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                hc.paymentSheetInitialization(
                    amount.round().toString(), "USD", context);
              },
              child: Container(
                height: 100,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.amber,
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text("Pay Now USD ${amount.toString()}"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
