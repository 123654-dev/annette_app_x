class HomeworkManager {
  //Zwischenspeicher, der verhindert, dass mehr als ein Dialog gleichzeitig geöffnet werden kann
  static bool _isHomeworkDialogOpen = false;

  static void showHomeworkDialog() {
    //Wenn der Dialog bereits offen ist, wird kein weiterer geöffnet.
    if (_isHomeworkDialogOpen) return;

    //Der Dialog ist jetzt offen
    _isHomeworkDialogOpen = true;
  }
}
