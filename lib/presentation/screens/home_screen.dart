import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../blocs/note_cubit.dart';
import '../blocs/note_state.dart';
import '../widgets/note_card.dart';
import '../widgets/note_input_dialog.dart';
import '../../core/utils/snack_bar_helper.dart';
import '../../core/widgets/loading_indicator.dart';

class HomeScreen extends StatelessWidget {
  final User user;

  const HomeScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final noteCubit = NoteCubit(NoteRepositoryImpl())
      ..setUser(user.uid)
      ..fetchNotes();

    return BlocProvider(
      create: (_) => noteCubit,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Your Notes"),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            if (state is NoteLoading) return const LoadingIndicator();
            if (state is NoteError) {
              return Center(child: Text(state.message));
            }
            if (state is NoteLoaded) {
              if (state.notes.isEmpty) {
                return const Center(
                  child: Text("Nothing here yet—tap ➕ to add a note."),
                );
              }
              return ListView.builder(
                itemCount: state.notes.length,
                itemBuilder: (context, index) {
                  final note = state.notes[index];
                  return NoteCard(note: note);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showNoteInputDialog(context, isEdit: false),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
