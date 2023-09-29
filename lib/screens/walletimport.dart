import 'package:flow/themes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import "../components/button.dart";
import 'package:web3dart/credentials.dart';

class WalletImport extends StatefulWidget {
  const WalletImport({super.key});

  @override
  State<WalletImport> createState() => _WalletImportState();
}

class _WalletImportState extends State<WalletImport> {
  String pK = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Import Wallet",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 28),
                  const Text(
                    "Enter private key",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Enter your private key in the below input box.",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 28),
                  TextField(
                    autocorrect: false,
                    minLines: 10,
                    maxLines: 10,
                    onChanged: (String v) {
                      setState(() {
                        pK = v;
                      });
                    },
                    style: const TextStyle(
                      color: Colors.black,
                    ),
                  )
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Button(
                      title: "Import Wallet",
                      backgroundColor: Colors.black,
                      fontColor: Colors.white,
                      onClick: () {
                        if (pK == "" || !(pK.length == 64 || pK.length == 66)) {
                          return Get.snackbar("Invalid private key!",
                              "Please enter a valid private key!",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: primaryColor);
                        }
                        Credentials credentials = EthPrivateKey.fromHex(pK);
                        GetStorage().write("privateKey", pK);
                        GetStorage()
                            .write("address", credentials.address.toString());
                        Get.toNamed("/home");
                      },
                    ),
                  ],
                ),
              )
            ],
          )),
    );
  }
}
