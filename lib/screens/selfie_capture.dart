import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verify/bloc/auth_bloc.dart';
import 'package:verify/bloc/auth_event.dart';
import 'package:verify/bloc/auth_state.dart';
import 'package:verify/screens/login_screen.dart';

class SelfieCapture extends StatefulWidget {
  final String email;

  const SelfieCapture({super.key, required this.email});

  @override
  State<SelfieCapture> createState() => _SelfieCaptureState();
}

class _SelfieCaptureState extends State<SelfieCapture> {
  File? _selfieImage;
  bool _isReviewing = false;

  Future<void> _captureSelfie() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _selfieImage = File(pickedFile.path);
        _isReviewing = true;
      });
    }
  }

  void _retakeSelfie() {
    setState(() {
      _selfieImage = null;
      _isReviewing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2A2A40),

      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2A2A40), Color(0xFF2A2A40)],
          ),
        ),
        child: Center(
          child: Card(
            color: Colors.white70,
            elevation: 8,
            margin: const EdgeInsets.all(20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: BlocConsumer<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state is AuthSelfieUploaded && state.verified) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  } else if (state is AuthSelfieNotMatched) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  } else if (state is AuthError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                builder: (context, state) {
                  return _isReviewing
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: _selfieImage != null
                                  ? Image.file(_selfieImage!, fit: BoxFit.cover)
                                  : const SizedBox.shrink(),
                            ),
                            const SizedBox(height: 20),
                            state is AuthLoading
                                ? const CircularProgressIndicator()
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      ElevatedButton(
                                        onPressed: _retakeSelfie,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red,
                                          minimumSize: const Size(120, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Retake',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          if (_selfieImage != null) {
                                            context.read<AuthBloc>().add(
                                              UploadSelfieEvent(
                                                email: widget.email,
                                                selfieImagePath:
                                                    _selfieImage!.path,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please capture a selfie',
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          minimumSize: const Size(120, 50),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                        ),
                                        child: const Text(
                                          'Submit',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 300,
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                              ),
                              child: const Center(
                                child: Text(
                                  'Place Face Here',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _captureSelfie,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _selfieImage == null
                                    ? 'Capture Selfie'
                                    : 'Selfie Captured',
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
