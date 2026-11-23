import 'package:flutter/material.dart';

import '../models/mood_entry.dart';

/// A form for recording a new mood entry.
///
/// Exercise 1, step 3, and Exercise 2, steps 1-3.
class MoodEntryForm extends StatefulWidget {
  const MoodEntryForm({super.key, required this.onSubmit});

  /// Called with the new entry when the user saves it.
  final ValueChanged<MoodEntry> onSubmit;

  @override
  State<MoodEntryForm> createState() => _MoodEntryFormState();
}

class _MoodEntryFormState extends State<MoodEntryForm> {
  int? _score;
  final TextEditingController _noteController = TextEditingController();
  String? _validationMessage;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _save() {
    final score = _score;
    if (score == null) {
      setState(() {
        _validationMessage = 'Choose a score from 1 to 10';
      });
      return;
    }

    final note = _noteController.text.trim();
    if (note.length > maxNoteLength) {
      setState(() {
        _validationMessage =
            'Note must be $maxNoteLength characters or fewer';
      });
      return;
    }

    final entry = MoodEntry(
      score: score,
      note: note.isEmpty ? null : note,
      createdAt: DateTime.now(),
    );

    setState(() {
      _score = null;
      _noteController.clear();
      _validationMessage = null;
    });
    widget.onSubmit(entry);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'How are you feeling?',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (var score = 1; score <= 10; score++)
                  ChoiceChip(
                    label: Text('$score'),
                    selected: _score == score,
                    onSelected: (_) {
                      setState(() {
                        _score = score;
                      });
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Note (optional)'),
            ),
            if (_validationMessage != null) ...[
              const SizedBox(height: 8),
              Text(
                _validationMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ],
            const SizedBox(height: 12),
            FilledButton(onPressed: _save, child: const Text('Save entry')),
          ],
        ),
      ),
    );
  }
}
