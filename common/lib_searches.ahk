/*
  This library provides support for favourite searches for Everything.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_apps.ahk
#include %A_ScriptDir%\hk_everything.ahk

; Script that deals with favourite searches in Everything. It bounds some
; key combos to the searches and it also allows to show a GUI ListBox to 
; select it from there.
LibSearchesAutoExec:
  ; Dictionary with al favourite searches and it's key shortcut.
  global FAV_SEARCHES_PATH := {"p":"books\ python *.pdf"
                             , "e":"books/ electronics/ *.pdf"
                             , "m":"books/ mathematics/ *.pdf"}

  ; String with all favourite searches ready for Gui Add Listbox option.
  global FAV_SEARCHES_GUI_OPTIONS := ""
  sep := ""
  for key, value in FAV_SEARCHES_PATH {
    FAV_SEARCHES_GUI_OPTIONS .= sep . key . " - " . value
    sep := "|"
  }

  ; Choice selected in GUI. 
  global favSearchChoice := ""
  ; Handler of the Everything window where GUI Listbox was launched.
  global favSearchAppHwnd := ""
return

/*
  Shows a listbox with all favourite folders to choose from.
*/
ShowFavSearchesListBox() {
  favSearchAppHwnd := WinExist("A")

  Gui, FavSearchGUI:New, -MinimizeBox
  Gui, FavSearchGUI:Add, ListBox, gFavSearchAction vfavSearchChoice W500 R20, %FAV_SEARCHES_GUI_OPTIONS%
  Gui, FavSearchGUI:Show,, Choose_search
}

; Deals with listbox.
#if WinActive("Choose_search ahk_class AutoHotkeyGUI")
  Enter::  ;  <-- Keys listed here WILL trigger a selection. 
    Sleep, 100 
  FavSearchAction: 
    if A_TimeSinceThisHotkey between 0 and 99 
      Return 
    Gui, FavSearchGUI:Submit
    Gui, FavSearchGUI:Destroy
    WinActivate, ahk_id %favSearchAppHwnd%
    search := SubStr(favSearchChoice, 5)
    EverythingSearch(search)
  return 

  ~Up::  ;  <-- Keys listed here WILL NOT trigger a selection. 
  ~Down:: 
  return

  Esc::  ; <-- Cancel.
  SC055::
    Gui, FavSearchGUI:Destroy
    WinActivate, ahk_id %favSearchAppHwnd%
  return
#if
