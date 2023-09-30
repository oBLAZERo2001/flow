import 'package:flow/screens/index.dart';
import 'package:flow/screens/recieve.dart';
import 'package:flow/screens/send.dart';
import 'package:flow/screens/tokens.dart';
import 'package:flow/screens/splash.dart';
import 'package:flow/screens/home.dart';
import 'package:flow/screens/transactions.dart';
import 'package:flow/screens/wallet.dart';
import 'package:flow/screens/settings.dart';
import 'package:flow/screens/walletimport.dart';
import 'package:flow/screens/welcome.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';

class Routers {
  static List<GetPage> getRouters = [
    GetPage(
      name: '/',
      page: () => const Splash(),
    ),
    GetPage(
      name: '/settings',
      page: () => const Settings(),
    ),
    GetPage(
      name: '/index',
      page: () => const IndexScreen(),
    ),
    GetPage(
      name: '/wallet',
      page: () => const Wallet(),
    ),
    GetPage(
      name: '/home',
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: '/walletimport',
      page: () => const WalletImport(),
    ),
    GetPage(
      name: '/welcome',
      page: () => const Welcome(),
    ),
    GetPage(
      name: '/list',
      page: () => const TokenScreen(),
    ),
    GetPage(
      name: '/send',
      page: () => const SendScreen(),
    ),
    GetPage(
      name: '/recieve',
      page: () => const RecieveScreen(),
    ),
    GetPage(
      name: '/transactions',
      page: () => const TransactionsScreen(),
    ),
  ];

  static final defaultPage = GetPage(
    name: '/notfound',
    page: () => const Scaffold(
      body: Center(
        child: Text('Check Route Name'),
      ),
    ),
  );
}
