import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _name = TextEditingController();
  final _age = TextEditingController();
  final _phone = TextEditingController();
  final _aadhaar = TextEditingController();
  bool _editing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    _name.text = prefs.getString('profile_name') ?? '';
    _age.text = prefs.getString('profile_age') ?? '';
    _phone.text = prefs.getString('profile_phone') ?? '';
    _aadhaar.text = prefs.getString('profile_aadhaar') ?? '';
    setState(() {});
  }

  Future<void> _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_name', _name.text.trim());
    await prefs.setString('profile_age', _age.text.trim());
    await prefs.setString('profile_phone', _phone.text.trim());
    await prefs.setString('profile_aadhaar', _aadhaar.text.trim());
    setState(() => _editing = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile saved')));
  }

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _phone.dispose();
    _aadhaar.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.save : Icons.edit),
            onPressed: () {
              if (_editing) {
                _saveProfile();
              } else {
                setState(() => _editing = true);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 56,
                backgroundImage: const AssetImage('assets/logo.jpg'),
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Full name'),
                enabled: _editing,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _age,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                enabled: _editing,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
                enabled: _editing,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _aadhaar,
                decoration: const InputDecoration(labelText: 'Aadhaar'),
                keyboardType: TextInputType.number,
                enabled: _editing,
              ),
              const SizedBox(height: 20),
              if (!_editing)
                Text(
                  'Stay safe, stay empowered ',
                  style: TextStyle(color: Colors.pinkAccent.shade700),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
