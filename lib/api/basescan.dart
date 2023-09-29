import 'dart:convert';

import 'package:http/http.dart' as http;

Future getTransactionsByAccount(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://api-goerli.basescan.org/api?module=account&action=txlist&address=$add&sort=desc&apikey=D5TEU1W6614NTJS1A7VNZS2MHG6V5NQS4A"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}

Future getBalanceByAddress(String add) async {
  try {
    http.Response response = await http.get(
      Uri.parse(
          "https://api-goerli.basescan.org/api?module=account&action=balance&address=$add&tag=latest&apikey=D5TEU1W6614NTJS1A7VNZS2MHG6V5NQS4A"),
    );
    var fR = jsonDecode(response.body);
    return fR["result"];
  } catch (e) {
    //
  }
}
