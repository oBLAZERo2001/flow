import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flow/api/tokens.dart';
import 'package:flow/components/token_actions.dart';
import 'package:flow/themes.dart';
import 'package:flow/utils/token.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web3dart/web3dart.dart';

class TokenScreen extends StatefulWidget {
  const TokenScreen({super.key});

  @override
  State<TokenScreen> createState() => _TokenScreenState();
}

class _TokenScreenState extends State<TokenScreen> {
  String address = GetStorage().read("address");
  String balance = "0";
  late Timer timer;
  late Timer streamTimer;

  List<Map> streamingTokens = [];
  List<Map> addressList = [
    {
      "name": "Super USDC",
      "symbol": "USDCx",
      "address": "0xd04383398dd2426297da660f9cca3d439af9ce1b",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/celo_logo.png",
    },
    {
      "name": "Super Dai Stablecoin",
      "symbol": "DAIx",
      "address": "0x708169c8c87563ce904e0a7f3bfc1f3b0b767f41",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/cusd.png",
    },
    {
      "name": "Super USD Base Coin",
      "symbol": "USDbCx",
      "address": "0x4db26c973fae52f43bd96a8776c2bf1b0dc29556",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/cusd.png",
    },
    {
      "name": "Super ETH",
      "symbol": "ETHx",
      "address": "0x46fd5cfb4c12d87acd3a13e92baa53240c661d93",
      "balance": 0,
      "currentFlowRate": 0,
      "image": "assets/cusd.png",
    },
  ];

  String getImage(String address) {
    switch (address) {
      case "0x42bb40bf79730451b11f6de1cba222f17b87afd7":
        return "assets/cusd.png";
      default:
        return "assets/celo_logo.png";
    }
  }

  void startTokenTimer() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        for (var i = 0; i < addressList.length; i++) {
          setState(() {
            addressList[i]['balance'] += addressList[i]['currentFlowRate'];
          });
        }
      },
    );
  }

  void startStreamTimer() {
    streamTimer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) async {
        for (var i = 0; i < streamingTokens.length; i++) {
          setState(() {
            streamingTokens[i]['balance'] +=
                streamingTokens[i]['currentFlowRate'];
          });
        }
      },
    );
  }

  Future<void> gT() async {
    List b = await getTokens(address);
    if (!mounted) return;

    // Zero currentFlowRate
    for (var i = 0; i < addressList.length; i++) {
      addressList[i]['currentFlowRate'] = 0;
    }

    for (var i = 0; i < b.length; i++) {
      setState(() {
        final token = addressList
            .firstWhereOrNull((e) => e['address'] == b[i]['token']['id']);
        if (token == null) return;
        token['currentFlowRate'] = EtherAmount.inWei(
                BigInt.from(double.parse(b[i]['totalNetFlowRate'])))
            .getValueInUnit(EtherUnit.ether);
      });
    }
    startTokenTimer();
  }

  Future<void> gST() async {
    List a = await getRecieverStreamingTokens(address);
    List b = await getSenderStreamingTokens(address);
    a = a.map<dynamic>((e) {
      e['currentFlowRate'] = '-${e['currentFlowRate']}';
      return e;
    }).toList();
    b.addAll(a);
    if (!mounted) return;

    streamingTokens = [];
    for (var i = 0; i < b.length; i++) {
      final token = b[i]['token'];
      token['currentFlowRate'] =
          EtherAmount.inWei(BigInt.from(double.parse(b[i]['currentFlowRate'])))
              .getValueInUnit(EtherUnit.ether);
      token['image'] = getImage(token['id']);
      token['receiver'] = b[i]['receiver']['id'];
      token['sender'] = b[i]['sender']['id'];
      final bT =
          addressList.firstWhereOrNull((e) => token['id'] == e['address']);
      if (bT == null) return;
      token['balance'] = bT['balance'];

      setState(() {
        streamingTokens.add(token);
      });
    }
    startStreamTimer();
  }

  Future gB() async {
    for (var i = 0; i < addressList.length; i++) {
      double b = await getBalance(address, addressList[i]['address']);
      setState(() {
        addressList[i]['balance'] = b;
      });
    }
    gT();
    gST();
  }

  bool ownAddress(add) {
    return address == add;
  }

  @override
  void initState() {
    super.initState();
    gB();
  }

  @override
  void dispose() {
    timer.cancel();
    streamTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Tokens",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: RefreshIndicator(
        backgroundColor: primaryColor,
        onRefresh: () async {
          await gB();
          return;
        },
        child: Container(
          margin: const EdgeInsets.only(top: 12),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: addressList.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (_, ind) {
              return GestureDetector(
                onTap: () async {
                  await showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      context: context,
                      builder: (_) {
                        return TokenActions(token: addressList[ind]);
                      });
                },
                child: Padding(
                  padding: const EdgeInsets.all(4),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 238, 238),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage(addressList[ind]['image']),
                        backgroundColor: Colors.white,
                      ),
                      title: Text(
                        "${addressList[ind]['symbol']}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        "${addressList[ind]['name']}",
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          AnimatedFlipCounter(
                            duration: const Duration(seconds: 1),
                            value: addressList[ind]['balance'],
                            fractionDigits: 9,
                            textStyle: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(height: 4),
                          Text(
                              (addressList[ind]['currentFlowRate'] *
                                          31 *
                                          24 *
                                          60 *
                                          60)
                                      .toStringAsFixed(2) +
                                  "/mo",
                              style: TextStyle(
                                  color: addressList[ind]['currentFlowRate'] < 0
                                      ? Colors.red
                                      : Colors.green)),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
