import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final isUndefinedOrNull = null;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
     
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff4954FD),
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage("assets/logo.png"),
              backgroundColor: Colors.transparent,
            ),
            SizedBox(
              width: (MediaQuery.sizeOf(context).width / 100) * 25,
              child: const Center(
                  child: CircularProgressIndicator(
                color: Colors.white,
                backgroundColor: Colors.white60,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
