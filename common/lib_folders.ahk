#include %A_ScriptDir%\lib_apps.ahk

; Script that deals with favourite folders in File Explorer. It bounds some
; key combos to the folders and it also allows to show a GUI ListBox to 
; select it from there.
LibFoldersAutoExec:
  ; Default folders.
  EnvGet, userProfile, USERPROFILE
  global USER:=A_Username
  global HOME_FOLDER:=userProfile
  global DEFAULT_FOLDER:= HOME_FOLDER . "\_"

  ; Dictionary with al favourite folders and it's key shortcut.
  global FAV_FOLDERS_PATH := {"_":DEFAULT_FOLDER
                            , "b":DEFAULT_FOLDER . "\read\books"
                            , "c":DEFAULT_FOLDER . "\inbox\scans"
                            , "d":DEFAULT_FOLDER . "\inbox\downloads"
                            , "e":DEFAULT_FOLDER . "\job\enaire"
                            , "f":DEFAULT_FOLDER . "\image\photo"
                            , "g":"\\192.168.1.10\"
                            , "h":HOME_FOLDER
                            , "i":DEFAULT_FOLDER . "\inbox"
                            , "j":DEFAULT_FOLDER . "\projects"
                            , "k":DEFAULT_FOLDER . "\settings\autohotkey\common"
                            , "m":"\\192.168.3.10\"
                            , "o":HOME_FOLDER . "\Pictures\Screenshots"
                            , "p":DEFAULT_FOLDER . "\personal"
                            , "s":DEFAULT_FOLDER . "\settings"
                            , "t":DEFAULT_FOLDER . "\tmp"
                            , "w":"\\wsl$\ubuntu\home\" . A_UserName . "\_"
                            , "x":DEFAULT_FOLDER . "\cloud\dropbox"}

  ; String with all favourite folders ready for Gui Add Listbox option.
  global FAV_FOLDERS_GUI_OPTIONS := ""
  sep := ""
  for key, value in FAV_FOLDERS_PATH {
    FAV_FOLDERS_GUI_OPTIONS .= sep . key . " - " . value
    sep := "|"
  }

  ; Choice selected in GUI. 
  global favFolderChoice := ""
  ; Handler of the app window where GUI Listbox was launched.
  global favFolderAppHwnd := ""
  ; Function to go to folder.
  global favFolderGoFolderFunc := ""
return

/*
  Shows a listbox with all favourite folders to choose from.
*/
ShowFavFoldersListBox(goToFolderFunc) {
  favFolderAppHwnd := WinExist("A")
  favFolderGoFolderFunc := goToFolderFunc

  Gui, FavFolderGUI:New, -MinimizeBox
  Gui, FavFolderGUI:Add, ListBox, gFavFolderAction vfavFolderChoice W500 R20, %FAV_FOLDERS_GUI_OPTIONS%
  Gui, FavFolderGUI:Show,, Choose_folder
}

; Deals with listbox.
#if WinActive("Choose_folder ahk_class AutoHotkeyGUI")
  Enter::  ;  <-- Keys listed here WILL trigger a selection. 
    Sleep, 100 
  FavFolderAction: 
    if A_TimeSinceThisHotkey between 0 and 99 
      Return 
    Gui, FavFolderGUI:Submit
    Gui, FavFolderGUI:Destroy
    WinActivate, ahk_id %favFolderAppHwnd%
    favFolderGoFolderFunc.Call(FAV_FOLDERS_PATH[SubStr(favFolderChoice,1,1)])
  return 

  ~Up::  ;  <-- Keys listed here WILL NOT trigger a selection. 
  ~Down:: 
  return

  Esc::  ; <-- Cancel.
  SC055::
    Gui, FavFolderGUI:Destroy
    WinActivate, ahk_id %favFolderAppHwnd%
  return
#if

