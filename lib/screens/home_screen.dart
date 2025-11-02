import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'contacts_screen.dart';
import 'profile_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final AudioPlayer _player = AudioPlayer();

  final List<Widget> _tabs = [
    const HomeTab(),
    const ContactsScreen(),
    const ProfileScreen(),
  ];

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pinkAccent,
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _selectedIndex = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts_rounded), label: 'Contacts'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final AudioPlayer _player = AudioPlayer();

  Future<void> _playAlert() async {
    try {
      await _player.play(AssetSource('alert.mp3'));
    } catch (_) {}
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services disabled';
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw 'Location permission denied';
    }
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<List<String>> _loadPhones() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString('contacts');
    if (s == null) return [];
    final List decoded = jsonDecode(s);
    return decoded.map((e) => (e as Map)['phone'].toString()).toList();
  }

  Future<void> _sendSOS() async {
    try {
      await Permission.location.request();
      await Permission.sms.request();
      await _playAlert();

      final pos = await _determinePosition();
      final mapLink =
          'https://www.google.com/maps?q=${pos.latitude},${pos.longitude}';
      final message = '🚨 Emergency! I need help. My location: $mapLink';

      final phones = await _loadPhones();
      if (phones.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('No saved contacts. Add contacts first.')),
        );
        return;
      }

      final allNumbers = phones.join(',');

      final Uri smsUri = Uri(
        scheme: 'sms',
        path: allNumbers,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri, mode: LaunchMode.externalApplication);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('SMS app opened — tap send to notify all contacts.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open SMS app')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _openPoliceHelp() async {
    try {
      final pos = await _determinePosition();
      final Uri uri = Uri.parse(
          'https://www.google.com/maps/search/police+station+near+me/@${pos.latitude},${pos.longitude},15z');
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open maps')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SafeHer Home'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            ElevatedButton(
              onPressed: _sendSOS,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(64),
                elevation: 6,
              ),
              child: const Text('SOS',
                  style: TextStyle(fontSize: 28, color: Colors.white)),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _openPoliceHelp,
              icon: const Icon(Icons.local_police, color: Colors.pinkAccent),
              label: const Text('Police Help',
                  style: TextStyle(color: Colors.pinkAccent)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.pinkAccent, width: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
