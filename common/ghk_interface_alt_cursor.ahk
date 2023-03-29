/*
  This interface enables some key combos to manage moving the cursor without
  selecting items (see file_manager).

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

AltCursorInterfaceAutoExec:
  ; Name of interface.
  global __ALT_CURSOR_ID__ := "ALT_CURSOR_INTERFACE"

  ; Interface's actions.
  global ACTION_ALT_LEFT :=        {id: "__altLeft()__",       default: "^{left}"}
  global ACTION_ALT_SHIFT_LEFT :=  {id: "__altShiftLeft()__",  default: "^+{left}"}
  global ACTION_ALT_RIGHT :=       {id: "__altRight()__",      default: "^{right}"}
  global ACTION_ALT_SHIFT_RIGHT := {id: "__altShiftRight()__", default: "^+{right}"}
  global ACTION_ALT_DOWN :=        {id: "__altDown()__",       default: "^{down}"}
  global ACTION_ALT_SHIFT_DOWN :=  {id: "__altShiftDown()__",  default: "^+{down}"}
  global ACTION_ALT_UP :=          {id: "__altUp()__",         default: "^{up}"}
  global ACTION_ALT_SHIFT_UP :=    {id: "__altShiftUp()__",    default: "^+{up}"}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; RCtrl + <key>
;
; Used keys:    _ _ _ _ _ _ _ _ _ _ _ _ _ _
;               _  _ _ _ _ _ _ _ _ _ _ _ _ _ 
;                   _ _ _ _ _ h j k l _ _     
;                    _ _ _ _ _ _ _ _ _ _       
;                                           

; Move to left/right or select to left/right
#if (IsActionImplemented(__ALT_CURSOR_ID__, ACTION_ALT_LEFT.id) && (!altTabLaunched))
  >^h:: ShiftSwitch(bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_LEFT.id)
                  , bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_SHIFT_LEFT.id))
  >^l:: ShiftSwitch(bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_RIGHT.id)
                  , bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_SHIFT_RIGHT.id))
#if

; Move to up/down or select to up/down
#if (IsActionImplemented(__ALT_CURSOR_ID__, ACTION_ALT_DOWN.id) && (!altTabLaunched))
  >^j:: ShiftSwitch(bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_DOWN.id)
                  , bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_SHIFT_DOWN.id))
  >^k:: ShiftSwitch(bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_UP.id)
                  , bind("RunInterfaceActionFree", __ALT_CURSOR_ID__, ACTION_ALT_SHIFT_UP.id))
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
ImplementAltCursorInterface(appsId
  , left                            
  , shiftLeft                       
  , right                           
  , shiftRight                      
  , down                            
  , shiftDown                       
  , up                              
  , shiftUp) {                         

  app := {}
  app[ACTION_ALT_LEFT.id]           
    := (left != DEFAULT_IMPLEMENTATION) ? left : ACTION_ALT_LEFT.default
  app[ACTION_ALT_SHIFT_LEFT.id]       
    := (shiftLeft != DEFAULT_IMPLEMENTATION) ? shiftLeft : ACTION_ALT_SHIFT_LEFT.default
  app[ACTION_ALT_RIGHT.id]            
    := (right != DEFAULT_IMPLEMENTATION) ? right : ACTION_ALT_RIGHT.default
  app[ACTION_ALT_SHIFT_RIGHT.id]     
    := (shiftRight != DEFAULT_IMPLEMENTATION) ? shiftRight : ACTION_ALT_SHIFT_RIGHT.default
  app[ACTION_ALT_DOWN.id]             
    := (down != DEFAULT_IMPLEMENTATION) ? down : ACTION_ALT_DOWN.default
  app[ACTION_ALT_SHIFT_DOWN.id]       
    := (shiftDown != DEFAULT_IMPLEMENTATION) ? shiftDown : ACTION_ALT_SHIFT_DOWN.default
  app[ACTION_ALT_UP.id]               
    := (up != DEFAULT_IMPLEMENTATION) ? up : ACTION_ALT_UP.default
  app[ACTION_ALT_SHIFT_UP.id]         
    := (shiftUp != DEFAULT_IMPLEMENTATION) ? shiftUp : ACTION_ALT_SHIFT_UP.default

  ImplementInterface(__ALT_CURSOR_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationAltCursorInterface(appsId) {
  ImplementAltCursorInterface(appsId
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION 
    , DEFAULT_IMPLEMENTATION)
}

