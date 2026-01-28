import 'package:flutter/material.dart';
import 'package:torch_light/torch_light.dart';
import 'package:battery_plus/battery_plus.dart';

void main() {
  runApp(const FlashLightApp());
}

class FlashLightApp extends StatelessWidget {
  const FlashLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashLight Pro',
      theme: ThemeData.dark(),
      home: const FlashLightPage(),
    );
  }
}

class FlashLightPage extends StatefulWidget {
  const FlashLightPage({super.key});

  @override
  State<FlashLightPage> createState() => _FlashLightPageState();
}

class _FlashLightPageState extends State<FlashLightPage> {
  bool isOn = false;
  int batteryLevel = 0;

  @override
  void initState() {
    super.initState();
    _getBattery();
  }

  Future<void> _getBattery() async {
    final battery = Battery();
    final level = await battery.batteryLevel;
    setState(() {
      batteryLevel = level;
    });
  }

  Future<void> toggleFlash() async {
    try {
      if (isOn) {
        await TorchLight.disableTorch();
      } else {
        await TorchLight.enableTorch();
      }
      setState(() {
        isOn = !isOn;
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: isOn
                ? [Colors.yellow.shade700, Colors.black]
                : [Colors.grey.shade900, Colors.black],
            radius: 0.8,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'FlashLight Pro',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: isOn ? Colors.yellow : Colors.white,
              ),
            ),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: toggleFlash,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isOn ? Colors.yellow : Colors.grey.shade800,
                  boxShadow: [
                    BoxShadow(
                      color: isOn ? Colors.yellowAccent : Colors.black54,
                      blurRadius: 30,
                      spreadRadius: 5,
                    )
                  ],
                ),
                child: Icon(
                  Icons.power_settings_new,
                  size: 80,
                  color: isOn ? Colors.black : Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Text(
              'Battery: $batteryLevel%',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tap the button to toggle flashlight',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}
