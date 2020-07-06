import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/models/user.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // create user obj based on firebaseuser 
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  // auth change user stream ... 
  //stream = A stream is like a pipe, you put a value on the one end and if there’s a listener on the other end that listener will receive that value
  Stream<User> get user {
    return _auth.onAuthStateChanged
      //.map((FirebaseUser user) => _userFromFirebaseUser(user));
      .map(_userFromFirebaseUser); //same lang sa top
    }

  // sign anon
  Future signInAnon() async {
    try
    {   
      AuthResult result = await _auth.signInAnonymously();
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;

    }
  }

// register with email
  Future registerWithEmailAndPassword(String email, String password) async {
    try {

      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email.trim(), password: password.trim());
      FirebaseUser user = result.user;

      //create a new document for the user uid
      await DatabaseService(uid: user.uid).updateUserData('0', 'new crew member', 100);
      return _userFromFirebaseUser(user);

    }
    catch(e)
    {
        print(e.toString());
        return null;

    }
  }


  // sign email && pass
  Future signInWithEmailandPassword(String email, String password) async {
        try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);

    }
    catch(e)
    {
        print(e.toString());
        return null;

    }
  }

  

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();

    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }
}