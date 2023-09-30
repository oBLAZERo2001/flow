import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
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
  String abiStringFile = await rootBundle.loadString('lib/utils/stream.json');
  var jsonAbi = jsonDecode(abiStringFile), abiCode = jsonEncode(jsonAbi);
  return abiCode;
}

Future<DeployedContract> getContract(contractAddress) async {
  String abi = await getAbi();
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'MetaCoin'),
      EthereumAddress.fromHex(contractAddress));
  return contract;
}

createStream(num flowRate, String receiver, String contractAddress) async {
  try {
    List<int> list = '0x'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);
    String address = GetStorage().read("address");

    final contract =
        await getContract("0xcfA132E353cB4E398080B9700609bb008eceB125");

    final fn = contract.function('createFlow');

    final credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));

    await client.sendTransaction(
      credentials,
      Transaction.callContract(contract: contract, function: fn, parameters: [
        EthereumAddress.fromHex(contractAddress),
        EthereumAddress.fromHex(address),
        EthereumAddress.fromHex(receiver),
        BigInt.from(flowRate * pow(10, 18) / (30 * 24 * 60 * 60)),
        bytes,
      ]),
      chainId: 84531,
    );
  } catch (e) {
    print(e);
  }
}

cancelStream(String receiver, String sender, String contractAddress) async {
  try {
    List<int> list = '0x'.codeUnits;
    Uint8List bytes = Uint8List.fromList(list);

    final contract =
        await getContract("0xcfA132E353cB4E398080B9700609bb008eceB125");

    final fn = contract.function('deleteFlow');

    final credentials = EthPrivateKey.fromHex(GetStorage().read("privateKey"));

    await client.sendTransaction(
      credentials,
      Transaction.callContract(contract: contract, function: fn, parameters: [
        EthereumAddress.fromHex(contractAddress),
        EthereumAddress.fromHex(sender),
        EthereumAddress.fromHex(receiver),
        bytes,
      ]),
      chainId: 84531,
    );
  } catch (e) {
    // print(e);
  }
}


// fDAIx = 0x070f601eEe8fA4DF3c66EaEB16Ca0c0D8a9a0164
//flowRate, String receiver, String contractAddress