import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hyper_ui/core.dart';
import 'package:hyper_ui/shared/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../view/profile_view.dart';

class ProfileController extends State<ProfileView> {
  static late ProfileController instance;
  late ProfileView view;
  String? username, level, token, user_id, nama, nip, bebankerja, avatar;
  int? totalkegiatan;
  File? newavatar;
  final ImagePicker _picker = ImagePicker();
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    instance = this;
    super.initState();
    getUserDetails();
    loadUserDetails();
  }

  @override
  void dispose() => super.dispose();

  static Future<int?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    try {
      int? userId = await getUserId();
      if (userId == null) {
        print("User ID tidak ditemukan di SharedPreferences");
        return null;
      }

      // Panggil API
      var response = await Dio().get(
        Endpoints.getuser,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true) {
          List<dynamic> users = responseData['data'];
          Map<String, dynamic>? user = users.firstWhere(
            (u) => u['dosen_id'] == userId,
            orElse: () => null,
          );

          return user;
        } else {
          print("Response success false");
        }
      } else {
        print("Gagal mengambil data: ${response.statusCode}");
      }
    } catch (e) {
      print("Error: $e");
    }
    return null;
  }

  Future<void> loadUserDetails() async {
    var userDetails = await getUserDetails(); // Ambil data dari API
    if (userDetails != null) {
      setState(() {
        username = userDetails['username']; // Gunakan data yang benar
        nama = userDetails['nama'];
        nip = userDetails['nip'];
        avatar = userDetails['avatar'];
        bebankerja = userDetails['beban_kerja'];
        totalkegiatan = userDetails['total_kegiatan'];
      });
    } else {
      print("Data user tidak ditemukan");
    }
    print("Username: $username");
  }

  Future<void> editProfile({
    required String newUsername,
    required String newName,
    required String newNip,
  }) async {
    try {
      String? token = await SessionManager.getToken();

      if (token == null) {
        print("Token tidak ditemukan. Anda harus login ulang.");
        return;
      }

      FormData formData = FormData.fromMap({
        "username": newUsername,
        "nama": newName,
        "nip": newNip,
      });

      if (newavatar != null) {
        String filePath = newavatar!.path;

        if (!filePath.endsWith('.png') &&
            !filePath.endsWith('.jpg') &&
            !filePath.endsWith('.jpeg')) {
          throw Exception(
              "File avatar harus memiliki ekstensi .png, .jpg, atau .jpeg");
        }

        formData.files.add(MapEntry(
          "avatar",
          await MultipartFile.fromFile(filePath,
              filename: filePath.split('/').last),
        ));
      }

      var response = await Dio().post(
        Endpoints.postProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;

        if (responseData['success'] == true) {
          print("Profil berhasil diperbarui.");
          setState(() {
            username = newUsername;
            nama = newName;
            nip = newNip;
            avatar = responseData['avatar_url'];
          });
        } else {
          print("Gagal memperbarui profil: ${responseData['message']}");
        }
      } else {
        print("Error: ${response.statusCode}");
      }
    } catch (e) {
      print("Error saat memperbarui profil: $e");
    }
  }

  Future<void> _pickAvatar(BuildContext context) async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        newavatar = File(pickedFile.path);
      });

      Navigator.pop(context);
      showEditProfileDialog(context, ProfileController.instance);
    }
  }

  void showEditProfileDialog(
      BuildContext context, ProfileController controller) {
    final TextEditingController usernameController =
        TextEditingController(text: controller.username);
    final TextEditingController nameController =
        TextEditingController(text: controller.nama);
    final TextEditingController nipController =
        TextEditingController(text: controller.nip);
    setState(() {
      avatar;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.black),
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CircleAvatar(
                      backgroundImage: newavatar != null
                          ? FileImage(newavatar!)
                          : NetworkImage(
                              controller.avatar ??
                                  "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png",
                            ) as ImageProvider,
                      radius: 40,
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(primaryColor),
                      ),
                      onPressed: () => _pickAvatar(context),
                      child: Text(
                        'Pilih Gambar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: "Username"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Nama"),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: nipController,
                  decoration: const InputDecoration(labelText: "NIP"),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(primaryColor)),
              onPressed: () async {
                await controller.editProfile(
                  newUsername: usernameController.text,
                  newName: nameController.text,
                  newNip: nipController.text,
                );
                await controller.loadUserDetails();
                Navigator.pop(context);
              },
              child: const Text(
                "Save",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(BuildContext context) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm',
            style: TextStyle(color: Colors.black),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Apakah Yakin ingin Logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
              ),
              onPressed: () async {
                await SessionManager.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginView()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text(
                "Yes",
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}
