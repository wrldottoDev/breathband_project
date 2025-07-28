import 'package:breathband_app/models/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NoteService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String get _uid => _auth.currentUser!.uid;

  CollectionReference get _notes =>
      _firestore.collection('users').doc(_uid).collection('notes');

  Future<void> addNote(Note note) => _notes.add(note.toMap());

  Stream<List<Note>> getNotes() =>
      _notes.orderBy('date', descending: true).snapshots().map(
            (snap) => snap.docs
                .map((doc) => Note.fromMap(doc.id, doc.data() as Map<String, dynamic>))
                .toList(),
          );

  Future<void> updateNote(Note note) =>
      _notes.doc(note.id).update(note.toMap());

  Future<void> deleteNote(String id) => _notes.doc(id).delete();
}