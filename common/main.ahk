; TODO FileExplorer -- Non selecting file navigation.
;                      Seer.
; TODO windowterminal -- Check why SC055 combo T and W doesn't work.
; TODO apps -- Remove SC055 + LWin to navigate tabs.
; TODO desktop -- Install Seer.
;              -- Change task scheduler.
;              -- Test dll for desktop manipulation.

; This script is a launcher of many other scripts.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force

#Warn All  ; Enable warnings to assist with detecting common errors.
#Warn LocalSameAsGlobal, Off
;#Warn UseUnsetGlobal, Off

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.

SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, 3

SetCapsLockState, AlwaysOff 

ShowProgressText("AHK Start loading...", 500)

; Logging global object.
;global LOG := new LogClass("_main_")
;LOG.initalizeNewLogFile(true, "Logging...`n")

; Load autoexec code needed by some scripts.
GoSub InterfaceAutoExec
GoSub LibActiveWindowPollingAutoExec
GoSub LibMiscAutoExec
GoSub LibDesktopAutoExec
GoSub LibWindowAutoExec
GoSub LibMonitorAutoExec
; NOTE: LibHighlightActiveWindowAutoExec must be run before LibGridAutoExec
; to register callbacks in correct order.
GoSub LibHighlightActiveWindowAutoExec
GoSub LibGridAutoExec
GoSub LibAppsAutoExec
GoSub EditInterfaceAutoExec
GoSub TabsInterfaceAutoExec
GoSub PanesInterfaceAutoExec
GoSub HistoryInterfaceAutoExec
GoSub AddressInterfaceAutoExec
GoSub FavsInterfaceAutoExec
GoSub CursorInterfaceAutoExec
GoSub AltCursorInterfaceAutoExec
GoSub FileManagerInterfaceAutoExec
GoSub TerminalInterfaceAutoExec
GoSub OpenWithInterfaceAutoExec
GoSub SeekAndSelInterfaceAutoExec
GoSub SettingsInterfaceAutoExec
GoSub MiscAutoExec
GoSub WindowAutoExec
;GoSub FileManagerAutoExe
GoSub FileExplorerAutoExec
GoSub GVimAutoExec
GoSub VSCodeAutoExec
GoSub WindowsTerminalAutoExec
GoSub EverythingAutoExec
GoSub OneCmdrAutoExec
GoSub LibFoldersAutoExec
GoSub LibSearchesAutoExec
GoSub ChromeAutoExec
GoSub EdgeAutoExec
GoSub FirefoxAutoExec
GoSub BraveAutoExec
GoSub JoplinAutoExec
GoSub AltCharsAutoExec
GoSub TabModifierAutoExec

; Load default implementations of interfaces 
DefaultImplementationCursorInterface(ANY_APP_ID)
DefaultImplementationEditInterface(ANY_APP_ID)

ShowProgressText("AHK Scripts loaded!", 500)

; Libraries.
#include %A_ScriptDir%\lib_log.ahk
#include %A_ScriptDir%\lib_active_window_polling.ahk
; Modifiers.
; mod_great_less.ahk Converts the spanish "< >" key in a modifier (SC053 code).
; NOTE: If this script is loaded here it interferes with other modifiers, therefore
; it must be run independently (best option run it at login with task scheduler).
; #include %A_ScriptDir%\mod_great_less.ahk
#include %A_ScriptDir%\mod_capslock.ahk
#include %A_ScriptDir%\mod_tab.ahk
; Global hotkeys (interfaces).
#include %A_ScriptDir%\ghk_interface_edit.ahk
#include %A_ScriptDir%\ghk_interface_tabs.ahk
#include %A_ScriptDir%\ghk_interface_panes.ahk
#include %A_ScriptDir%\ghk_interface_history.ahk
#include %A_ScriptDir%\ghk_interface_address.ahk
#include %A_ScriptDir%\ghk_interface_favs.ahk
#include %A_ScriptDir%\ghk_interface_cursor.ahk
#include %A_ScriptDir%\ghk_interface_alt_cursor.ahk
#include %A_ScriptDir%\ghk_interface_file_manager.ahk
#include %A_ScriptDir%\ghk_interface_open_with.ahk
#include %A_ScriptDir%\ghk_interface_terminal.ahk
#include %A_ScriptDir%\ghk_interface_seek_n_sel.ahk
#include %A_ScriptDir%\ghk_interface_settings.ahk
; Global hotkeys.
#include %A_ScriptDir%\ghk_disable_windows_combos.ahk
#include %A_ScriptDir%\ghk_misc.ahk
#include %A_ScriptDir%\ghk_alt_chars.ahk
#include %A_ScriptDir%\ghk_window.ahk
#include %A_ScriptDir%\ghk_desktop.ahk
#include %A_ScriptDir%\ghk_monitor.ahk
#include %A_ScriptDir%\ghk_grid.ahk
#include %A_ScriptDir%\ghk_help.ahk
#include %A_ScriptDir%\ghk_fav_apps.ahk
#include %A_ScriptDir%\ghk_debug.ahk
;#include %A_ScriptDir%\ghk_file_manager.ahk
;#include %A_ScriptDir%\ghk_text_edit.ahk
; Apps hotkeys.
#include %A_ScriptDir%\hk_vscode.ahk
#include %A_ScriptDir%\hk_file_explorer.ahk
#include %A_ScriptDir%\hk_everything.ahk
#include %A_ScriptDir%\hk_onecommander.ahk
#include %A_ScriptDir%\hk_chrome.ahk
#include %A_ScriptDir%\hk_firefox.ahk
#include %A_ScriptDir%\hk_edge.ahk
#include %A_ScriptDir%\hk_brave.ahk
#include %A_ScriptDir%\hk_joplin.ahk
#include %A_ScriptDir%\hk_gvim.ahk
#include %A_ScriptDir%\hk_windows_terminal.ahk
; Hotstrings.
#include %A_ScriptDir%\hs_misc.ahk

;#include %A_ScriptDir%\..\gcts\captura_vacaciones.ahk


