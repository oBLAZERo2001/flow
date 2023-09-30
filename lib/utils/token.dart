import 'dart:convert';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter/services.dart' show rootBundle;

const rpcUrl = "https://base-goerli.publicnode.com";
const rpcWssUrl = "wss://base-goerli.publicnode.com";
final client = Web3Client(rpcUrl, Client(), socketConnector: () {
  return IOWebSocketChannel.connect(rpcWssUrl).cast<String>();
});

Future<String> getAbi() async {
  String abiStringFile = await rootBundle.loadString('lib/utils/abi.json');
  var jsonAbi = jsonDecode(abiStringFile), abiCode = jsonEncode(jsonAbi);
  return abiCode;
}

Future<DeployedContract> getContract(contractAddress) async {
  String abi = await getAbi();
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'My Coin'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

// getName() async {
//   final contract = await getContract();
//   final nameFunction = contract.function('name');

//   final name =
//       await client.call(contract: contract, function: nameFunction, params: []);
//   print(name);
// }

getBalance(String address, String contractAddress) async {
  final contract = await getContract(contractAddress);

  final balanceFunction = contract.function('balanceOf');

  final balance = await client.call(
      contract: contract,
      function: balanceFunction,
      params: [EthereumAddress.fromHex(address)]);
  return (EtherAmount.fromBigInt(EtherUnit.wei, balance.first)
      .getValueInUnit(EtherUnit.ether));
}

sendToken(String address, String contractAddress, value) async {
  final contract = await getContract(contractAddress);

  final fn = contract.function('transfer');

  final credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));

  await client.sendTransaction(
    credentials,
    Transaction.callContract(
        contract: contract,
        function: fn,
        parameters: [EthereumAddress.fromHex(address), value]),
    chainId: 42220,
  );
}
