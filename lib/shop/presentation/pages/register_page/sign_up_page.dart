import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shop_app/shop/presentation/pages/register_page/register_widgets/camera_choice_widget.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scafoldKey =
      GlobalKey<ScaffoldMessengerState>();
  String? _name;
  String? _email;
  String? _password;
  bool isVisibile = true;
  bool proccesing = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  dynamic _pickedImageError;
  void _pickerImageFromCamera() async {
    try {
      final _pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = _pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });

      log('image error $_pickedImageError');
    }
  }

  void _pickerImageFromGallery() async {
    try {
      final _pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = _pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickedImageError = e;
      });

      log('image error $_pickedImageError');
    }
  }

  void snackBar(String text) {
    _scafoldKey.currentState!.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 4),
        backgroundColor: Colors.red,
        content: Text(
          textAlign: TextAlign.center,
          text,
          style: TextStyle(
            fontSize: 25,
          ),
        ),
      ),
    );
  }

  void signUp() async {
    setState(() {
      proccesing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_formKey != null) {
        try {
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _email!,
            password: _password!,
          );
          Navigator.pushReplacementNamed(context, '/home_page');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              proccesing = false;
            });
            snackBar('The password provided is too weak.');
            log('The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            proccesing = false;
            snackBar('The account already exists for that email.');
            log('The account already exists for that email.');
          }
        } catch (e) {
          setState(() {
            proccesing = false;
          });
          snackBar('$e');
          log('$e');
        }
      } else {
        setState(() {});
        snackBar('Please pick an image');
      }
    } else {
      setState(() {
        proccesing = false;
      });
      snackBar('Please fill your blank');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scafoldKey,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SafeArea(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Sign Up',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.home_work,
                              size: 30,
                            ))
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.purple,
                          backgroundImage: _imageFile == null
                              ? null
                              : FileImage(File(_imageFile!.path)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CameraChoiceWidget(
                                  icon: Icons.camera_alt,
                                  onTap: () {
                                    _pickerImageFromCamera();
                                  },
                                  radiusOnly: BorderRadius.only(
                                    topLeft: Radius.circular(16),
                                    topRight: Radius.circular(16),
                                  ),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                CameraChoiceWidget(
                                  icon: Icons.photo,
                                  onTap: () {
                                    _pickerImageFromGallery();
                                  },
                                  radiusOnly: BorderRadius.only(
                                    bottomLeft: Radius.circular(16),
                                    bottomRight: Radius.circular(16),
                                  ),
                                ),
                              ]),
                        ),
                      ],
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _name = value;
                        log(_name!);
                      },
                      controller: _nameController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill your email';
                        } else if (value.isNameValid() == false) {
                          return 'Not Valid';
                        } else if (value.isNameValid() == true) {
                          return null;
                        }
                        return null;
                      },
                      // validator: (value) {
                      //   if (value!.isEmpty) {
                      //     return 'Please fill your full name';
                      //   } else {
                      //     return null;
                      //   }
                      // },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          hintText: 'Please enter your Full name',
                          label: Text(
                            'Full Name ',
                            style:
                                TextStyle(fontSize: 20, color: Colors.blueGrey),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _email = value;
                        log(_email!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill your email';
                        } else if (value.isEmailValid() == false) {
                          return 'Not Valid';
                        } else if (value.isEmailValid() == true) {
                          return null;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          hintText: 'Please enter your email',
                          label: Text(
                            'Email',
                            style:
                                TextStyle(fontSize: 20, color: Colors.blueGrey),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onChanged: (value) {
                        _password = value;
                        log(_password!);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please fill your email';
                        } else if (value.isPasswordValid() == false) {
                          return 'Not Valid';
                        } else if (value.isPasswordValid() == true) {
                          return null;
                        }
                        return null;
                      },
                      //  validator: (value) {
                      //     if (value!.isEmpty) {
                      //       return 'Please fill your password';
                      //     } else {
                      //       return null;
                      //     }
                      //   },
                      obscureText: isVisibile,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(isVisibile == false
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                isVisibile = !isVisibile;
                              });
                            },
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.blue,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.purple,
                              width: 2,
                            ),
                          ),
                          hintText: 'Please enter your password',
                          label: Text(
                            'Password',
                            style:
                                TextStyle(fontSize: 20, color: Colors.blueGrey),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'already have account ? ',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        proccesing == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Colors.purple,
                                ),
                              )
                            : GestureDetector(
                                onTap: () {
                                  signUp();
                                },
                                child: Text(
                                  'Log In ',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.purple,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.purple,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 150, vertical: 15),
                          child: Text(
                            'Log In ',
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

extension EmailValidator on String {
  bool isNameValid() {
    return RegExp(r'^([a-z]+)$').hasMatch(this);
  }

  bool isEmailValid() {
    return RegExp(r'^([a-zA-Z0-9]+)([@])([a-zA-Z0-9]+)([\-\_\.])([a-z]{2,3})$')
        .hasMatch(this);
  }

  bool isPasswordValid() {
    return RegExp(r'^([a-zA-Z0-9]+)$').hasMatch(this);
  }
}
