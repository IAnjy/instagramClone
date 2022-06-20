import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttergram/models/user.dart' as model;
import 'package:fluttergram/resources/storage_methods.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<model.User> getUserDetails() async {
    User currentUser = _auth.currentUser!;

    DocumentSnapshot snap =
        await _firestore.collection('users').doc(currentUser.uid).get();

    // mba tsy anaovana an'izao inbobaka rehefa mila user de nanao fonction any anaty model
    // return model.User(
    //   followers: (snap.data() as Map<String, dynamic>)['followers']
    // );

    return model.User.fromSnap(snap);
  }

  //sign up user
  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "some error occured";
    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        //register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethods()
            .uploadImageToStorage('profilePics', file, false);

        //nanambotra model de amzay misaraka tsara ny model sy ny traitement
        model.User user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          followers: [],
          following: [],
          photoUrl: photoUrl,
        );

        //add user to our database
        await _firestore.collection('users').doc(cred.user!.uid).set(
              user.toJson(),
            );

        //
        // await _firestore.collection('users').add({
        //    'username': username,
        //   'uid': cred.user!.uid,
        //   'email': email,
        //   'bio': bio,
        //   'followers': [],
        //   'following': [],
        // });

        res = "success";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'email is le tsy manaraka format';
      } else if (err.code == 'weak-password') {
        res = 'your Password is le tsy manaraka ny fenitra !';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  //login
  Future<String> loginUser(
      {required String email, required String password}) async {
    String res = 'Some error occured';
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        res = "success";
      } else {
        res = "enter all the fields";
      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'user-not-found') {
        res = "l'adresse email n'est pas reconnue !";
      } else if (err.code == 'wrong-password') {
        res = 'your Password is le diso !';
      }
    } catch (e) {
      res = e.toString();
    }
    return res;
  }
}
