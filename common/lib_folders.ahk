/*
  This library deals with favourite folders in file managers. It holds a 
  dictionary with letters as keys and folders as values. It also provides
  a function to show a dialog window with all the favourite folders, which
  can be selected and the go to.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_apps.ahk

LibFoldersAutoExec:
  ; Default folders.
  EnvGet, userProfile, USERPROFILE
  ; Home and default folder.
  global USER:=A_Username
  global HOME_FOLDER:=userProfile
  global DEFAULT_FOLDER:= HOME_FOLDER . "\_"
  global WSL_HOME_FOLDER:= "\\wsl$\ubuntu\home\" . USER
  global WSL_DEFAULT_FOLDER:= WSL_HOME_FOLDER . "\_"

  ; Dictionary with al favourite folders and it's key shortcut.
  ; Available: a, l, n, q, r, u.
  global FAV_FOLDERS_PATH := ComObjCreate("Scripting.Dictionary")
  FAV_FOLDERS_PATH.item("_") := DEFAULT_FOLDER
  FAV_FOLDERS_PATH.item("<+_") := DEFAULT_FOLDER
  FAV_FOLDERS_PATH.item(">+_") := WSL_DEFAULT_FOLDER

  FAV_FOLDERS_PATH.item("b") := DEFAULT_FOLDER . "\read\books"

  FAV_FOLDERS_PATH.item("c") := DEFAULT_FOLDER . "\inbox\scans"

  FAV_FOLDERS_PATH.item("d") := DEFAULT_FOLDER . "\inbox\downloads"

  FAV_FOLDERS_PATH.item("e") := DEFAULT_FOLDER . "\job\enaire"

  FAV_FOLDERS_PATH.item("f") := DEFAULT_FOLDER . "\image\photo"

  FAV_FOLDERS_PATH.item("g") := "\\192.168.1.10\"

  FAV_FOLDERS_PATH.item("h") := HOME_FOLDER
  FAV_FOLDERS_PATH.item("<+h") := HOME_FOLDER
  FAV_FOLDERS_PATH.item(">+h") := WSL_HOME_FOLDER

  FAV_FOLDERS_PATH.item("i") := DEFAULT_FOLDER . "\inbox"

  FAV_FOLDERS_PATH.item("j") := DEFAULT_FOLDER . "\projects"
  FAV_FOLDERS_PATH.item("<+j") := DEFAULT_FOLDER . "\projects.win"
  FAV_FOLDERS_PATH.item(">+j") := WSL_DEFAULT_FOLDER . "\projects.wsl"

  FAV_FOLDERS_PATH.item("k") := DEFAULT_FOLDER . "\settings\autohotkey\common"

  FAV_FOLDERS_PATH.item("m") := "\\192.168.3.10\"

  FAV_FOLDERS_PATH.item("o") := HOME_FOLDER . "\Pictures\Screenshots"

  FAV_FOLDERS_PATH.item("p") := DEFAULT_FOLDER . "\personal"

  FAV_FOLDERS_PATH.item("r") := DEFAULT_FOLDER . "\resources"

  FAV_FOLDERS_PATH.item("s") := DEFAULT_FOLDER . "\settings"

  FAV_FOLDERS_PATH.item("t") := DEFAULT_FOLDER . "\tmp"
  FAV_FOLDERS_PATH.item("<+t") := DEFAULT_FOLDER . "\tmp"
  FAV_FOLDERS_PATH.item(">+t") := WSL_DEFAULT_FOLDER . "\tmp"

  FAV_FOLDERS_PATH.item("v") := DEFAULT_FOLDER . "\projects\dev"
  FAV_FOLDERS_PATH.item("<+v") := DEFAULT_FOLDER . "\projects.win\dev"
  FAV_FOLDERS_PATH.item(">+v") := WSL_DEFAULT_FOLDER . "\projects.wsl\dev"

  FAV_FOLDERS_PATH.item("x") := DEFAULT_FOLDER . "\cloud\dropbox"

  ; Choice selected in GUI. 
  global _favFolderChoice := ""
  ; Handler of the app window where GUI Listbox was launched.
  global _favFolderAppHwnd := ""
  ; Function to go to folder.
  global _favFolderGoFolderFunc := ""
return

/*
  Shows a listbox with all favourite folders to choose from.
  optionsDict -- Dictionary with options to show. Key will be key associated to
                 the favourite folder and value is the favourite folder path.
  goToFolderFunc -- Function to go to the selected folder.
*/
ShowFavFoldersListBox(optionsDict, goToFolderFunc) {
  _favFolderAppHwnd := WinExist("A")
  _favFolderGoFolderFunc := goToFolderFunc

  guiOptions := GenGuiOptions(optionsDict)

  Gui, FavFolderGUI:New, -MinimizeBox
  Gui, FavFolderGUI:Add, ListBox, gFavFolderAction v_favFolderChoice W500 R30, %guiOptions%
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
    WinActivate, ahk_id %_favFolderAppHwnd%
    _favFolderGoFolderFunc.Call(FAV_FOLDERS_PATH.item(SubStr(_favFolderChoice,1,1)))
  return 

  ~Up::  ;  <-- Keys listed here WILL NOT trigger a selection. 
  ~Down:: 
  return

  Esc::  ; <-- Cancel.
  SC055::
    Gui, FavFolderGUI:Destroy
    WinActivate, ahk_id %_favFolderAppHwnd%
  return
#if

