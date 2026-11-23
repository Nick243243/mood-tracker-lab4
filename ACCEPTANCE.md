# Form validation: acceptance criteria

1. Given no score is selected, when I tap Save entry, then the message "Choose a score from 1 to 10" appears and nothing is added to the history.
2. Given a score of 7 is selected and the note has 2001 characters, when I tap Save entry, then an error message about the 2000-character limit appears and nothing is added to the history.
3. Given a score of 7 is selected and the note has 2000 characters, when I tap Save entry, then the entry is saved to the history and no error message is shown.
4. Given a score of 8 is selected and the note is "Great day", when I tap Save entry, then the entry is added to the history, the form resets, and any previous validation message disappears.