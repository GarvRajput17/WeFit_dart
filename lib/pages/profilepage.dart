import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wefit/pages/ContactUs.dart';
import 'package:wefit/pages/PrivacyPolicy.dart';
import 'package:wefit/pages/changeprofile.dart';
import 'package:wefit/pages/history.dart';
import '../Profile_Components/SettingsPage.dart';
import '../components/bottom_nav_bar.dart';
import '../components/customcolor.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Box box;
  final ImagePicker _picker = ImagePicker();
  String? _profilePicture;
  String? _username;

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    await Hive.initFlutter();
    box = await Hive.openBox('profileBox');
    setState(() {
      _profilePicture = box.get('profilePicture');
      _username = box.get('name') ?? FirebaseAuth.instance.currentUser?.displayName ?? 'User';
    });
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profilePicture = pickedFile.path;
        box.put('profilePicture', pickedFile.path);
      });
    }
  }

  Future<void> _changeUsername(String newName) async {
    setState(() {
      _username = newName;
      box.put('name', newName);
    });
  }

  void userSignOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(onTap: () {}),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: TColor.secondaryColor1,
                      backgroundImage: _profilePicture != null
                          ? FileImage(File(_profilePicture!))
                          : null,
                      child: _profilePicture == null
                          ? const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      final newName = await _displayTextInputDialog(context);
                      if (newName != null && newName.isNotEmpty) {
                        _changeUsername(newName);
                      }
                    },
                    child: Text(
                      _username!,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // Height
                  _buildInfoTile(
                      title: 'Height', value: '${box.get('height')} cm'),
                  // Weight
                  _buildInfoTile(
                      title: 'Weight',
                      value: '${box.get('weight')}${box.get('weightUnit')}'),
                  // Age
                  _buildInfoTile(
                      title: 'Date Of Birth', value: '${box.get('dateOfBirth')}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: 'Account',
              children: [
                _buildListTile(
                  context,
                  icon: Icons.person,
                  title: 'Personal Data',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChangeProfilePage()),
                    );
                  },


                ),
                _buildListTile(
                  context,
                  icon: Icons.history,
                  title: 'Activity History',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WorkoutHistoryScreen()),
                    );
                  },
                )

              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: 'Notification',
              children: [
                SwitchListTile(
                  title: const Text('Pop-up Notification'),
                  value: box.get('popUpNotification') ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      box.put('popUpNotification', value);
                    });
                  },
                  secondary: const Icon(Icons.notifications),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: 'Other',
              children: [
                _buildListTile(
                  context,
                  icon: Icons.contact_support,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContactUsPage()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicyPage()),
                    );
                  },
                ),
                _buildListTile(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: MyCustomBottomNavBar(initialIndex: 3),
    );
  }

  Widget _buildInfoTile({required String title, required String value}) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 5),
        Text(title),
      ],
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _buildListTile(BuildContext context,
      {required IconData icon,
        required String title,
        void Function()? onTap}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }

  Future<String?> _displayTextInputDialog(BuildContext context) async {
    String newName = '';
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Username'),
          content: TextField(
            onChanged: (value) {
              newName = value;
            },
            decoration: const InputDecoration(hintText: "Enter new username"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context, newName);
              },
            ),
          ],
        );
      },
    );
  }
}