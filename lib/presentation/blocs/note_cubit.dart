import 'package:flutter_bloc/flutter_bloc.dart';
import 'note_state.dart';
import '../../../domain/repositories/note_repository.dart';
import '../../../domain/entities/note.dart';

class NoteCubit extends Cubit<NoteState> {
  final NoteRepository repository;
  late String userId;

  NoteCubit(this.repository) : super(NoteInitial());

  void setUser(String uid) {
    userId = uid;
  }

  Future<void> fetchNotes() async {
    emit(NoteLoading());
    try {
      final notes = await repository.fetchNotes(userId);
      emit(NoteLoaded(notes));
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> addNote(String text) async {
    try {
      await repository.addNote(userId, text);
      fetchNotes();
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> updateNote(String id, String text) async {
    try {
      await repository.updateNote(userId, id, text);
      fetchNotes();
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }

  Future<void> deleteNote(String id) async {
    try {
      await repository.deleteNote(userId, id);
      fetchNotes();
    } catch (e) {
      emit(NoteError(e.toString()));
    }
  }
}
