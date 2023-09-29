import 'package:flow/components/balance_modal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TokenActions extends StatelessWidget {
  final Map token;
  const TokenActions({super.key, required this.token});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 27, 27, 27),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    context: context,
                    builder: (_) {
                      return BalanceModal(token: token);
                    });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 48, 48, 48),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed("/send", arguments: token),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const ListTile(
                          title: Text(
                            "Send",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 27, 27, 27)),
                        height: 12),
                    GestureDetector(
                      onTap: () => Get.toNamed("/recieve"),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const ListTile(
                          title: Text(
                            "Recieve",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 27, 27, 27)),
                        height: 12),
                    GestureDetector(
                      onTap: () => Get.toNamed("/recieve"),
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 48, 48, 48),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const ListTile(
                          title: Text(
                            "Create Stream",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
