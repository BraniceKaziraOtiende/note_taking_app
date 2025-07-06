import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/note_cubit.dart';

void showNoteInputDialog(
  BuildContext context, {
  required bool isEdit,
  String? existingText,
  String? noteId,
}) {
  final controller = TextEditingController(text: existingText);

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(isEdit ? "Edit Note" : "Add Note"),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(hintText: "Enter note text"),
        autofocus: true,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            if (controller.text.trim().isNotEmpty) {
              if (isEdit) {
                context.read<NoteCubit>().updateNote(
                      noteId!,
                      controller.text.trim(),
                    );
              } else {
                context.read<NoteCubit>().addNote(controller.text.trim());
              }
              Navigator.pop(context);
            }
          },
          child: Text(isEdit ? "Update" : "Add"),
        ),
      ],
    ),
  );
}
