import 'dart:convert';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flow/api/ftmscan.dart';
import 'package:flow/components/stream_modal.dart';
import 'package:flow/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:random_avatar/random_avatar.dart';

import '../components/add_contact_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String address = GetStorage().read("address");
  String balance = "0";
  List contacts = [];
  List transactions = [];
  List<Map> streamingTokens = [];

  Future<void> gB() async {
    // String b = await getBalance(address);
    // if (!mounted) return;
    // setState(() {
    //   balance = b;
    // });
  }

  void gC() {
    String? c = GetStorage().read("contacts");
    if (c == null || c == "") c = jsonEncode({'contacts': []});
    Map pC = jsonDecode(c);
    if (!mounted) return;
    setState(() {
      contacts = pC["contacts"];
    });
  }

  Future<void> gT() async {
    var t = await getTransactionsByAccount(address);
    if (!mounted) return;
    setState(() {
      transactions = t;
    });
  }

  Future<void> addContact() async {
    await showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        context: context,
        builder: (_) {
          return const AddContactModal();
        });
    gC();
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gB();
    gC();
    gT();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF1FAEE),
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        color: Colors.white,
        onRefresh: () async {
          gC();
          await gT();
          await gB();
          return;
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0, left: 12, right: 12),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    // Navbar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                                backgroundImage:
                                    AssetImage("assets/profile.png"),
                                radius: 30),
                            SizedBox(width: 16),
                            Text(
                              "Dashboard",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 24,
                                  color: Colors.black),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/settings"),
                          child: CircleAvatar(
                            backgroundColor:
                                const Color.fromARGB(255, 47, 47, 47),
                            radius: 28,
                            child: Center(
                              child: Image.asset(
                                "assets/settings.png",
                                height: 28,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    // Balance Tile
                    Container(
                      margin: const EdgeInsets.only(top: 32),
                      height: (MediaQuery.of(context).size.height / 100) * 22.5,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        color: primaryColor,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Your Balance",
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white70),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "$balance ETH",
                                    style: const TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(
                                    "assets/base-logo.png",
                                    height: 28,
                                    color: Colors.white,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Clipboard.setData(
                                          ClipboardData(text: address));
                                      Get.snackbar("Copied!",
                                          "Address copied to clipboard.",
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: primaryColor);
                                    },
                                    child: Text(
                                      "${address.substring(0, 6)} **** **** ${address.substring(38, 42)}",
                                      style: const TextStyle(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ]),
                    ),
                    const SizedBox(height: 24),
                    // Actions
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xff151515),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/send"),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: Color(0xffF1FAEE),
                                    child: Icon(
                                      Icons.arrow_outward_sharp,
                                      size: 26,
                                      color: Colors.black,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Text(
                                    "Send",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 32),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: const Color(0xff151515),
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(33, 27, 27, 27))),
                            padding: const EdgeInsets.all(12),
                            child: GestureDetector(
                              onTap: () => Get.toNamed("/recieve"),
                              child: const Row(
                                children: [
                                  CircleAvatar(
                                      radius: 22,
                                      backgroundColor: Color(0xffF1FAEE),
                                      child: RotatedBox(
                                        quarterTurns: 2,
                                        child: Icon(
                                          Icons.arrow_outward_sharp,
                                          size: 26,
                                          color: Colors.black,
                                        ),
                                      )),
                                  SizedBox(width: 12),
                                  Text(
                                    "Request",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Quick Send
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quick Send",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.black),
                        ),
                        GestureDetector(
                          onTap: () => addContact(),
                          child: const Text(
                            "Add new",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 110,
                      alignment: Alignment.centerLeft,
                      margin: const EdgeInsets.only(top: 8),
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: contacts.length + 1,
                        itemBuilder: (_, ind) {
                          return Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: GestureDetector(
                              onTap: () {
                                if (ind == contacts.length) {
                                  addContact();
                                } else {
                                  Get.toNamed("/send",
                                      arguments: contacts[ind]['address']);
                                }
                              },
                              child: Column(
                                children: [
                                  (ind == contacts.length
                                      ? const CircleAvatar(
                                          radius: 40,
                                          backgroundColor: Color.fromARGB(
                                              255, 164, 164, 164),
                                          child: Center(
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: 32,
                                            ),
                                          ),
                                        )
                                      : RandomAvatar(contacts[ind]['address'],
                                          height: 80, width: 80)),
                                  const SizedBox(height: 8),
                                  Text(
                                    ind == contacts.length
                                        ? "Add contact"
                                        : contacts[ind]['name'],
                                    style: const TextStyle(color: Colors.black),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Recent Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Your flows🌊",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Get.toNamed("/list"),
                          child: const Text(
                            "Create stream",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(32),
                          ),
                        ),
                        child: streamingTokens.isEmpty
                            ? const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage("assets/empty-list.png"),
                                      height: 60,
                                    ),
                                    SizedBox(height: 8),
                                    Text("You have zero streaming services...",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xffC5C5C5))),
                                  ],
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: streamingTokens.length,
                                itemBuilder: (_, ind) {
                                  return GestureDetector(
                                    onTap: () async {
                                      await showModalBottomSheet(
                                          shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ),
                                          context: context,
                                          builder: (_) {
                                            return StreamModal(
                                                token: streamingTokens[ind]);
                                          });
                                      gB();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 48, 48, 48),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                streamingTokens[ind]['image']),
                                            backgroundColor: Colors.white,
                                          ),
                                          title: Text(
                                            "${streamingTokens[ind]['symbol']}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                          subtitle: Text(
                                            "${streamingTokens[ind]['name']}",
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ),
                                          trailing: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              AnimatedFlipCounter(
                                                duration:
                                                    const Duration(seconds: 1),
                                                value: streamingTokens[ind]
                                                    ['balance'],
                                                fractionDigits: 9,
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                (streamingTokens[ind][
                                                                'currentFlowRate'] *
                                                            31 *
                                                            24 *
                                                            60 *
                                                            60)
                                                        .toStringAsFixed(2) +
                                                    "/mo",
                                                style: TextStyle(
                                                    color: streamingTokens[ind][
                                                                'currentFlowRate'] <
                                                            0
                                                        ? Colors.red
                                                        : Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
