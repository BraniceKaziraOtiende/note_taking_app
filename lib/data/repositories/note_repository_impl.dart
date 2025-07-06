import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

class NoteRepositoryImpl implements NoteRepository {
  final _db = FirebaseFirestore.instance;
  final String _userId = 'temporaryUser'; // Will be updated post-login

  @override
  Future<List<Note>> fetchNotes(String userId) async {
    final snapshot =
        await _db.collection('notes').doc(userId).collection('items').get();
    return snapshot.docs
        .map((doc) => NoteModel.fromMap(doc.id, doc.data()) as Note)
        .toList();
  }

  @override
  Future<void> addNote(String userId, String text) async {
    await _db.collection('notes').doc(userId).collection('items').add({
      'text': text,
    });
  }

  @override
  Future<void> updateNote(String userId, String id, String text) async {
    await _db
        .collection('notes')
        .doc(userId)
        .collection('items')
        .doc(id)
        .update({'text': text});
  }

  @override
  Future<void> deleteNote(String userId, String id) async {
    await _db
        .collection('notes')
        .doc(userId)
        .collection('items')
        .doc(id)
        .delete();
  }
}
