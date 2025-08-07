import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:verify/bloc/auth_bloc.dart';
import 'package:verify/bloc/auth_event.dart';
import 'package:verify/bloc/auth_state.dart';
import 'package:verify/screens/selfie_capture.dart';

class DocumentCapture extends StatefulWidget {
  final String email;

  const DocumentCapture({super.key, required this.email});

  @override
  State<DocumentCapture> createState() => _DocumentCaptureState();
}

class _DocumentCaptureState extends State<DocumentCapture> {
  File? _documentImage;
  bool _isReviewing = false;

  Future<void> _captureDocument() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _documentImage = File(pickedFile.path);
        _isReviewing = true;
      });
    }
  }

  void _retakeDocument() {
    setState(() {
      _documentImage = null;
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
                  if (state is AuthDocumentUploaded) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            SelfieCapture(email: widget.email),
                      ),
                    );
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
                              child: _documentImage != null
                                  ? Image.file(
                                      _documentImage!,
                                      fit: BoxFit.cover,
                                    )
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
                                        onPressed: _retakeDocument,
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
                                          if (_documentImage != null) {
                                            context.read<AuthBloc>().add(
                                              UploadDocumentEvent(
                                                email: widget.email,
                                                documentImagePath:
                                                    _documentImage!.path,
                                              ),
                                            );
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  'Please capture a document',
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
                                  'Place Document Here',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _captureDocument,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                minimumSize: const Size(200, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                _documentImage == null
                                    ? 'Capture Document'
                                    : 'Document Captured',
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
