import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:to_do/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  TextEditingController confirmPasswordController =
      TextEditingController(text: '');

  bool isLoading = false;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool validate() {
    bool isValid = true;

    if (emailController.text.isEmpty) {
      setState(() {
        emailError = 'Email tidak boleh kosong';
      });
      isValid = false;
    } else {
      setState(() {
        emailError = null;
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = 'Password tidak boleh kosong';
      });
      isValid = false;
    } else {
      setState(() {
        passwordError = null;
      });
    }

    if (confirmPasswordController.text.isEmpty) {
      setState(() {
        confirmPasswordError = 'Konfirmasi password tidak boleh kosong';
      });
      isValid = false;
    } else if (confirmPasswordController.text != passwordController.text) {
      setState(() {
        confirmPasswordError = 'Konfirmasi password tidak cocok';
      });
      isValid = false;
    } else {
      setState(() {
        confirmPasswordError = null;
      });
    }

    return isValid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        children: [
          const SizedBox(height: 60),
          Column(
            children: [
              const Text(
                'Register',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'email',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  errorText: emailError,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  errorText: passwordError,
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'konfirmasi password',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  errorText: confirmPasswordError,
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    if (!isLoading && validate()) {
                      register(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Daftar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 30),
              RichText(
                text: TextSpan(
                  text: 'Sudah punya akun? ',
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  children: [
                    TextSpan(
                      text: 'Login',
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginPage(),
                            ),
                          );
                        },
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void register(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Jika berhasil mendaftar, Anda dapat menavigasi pengguna ke halaman beranda atau melakukan tindakan lainnya
    } catch (e) {
      // ignore: avoid_print
      print("Error: $e");

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Terjadi kesalahan saat mendaftar: $e"),
        duration: const Duration(seconds: 5), // Atur durasi tampilan snackbar
      ));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
