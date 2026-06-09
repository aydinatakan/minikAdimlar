import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get user => _auth.authStateChanges();

  Future<String?> register(String email, String password, String name) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
      }
      // Mark as first time user
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_first_time', true);
      return null;
    } on FirebaseAuthException catch (e) {
      return _getMessageFromErrorCode(e.code);
    } catch (e) {
      return "Beklenmedik bir hata oluştu: ${e.toString()}";
    }
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email.trim(), password: password.trim());
      return null;
    } on FirebaseAuthException catch (e) {
      return _getMessageFromErrorCode(e.code);
    } catch (e) {
      return "Giriş yapılırken bir hata oluştu: ${e.toString()}";
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  String _getMessageFromErrorCode(String errorCode) {
    switch (errorCode) {
      case "email-already-in-use":
        return "Bu e-posta adresi zaten kullanımda.";
      case "invalid-email":
        return "Geçersiz bir e-posta adresi girdiniz.";
      case "operation-not-allowed":
        return "E-posta/şifre ile kayıt olma özelliği şu an kapalı. Lütfen yönetici ile iletişime geçin.";
      case "weak-password":
        return "Şifreniz çok zayıf. Lütfen daha güçlü bir şifre deneyin.";
      case "user-disabled":
        return "Bu kullanıcı hesabı devre dışı bırakılmış.";
      case "user-not-found":
        return "Bu e-posta adresi ile kayıtlı bir kullanıcı bulunamadı.";
      case "wrong-password":
        return "Hatalı şifre girdiniz.";
      case "invalid-credential":
        return "E-posta veya şifre hatalı.";
      case "network-request-failed":
        return "İnternet bağlantınızı kontrol edin.";
      case "too-many-requests":
        return "Çok fazla deneme yaptınız. Lütfen bir süre sonra tekrar deneyin.";
      case "channel-error":
        return "Lütfen tüm alanları doldurun.";
      default:
        return "Bir hata oluştu (Kod: $errorCode). Lütfen tekrar deneyin.";
    }
  }
}

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<Question>> getFillBlankQuestions() async {
    final snapshot = await _db
        .collection('fill_questions')
        .where('isActive', isEqualTo: true)
        .get();

    return snapshot.docs
        .map((doc) => Question.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  // Routine Tasks
  Future<List<RoutineTask>> getRoutineTasks() async {
    final snapshot = await _db.collection('routines').orderBy('order').get();
    return snapshot.docs.map((doc) => RoutineTask.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> uploadRoutines(List<Map<String, dynamic>> data) async {
    final batch = _db.batch();
    for (var item in data) {
      final docRef = _db.collection('routines').doc(item['id']);
      batch.set(docRef, item);
    }
    await batch.commit();
  }

  // PECS Cards
  Future<List<PecsCard>> getPecsCards() async {
    final snapshot = await _db.collection('pecs').get();
    return snapshot.docs.map((doc) => PecsCard.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> uploadPecs(List<Map<String, dynamic>> data) async {
    final batch = _db.batch();
    for (var item in data) {
      final docRef = _db.collection('pecs').doc(item['id']);
      batch.set(docRef, item);
    }
    await batch.commit();
  }

  // Colors & Shapes
  Future<List<ColorShapeQuestion>> getColorShapeQuestions() async {
    final snapshot = await _db.collection('color_shapes').get();
    return snapshot.docs.map((doc) => ColorShapeQuestion.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> uploadColorShapes(List<Map<String, dynamic>> data) async {
    final batch = _db.batch();
    for (var item in data) {
      final docRef = _db.collection('color_shapes').doc(item['id']);
      batch.set(docRef, item);
    }
    await batch.commit();
  }

  // Sequencing
  Future<List<SequenceScenario>> getSequenceScenarios() async {
    final snapshot = await _db.collection('sequences').get();
    return snapshot.docs.map((doc) => SequenceScenario.fromFirestore(doc.data(), doc.id)).toList();
  }

  Future<void> uploadSequences(List<Map<String, dynamic>> data) async {
    final batch = _db.batch();
    for (var item in data) {
      final docRef = _db.collection('sequences').doc(item['id']);
      batch.set(docRef, item);
    }
    await batch.commit();
  }
}
