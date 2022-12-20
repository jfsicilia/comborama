/*
  This module enables some key combos to show help dialog windows.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk

; TODO Maybe in the future this file can be converted into an interface. If
; there are different help systems for different apps.

;-----------------------------------------------------------------------------
;                                 Hotkeys
;                         Open/Close help windows
;-----------------------------------------------------------------------------

#if true
  SC055 & /:: ShiftSwitch(func("ToggleKeyboardShortcutsHelpDialog"), func("JoplinSearchHelpDialog"))
#if

; Close help window.
#if (WinActive("ahk_class Internet Explorer_TridentDlgFrame"))
  SC055::
  ESC:: CloseWindow()
#if

;----------------------------------------------------------------------------
;                           Helper functions.
;----------------------------------------------------------------------------

/*
  Toggles help keyboard shortcuts help dialog. The dialog window is an
  internet explorer frame where a html file is loaded. If the dialog is
  active it closes it, if not, loads the file into the internet explorer
  frame an shows it.
*/
ToggleKeyboardShortcutsHelpDialog() {
  if not WinActive("ahk_class Internet Explorer_TridentDlgFrame") {
    ; Finds an html file with the same name as the current app. If not found,
    ; it will load the default _global_.exe.html file.
    WinGet, exeFile, ProcessName, A
    filepath := A_ScriptDir . "\html\" . exeFile . ".html"
    if not FileExist(filepath)
      filepath := A_ScriptDir . "\html\_global_.exe.html"

    ; Shows the html file in a internet explorer frame.
    hwnd := WinExist("A")
    ShowHTMLDialog("file:///" . filepath, ""
      , "dialogWidth:1800px;dialogHeight:800px;unadorned:yes;", hwnd, 0x0040)
  }
  else  ; Close dialog if active.
    CloseWindow()
}

/*
  Show an input box to make a search in Joplin. The note found will be open
  in chrome (in Chrome there is a plugin to show markdown files as html).
*/
JoplinSearchHelpDialog() {
    InputBox, UserInput, Open Joplin note in Chrome, , ,400, 100
    if (UserInput != "")
      OpenJoplinNoteInChrome(UserInput)
}

/*
  Makes a search in joplin and the first note found will be open in Chrome
  (in Chrome there is a plugin to show markdown files as html).
  search -- Text to search. If a # is present alone, the search statement
            will include tag:main. If a #<id> is present, the search
            statement will include tag:<id>. If a <text> is present, the
            search statement will include title:<text>.
*/
OpenJoplinNoteInChrome(search) {
  if (FocusOrLaunchJoplin() > 0) {
    ;FreeModifiers()
    while(True) {
      words := StrSplit(search, A_Space)
      query := ""
      for index, item in words {
        if (item = "#")
          query := query . "tag:main "
        else if (substr(item, 1, 1) = "#")
          query := query . "tag:" . substr(item, 2) . " "
        else
          query := query . "title:" . item . " "
      }

      ; Search for note in Joplin.
      SendInput(JOPLIN_COMBO_GOTO_ANYTHING)
      Sleep, 200
      SendInput(query)
      Sleep, 300
      SendInput, {Enter} 
      Sleep, 1000

      ; In Joplin, turn on external editing of note (will open it in Vim).
      SendInput, !^e
      Sleep, 1000

      ; After opening note in vim for editing, tell vim to open it in chrome.
      if (FocusOrLaunchVim() = 0)
        break
      SendInput, gX
      Sleep, 1000

      ; Switch back to Joplin to turn off external editing of note.
      if (FocusOrLaunchJoplin() = 0)
        break
      SendInput, !^e
      Sleep, 300

      ; Finally switch back to Chrome to view note.
      if (FocusOrLaunchChrome() = 0)
        break
      break
    }
    SetModifiers()
  }
}

