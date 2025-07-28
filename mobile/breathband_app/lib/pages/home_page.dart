import 'package:breathband_app/models/note_model.dart';
import 'package:breathband_app/services/note_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _service = NoteService();
  final _textCtrl = TextEditingController();
  String _selectedMood = "😊";

  void _showAddDialog({Note? noteToEdit}) {
    if (noteToEdit != null) {
      _textCtrl.text = noteToEdit.text;
      _selectedMood = noteToEdit.mood;
    } else {
      _textCtrl.clear();
      _selectedMood = "😊";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(noteToEdit == null ? "Nueva nota" : "Editar nota"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _textCtrl,
              decoration: const InputDecoration(hintText: "Escribe tu nota..."),
            ),
            const SizedBox(height: 10),
            TextField(
              onChanged: (value) => _selectedMood = value,
              decoration: InputDecoration(
                labelText: "Emoji de estado de ánimo",
                hintText: _selectedMood,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              if (_textCtrl.text.trim().isNotEmpty) {
                final newNote = Note(
                  id: noteToEdit?.id ?? '',
                  text: _textCtrl.text,
                  mood: _selectedMood,
                  date: DateTime.now(),
                );

                if (noteToEdit == null) {
                  _service.addNote(newNote);
                } else {
                  _service.updateNote(newNote);
                }

                _textCtrl.clear();
                Navigator.pop(context);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bitácora"),
        backgroundColor: const Color(0xFF00C853),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(),
        backgroundColor: const Color(0xFF00C853),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Note>>(
        stream: _service.getNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (_, i) {
              final note = notes[i];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  leading: Text(note.mood, style: const TextStyle(fontSize: 32)),
                  title: Text(note.text),
                  subtitle: Text(
                    DateFormat('dd MMM yyyy – HH:mm').format(note.date),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('¿Borrar esta nota?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Borrar', style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );
  if (confirm == true) {
    _service.deleteNote(note.id);
  }
},
                  ),
                  onTap: () => _showAddDialog(noteToEdit: note),
                ),
              );
            },
          );
        },
      ),
    );
  }
}