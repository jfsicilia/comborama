/*
  This interface enables some key combos to manage common operations in a
  file manager.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

FileManagerInterfaceAutoExec:
  ; -------------- To preview files, we use SEER app. --------------

  ; When Seer app (preview/quicklook) opens, it show a window, but the focus
  ; remains in the window behing. This key combo (set in seer settings), allow
  ; to set focus on the Seer app.
  SEER_FOCUS_COMBO := "+#!{F12}"

  ; Open Seer app.
  SEER_OPEN_COMBO := "{space}"

  ; Name of interface.
  global __FILE_MANAGER_ID__ := "FILE_MANAGER_INTERFACE"

  ; Interface's actions.
  global ACTION_PREVIEW :=         {id: "__preview()__", default: SEER_OPEN_COMBO}
  global ACTION_OPEN :=            {id: "__open()__", default: NOT_IMPLEMENTED}
  global ACTION_GO_PARENT :=       {id: "__goParent()__", default: NOT_IMPLEMENTED}
  global ACTION_RENAME :=          {id: "__rename()__", default: NOT_IMPLEMENTED}
  global ACTION_REFRESH :=         {id: "__refresh()__", default: NOT_IMPLEMENTED}
  global ACTION_INFO :=            {id: "__info()__", default: NOT_IMPLEMENTED}
  global ACTION_DUPLICATE :=       {id: "__duplicate()__", default: NOT_IMPLEMENTED}  
  global ACTION_SELECT_ALL :=      {id: "__selectAll()__", default: NOT_IMPLEMENTED} 
  global ACTION_NEW_FILE :=        {id: "__newFile()__", default: NOT_IMPLEMENTED}
  global ACTION_NEW_FOLDER :=      {id: "__newFolder()__", default: NOT_IMPLEMENTED}
  global ACTION_CONTEXT_MENU :=    {id: "__contextMenu()__", default: NOT_IMPLEMENTED}
  global ACTION_VIEW_FILE :=       {id: "__viewFile()__", default: NOT_IMPLEMENTED}
  global ACTION_EDIT_FILE :=       {id: "__editFile()__", default: NOT_IMPLEMENTED}
  global ACTION_EXPLORE_PATH :=    {id: "__explorePath()__", default: NOT_IMPLEMENTED}
  global ACTION_COPY_OTHER_PANE := {id: "__copyOtherPane()__", default: NOT_IMPLEMENTED}
  global ACTION_MOVE_OTHER_PANE := {id: "__moveOtherPane()__", default: NOT_IMPLEMENTED}

return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Capslock + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;              Tab _ _ _ r _ _ _ i o p _ _ \ 
;                   a _ d _ _ _ _ _ _ _ ' enter
;                    _ _ _ _ _ n _ _ _ _
;                          space         app

; Open file/folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_OPEN.id) && (!altTabLaunched))
  SC055 & o:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_OPEN.id) 
#if

; Go to parent folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_GO_PARENT.id) && (!altTabLaunched))
  SC055 & p:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_GO_PARENT.id) 
#if
  
; Rename file/folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_RENAME.id) && (!altTabLaunched))
  SC055 & r:: ShiftSwitch(bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_RENAME.id)
                        , bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_REFRESH.id))
#if

; Get info of file/folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_INFO.id) && (!altTabLaunched))
  SC055 & i:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_INFO.id) 
#if

; Duplicate file/folder. 
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_DUPLICATE.id) && (!altTabLaunched))
  SC055 & d:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_DUPLICATE.id) 
#if

; Select all files/folders.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_SELECT_ALL.id) && (!altTabLaunched))
  SC055 & a:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_SELECT_ALL.id) 
#if

; Create new file or folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_NEW_FILE.id) && (!altTabLaunched))
  SC055 & n:: ShiftSwitch(bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_NEW_FILE.id)
                        , bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_NEW_FOLDER.id))
#if

; Show context menu.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_CONTEXT_MENU.id) && (!altTabLaunched))
  SC055 & SC15D:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_CONTEXT_MENU.id) 
#if

; View file.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_VIEW_FILE.id) && (!altTabLaunched))
  SC055 & ':: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_VIEW_FILE.id) 
#if

; Edit file.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_EDIT_FILE.id) && (!altTabLaunched))
  SC055 & enter:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_EDIT_FILE.id) 
#if

; Explore folder.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_EXPLORE_PATH.id) && (!altTabLaunched))
  SC055 & \:: RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_EXPLORE_PATH.id) 
#if

; Copy other pane.
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_COPY_OTHER_PANE.id) && (!altTabLaunched))
  SC055 & Tab:: ShiftSwitch(bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_COPY_OTHER_PANE.id)
                          , bind("RunInterfaceActionFree", __FILE_MANAGER_ID__, ACTION_MOVE_OTHER_PANE.id))
#if

; Preview file
#if (IsActionImplemented(__FILE_MANAGER_ID__, ACTION_PREVIEW.id) && (!altTabLaunched))
  +space up::
  SC055 & space:: 
    if (!GetKeyState("Shift", "P")) {
      ; Open Seer app, without focusing seer popup window.
      RunInterfaceActionIsolated(__FILE_MANAGER_ID__, ACTION_PREVIEW.id) 
    } else {
      ; Focus Seer app. If already opened set focus on it, if not open it and set
      ; focus.
      SendInputFree(SEER_FOCUS_COMBO)
      sleep, 100
      if (WinActive("ahk_exe Seer.exe"))
        return
      SendInputFree(SEER_OPEN_COMBO)
      sleep, 100
      SendInputFree(SEER_FOCUS_COMBO)
    }
  return
#if

; Manages closing/unfocusing preview popup window.
#if (WinActive("ahk_exe Seer.exe"))
  ; Close Seer window and toggle to the last active window.
  Space::
  SC055::
  ESC:: CloseWindow(), FreeModifiers(), RecentActiveWindow()

  ; Unfocus seer app. 
  SC055 & space:: RecentActiveWindow()
#if

;----------------------------------------------------------------------  
;------------------------ HELPER FUNCTIONS ----------------------------  
;----------------------------------------------------------------------  

/*
  Call this function to implement the interface. 
  appsId -- (String or Array of strings) Name of app/apps that will implement
            this interface. The name of the app could be:
              1) The process name (as the one get by "WinGet, ..., ProcessName, A")
              2) The class name (as the one get by "WinGetClass, ..., A")
              3) ANY_APP_ID constant that will behave as a wildcard for any app.
  actions -- After appsId param, there will be 1 or more params that must be 
             supplied to implement the interface. Each param represents a 
             bound hotkey that when issued and action will be run. Each of 
             these params expects an action to be run. The value of these 
             params could be one of these:
              1) String -- Action will be: SendInput <string>
              2) Function -- Action will be: Function.Call() (Some actions 
                             have parameters so the function to pass must 
                             receive parameters).
              3) DEFAULT_IMPLEMENTATION -- Action will be a string/function 
                                           predefined.
              4) NOT_IMPLEMENTED -- No action will be run.
*/
ImplementFileManagerInterface(appsId
  , preview                 ; Prefiew file/folder
  , open                    ; Open file/folder
  , goParent                ; Go parent folder
  , rename                  ; Rename file/folder
  , refresh                 ; Refresh file manager.
  , info                    ; Show info of file/folder
  , duplicate               ; Duplicate file/folder
  , selectAll               ; Select all files/folders
  , newFile                 ; New file
  , newFolder               ; New folder
  , contextMenu             ; Context menu
  , viewFile                ; View file
  , editFile                ; Edit file
  , explorePath             ; Explore path
  , copyOtherPane           ; Copy to other pane
  , moveOtherPane) {        ; Move to other pane

  app := {}
  app[ACTION_PREVIEW.id]       
    := (preview != DEFAULT_IMPLEMENTATION) ? preview : ACTION_PREVIEW.default
  app[ACTION_OPEN.id]      
    := (open != DEFAULT_IMPLEMENTATION) ? open : ACTION_OPEN.default
  app[ACTION_GO_PARENT.id]     
    := (goParent != DEFAULT_IMPLEMENTATION) ? goParent : ACTION_GO_PARENT.default
  app[ACTION_RENAME.id]       
    := (rename != DEFAULT_IMPLEMENTATION) ? rename : ACTION_RENAME.default
  app[ACTION_REFRESH.id]       
    := (refresh != DEFAULT_IMPLEMENTATION) ? refresh : ACTION_REFRESH.default
  app[ACTION_INFO.id] 
    := (info != DEFAULT_IMPLEMENTATION) ? info : ACTION_INFO.default
  app[ACTION_DUPLICATE.id] 
    := (duplicate != DEFAULT_IMPLEMENTATION) ? duplicate : ACTION_DUPLICATE.default
  app[ACTION_SELECT_ALL.id] 
    := (selectAll != DEFAULT_IMPLEMENTATION) ? selectAll : ACTION_SELECT_ALL.default
  app[ACTION_NEW_FILE.id]  
    := (newFile != DEFAULT_IMPLEMENTATION) ? newFile : ACTION_NEW_FILE.default
  app[ACTION_NEW_FOLDER.id] 
    := (newFolder != DEFAULT_IMPLEMENTATION) ? newFolder : ACTION_NEW_FOLDER.default
  app[ACTION_CONTEXT_MENU.id]
    := (contextMenu != DEFAULT_IMPLEMENTATION) ? contextMenu : .default
  app[ACTION_VIEW_FILE.id]
    := (viewFile != DEFAULT_IMPLEMENTATION) ? viewFile : ACTION_VIEW_FILE.default
  app[ACTION_EDIT_FILE.id]
    := (editFile != DEFAULT_IMPLEMENTATION) ? editFile : ACTION_EDIT_FILE.default
  app[ACTION_EXPLORE_PATH.id]
    := (explorePath != DEFAULT_IMPLEMENTATION) ? explorePath : .default
  app[ACTION_COPY_OTHER_PANE.id]
    := (copyOtherPane != DEFAULT_IMPLEMENTATION) ? copyOtherPane : ACTION_COPY_OTHER_PANE.default
  app[ACTION_MOVE_OTHER_PANE.id]
    := (moveOtherPane != DEFAULT_IMPLEMENTATION) ? moveOtherPane : ACTION_MOVE_OTHER_PANE.default

  ImplementInterface(__FILE_MANAGER_ID__, appsId, app)
}

