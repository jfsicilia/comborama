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
  ; Choice selected in GUI. 
  global _favSearchChoice := ""
  ; Handler of the Everything window where GUI Listbox was launched.
  global _favSearchAppHwnd := ""
return

/*
  Shows a listbox with all favourite searches to choose from.
  optionsDict -- Dictionary with options to show. Key will be key associated to
                 the favourite search and value is the favourite search string.
*/
ShowFavSearchesListBox(optionsDict) {
  _favSearchAppHwnd := WinExist("A")

  guiOptions := GenGuiOptions(optionsDict)

  Gui, FavSearchGUI:New, -MinimizeBox
  Gui, FavSearchGUI:Add, ListBox, gFavSearchAction v_favSearchChoice W500 R20, %guiOptions%
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
    WinActivate, ahk_id %_favSearchAppHwnd%
    search := SubStr(_favSearchChoice, 5)
    EverythingSearch(search)
  return 

  ~Up::  ;  <-- Keys listed here WILL NOT trigger a selection. 
  ~Down:: 
  return

  Esc::  ; <-- Cancel.
  SC055::
    Gui, FavSearchGUI:Destroy
    WinActivate, ahk_id %_favSearchAppHwnd%
  return
#if
