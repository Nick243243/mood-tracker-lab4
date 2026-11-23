import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mood_tracker/models/mood_entry.dart';
import 'package:mood_tracker/widgets/mood_entry_form.dart';

Finder get saveButton => find.widgetWithText(FilledButton, 'Save entry');

Future<void> pumpForm(
  WidgetTester tester,
  List<MoodEntry> entries,
) async {
  tester.view.physicalSize = const Size(400, 1000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: MoodEntryForm(onSubmit: entries.add),
        ),
      ),
    ),
  );
}

void main() {
  testWidgets('saving without a score shows an error and adds no entry',
      (tester) async {
    final entries = <MoodEntry>[];
    await pumpForm(tester, entries);

    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);
    expect(entries, isEmpty);
  });

  testWidgets('a note over 2000 characters is rejected', (tester) async {
    final entries = <MoodEntry>[];
    await pumpForm(tester, entries);

    await tester.tap(find.widgetWithText(ChoiceChip, '7'));
    await tester.pump();
    await tester.enterText(
      find.byType(TextField),
      List.filled(maxNoteLength + 1, 'x').join(),
    );
    await tester.tap(saveButton);
    await tester.pump();

    expect(find.text('Note must be 2000 characters or fewer'), findsOneWidget);
    expect(entries, isEmpty);
  });

  testWidgets('a note of exactly 2000 characters is saved', (tester) async {
    final entries = <MoodEntry>[];
    final note = List.filled(maxNoteLength, 'x').join();
    await pumpForm(tester, entries);

    await tester.tap(find.widgetWithText(ChoiceChip, '7'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), note);
    await tester.tap(saveButton);
    await tester.pump();

    expect(entries, hasLength(1));
    expect(entries.single.score, 7);
    expect(entries.single.note, note);
    expect(find.text('Note must be 2000 characters or fewer'), findsNothing);
  });

  testWidgets('a valid save resets the form and clears a previous error',
      (tester) async {
    final entries = <MoodEntry>[];
    await pumpForm(tester, entries);

    await tester.tap(saveButton);
    await tester.pump();
    expect(find.text('Choose a score from 1 to 10'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, '8'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'Great day');
    await tester.tap(saveButton);
    await tester.pump();

    expect(entries, hasLength(1));
    expect(entries.single.score, 8);
    expect(entries.single.note, 'Great day');
    expect(find.text('Choose a score from 1 to 10'), findsNothing);
    expect(find.text('Great day'), findsNothing);
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '8')).selected,
      isFalse,
    );
  });
}
