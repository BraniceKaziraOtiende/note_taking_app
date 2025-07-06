import '../entities/note.dart';

abstract class NoteRepository {
  Future<List<Note>> fetchNotes(String userId);
  Future<void> addNote(String userId, String text);
  Future<void> updateNote(String userId, String id, String text);
  Future<void> deleteNote(String userId, String id);
}
