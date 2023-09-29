import 'package:flow/components/Button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => WelcomeState();
}

class WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4954FD),
      body: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/logo.png"),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Asset streaming on Base",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Flow - Supercharged by Base & Superfluid🌊",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(children: [
                Button(
                  title: "Import Wallet",
                  onClick: () => Get.toNamed("/importwallet"),
                ),
                const SizedBox(height: 8),
                Button(
                  title: "Create Wallet",
                  backgroundColor: Colors.black87,
                  fontColor: Colors.white,
                  onClick: () => Get.toNamed("/createwallet"),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
