import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:battery_plus/battery_plus.dart';

late List<CameraDescription> cameras;
CameraController? controller;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(const FlashLightApp());
}

class FlashLightApp extends StatelessWidget {
  const FlashLightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashHome(),
    );
  }
}

class FlashHome extends StatefulWidget {
  const FlashHome({super.key});

  @override
  State<FlashHome> createState() => _FlashHomeState();
}

class _FlashHomeState extends State<FlashHome> {
  bool isOn = false;
  double intensity = 1.0;
  int battery = 0;

  @override
  void initState() {
    super.initState();
    initCamera();
    getBattery();
  }

  Future<void> initCamera() async {
    controller = CameraController(
      cameras.first,
      ResolutionPreset.low,
      enableAudio: false,
    );
    await controller!.initialize();
  }

  Future<void> getBattery() async {
    battery = await Battery().batteryLevel;
    setState(() {});
  }

  Future<void> toggleFlash() async {
    if (isOn) {
      await controller!.setFlashMode(FlashMode.off);
    } else {
      await controller!.setFlashMode(FlashMode.torch);
      await controller!.setExposureOffset(intensity);
    }
    setState(() {
      isOn = !isOn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "FlashLight Pro",
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 60),
          GestureDetector(
            onTap: toggleFlash,
            child: CircleAvatar(
              radius: 90,
              backgroundColor: Colors.grey[850],
              child: Icon(
                Icons.power_settings_new,
                size: 80,
                color: isOn ? Colors.green : Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            "Battery: $battery%",
            style: const TextStyle(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 20),
          const Text(
            "Light Intensity",
            style: TextStyle(color: Colors.white70),
          ),
          Slider(
            value: intensity,
            min: 0,
            max: 5,
            onChanged: (value) async {
              setState(() {
                intensity = value;
              });
              if (isOn) {
                await controller!.setExposureOffset(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
