/*
  This interface enables some key combos to manage cursor movements.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\interface.ahk

CursorInterfaceAutoExec:
  ; Name of interface.
  global __CURSOR_ID__ := "CURSOR_INTERFACE"

  ; Interface's actions.
  global ACTION_LEFT :=             {id: "__left()__",           default: "{left}"}
  global ACTION_SHIFT_LEFT :=       {id: "__shiftLeft()__",      default: "+{left}"}
  global ACTION_RIGHT :=            {id: "__right()__",          default: "{right}"}
  global ACTION_SHIFT_RIGHT :=      {id: "__shiftRight()__",     default: "+{right}"}
  global ACTION_START_LINE :=       {id: "__startLine()__",      default: "{home}"}
  global ACTION_SHIFT_START_LINE := {id: "__shiftStartLine()__", default: "+{home}"}
  global ACTION_END_LINE :=         {id: "__endLine()__",        default: "{end}"}
  global ACTION_SHIFT_END_LINE :=   {id: "__shiftEndLine()__",   default: "+{end}"}
  global ACTION_DOWN :=             {id: "__down()__",           default: "{down}"}
  global ACTION_SHIFT_DOWN :=       {id: "__shiftDown()__",      default: "+{down}"}
  global ACTION_UP :=               {id: "__up()__",             default: "{up}"}
  global ACTION_SHIFT_UP :=         {id: "__shiftUp()__",        default: "+{up}"}
  global ACTION_START_TEXT :=       {id: "__startText()__",      default: "^{home}"}
  global ACTION_SHIFT_START_TEXT := {id: "__shiftStartText()__", default: "+^{home}"}
  global ACTION_END_TEXT :=         {id: "__endText()__",        default: "^{end}"}
  global ACTION_SHIFT_END_TEXT :=   {id: "__shiftEndText()__",   default: "+^{end}"}
  global ACTION_PAGE_UP :=          {id: "__pageUp()__",         default: "{pgup}"}
  global ACTION_SHIFT_PAGE_UP :=    {id: "__shiftPageUp()__",    default: "+{pgup}"}
  global ACTION_PAGE_DOWN :=        {id: "__pageDown()__",       default: "{pgdn}"}
  global ACTION_SHIFT_PAGE_DOWN :=  {id: "__shiftPageDown()__",  default: "+{pgdn}"}
  global ACTION_PREV_WORD :=        {id: "__prevWord()__",       default: "{RCtrl down}{Left}{RCtrl up}"}
  global ACTION_SHIFT_PREV_WORD :=  {id: "__shiftPrevWord()__",  default: "{RCtrl down}+{Left}{RCtrl up}"}
  global ACTION_NEXT_WORD :=        {id: "__nextWord()__",       default: "{RCtrl down}{Right}{RCtrl up}"}
  global ACTION_SHIFT_NEXT_WORD :=  {id: "__shiftNextWord()__",  default: "{RCtrl down}+{Right}{RCtrl up}"}
return

;----------------------------------------------------------------------  
;------------------------ ACTIONS' HOTKEYS ----------------------------  
;----------------------------------------------------------------------  

; Move to left/right or select to left/right
#if (IsActionImplemented(__CURSOR_ID__, ACTION_LEFT.id) && (!altTabLaunched))
  SC055 & h:: ShiftSwitch(bind("RunCursorActionFree", ACTION_LEFT.id)
                        , bind("RunCursorActionFree", ACTION_SHIFT_LEFT.id))
  SC055 & l:: ShiftSwitch(bind("RunCursorActionFree", ACTION_RIGHT.id)
                        , bind("RunCursorActionFree", ACTION_SHIFT_RIGHT.id))
#if

; Move to start/end of line or select to start/end of line.
#if (IsActionImplemented(__CURSOR_ID__, ACTION_START_LINE.id) && (!altTabLaunched))
  <^+left::
  <^left::
  SC055 & left:: ShiftSwitch(bind("RunCursorActionFree", ACTION_START_LINE.id)
                           , bind("RunCursorActionFree", ACTION_SHIFT_START_LINE.id))
  <^+right::
  <^right::
  SC055 & right:: ShiftSwitch(bind("RunCursorActionFree", ACTION_END_LINE.id)
                            , bind("RunCursorActionFree", ACTION_SHIFT_END_LINE.id))
#if

; Move to up/down or select to up/down
#if (IsActionImplemented(__CURSOR_ID__, ACTION_DOWN.id) && (!altTabLaunched))
  SC055 & j:: ShiftSwitch(bind("RunCursorActionFree", ACTION_DOWN.id)
                        , bind("RunCursorActionFree", ACTION_SHIFT_DOWN.id))
  SC055 & k:: ShiftSwitch(bind("RunCursorActionFree", ACTION_UP.id)
                        , bind("RunCursorActionFree", ACTION_SHIFT_UP.id))
#if

; Move to start/end of text or select to start/end of text.
#if (IsActionImplemented(__CURSOR_ID__, ACTION_END_TEXT.id) && (!altTabLaunched))
  SC055 & down:: ShiftSwitch(bind("RunCursorActionFree", ACTION_END_TEXT.id)
                              , bind("RunCursorActionFree", ACTION_SHIFT_END_TEXT.id))
  SC055 & up:: ShiftSwitch(bind("RunCursorActionFree", ACTION_START_TEXT.id)
                            , bind("RunCursorActionFree", ACTION_SHIFT_START_TEXT.id))
#if

; Move to page up/down or select page up/down.
#if (IsActionImplemented(__CURSOR_ID__, ACTION_PAGE_DOWN.id) && (!altTabLaunched))
  SC055 & f:: ShiftSwitch(bind("RunCursorActionFree", ACTION_PAGE_DOWN.id)
                           , bind("RunCursorActionFree", ACTION_SHIFT_PAGE_DOWN.id))
  SC055 & b:: ShiftSwitch(bind("RunCursorActionFree", ACTION_PAGE_UP.id)
                           , bind("RunCursorActionFree", ACTION_SHIFT_PAGE_UP.id))
#if

; Move to next/prev word.
#if (IsActionImplemented(__CURSOR_ID__, ACTION_NEXT_WORD.id) && (!altTabLaunched))
  <!+Left::
  <!Left:: ShiftSwitch(bind("RunCursorActionIsolated", ACTION_PREV_WORD.id)
                     , bind("RunCursorActionIsolated", ACTION_SHIFT_PREV_WORD.id))
  <!+Right::
  <!Right:: ShiftSwitch(bind("RunCursorActionIsolated", ACTION_NEXT_WORD.id)
                      , bind("RunCursorActionIsolated", ACTION_SHIFT_NEXT_WORD.id))
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
ImplementCursorInterface(appsId
  , left                            
  , shiftLeft                       
  , right                           
  , shiftRight                      
  , startLine                       
  , shiftStartLine                  
  , endLine                         
  , shiftEndLine                    
  , down                            
  , shiftDown                       
  , up                              
  , shiftUp                         
  , startText                       
  , shiftStartText                  
  , endText                         
  , shiftEndText                    
  , pageUp                          
  , shiftPageUp                     
  , pageDown                        
  , shiftPageDown
  , prevWord
  , shiftPrevWord
  , nextWord
  , shiftNextWord) {

  app := {}
  app[ACTION_LEFT.id]           
    := (left != DEFAULT_IMPLEMENTATION) ? left : ACTION_LEFT.default
  app[ACTION_SHIFT_LEFT.id]       
    := (shiftLeft != DEFAULT_IMPLEMENTATION) ? shiftLeft : ACTION_SHIFT_LEFT.default
  app[ACTION_RIGHT.id]            
    := (right != DEFAULT_IMPLEMENTATION) ? right : ACTION_RIGHT.default
  app[ACTION_SHIFT_RIGHT.id]     
    := (shiftRight != DEFAULT_IMPLEMENTATION) ? shiftRight : ACTION_SHIFT_RIGHT.default
  app[ACTION_START_LINE.id]       
    := (startLine != DEFAULT_IMPLEMENTATION) ? startLine : ACTION_START_LINE.default
  app[ACTION_SHIFT_START_LINE.id] 
    := (shiftStartLine != DEFAULT_IMPLEMENTATION) ? shiftStartLine : ACTION_SHIFT_START_LINE.default
  app[ACTION_END_LINE.id]        
    := (endLine != DEFAULT_IMPLEMENTATION) ? endLine : ACTION_END_LINE.default
  app[ACTION_SHIFT_END_LINE.id]   
    := (shiftEndLine != DEFAULT_IMPLEMENTATION) ? shiftEndLine : ACTION_SHIFT_END_LINE.default
  app[ACTION_DOWN.id]             
    := (down != DEFAULT_IMPLEMENTATION) ? down : ACTION_DOWN.default
  app[ACTION_SHIFT_DOWN.id]       
    := (shiftDown != DEFAULT_IMPLEMENTATION) ? shiftDown : ACTION_SHIFT_DOWN.default
  app[ACTION_UP.id]               
    := (up != DEFAULT_IMPLEMENTATION) ? up : ACTION_UP.default
  app[ACTION_SHIFT_UP.id]         
    := (shiftUp != DEFAULT_IMPLEMENTATION) ? shiftUp : ACTION_SHIFT_UP.default
  app[ACTION_START_TEXT.id]       
    := (startText != DEFAULT_IMPLEMENTATION) ? startText : ACTION_START_TEXT.default
  app[ACTION_SHIFT_START_TEXT.id] 
    := (shiftStartText != DEFAULT_IMPLEMENTATION) ? shiftStartText : ACTION_SHIFT_START_TEXT.default
  app[ACTION_END_TEXT.id]        
    := (endText != DEFAULT_IMPLEMENTATION) ? endText : ACTION_END_TEXT.default
  app[ACTION_SHIFT_END_TEXT.id]   
    := (shiftEndText != DEFAULT_IMPLEMENTATION) ? shiftEndText  : ACTION_SHIFT_END_TEXT.default
  app[ACTION_PAGE_UP.id]          
    := (pageUp != DEFAULT_IMPLEMENTATION) ? pageUp : ACTION_PAGE_UP.default
  app[ACTION_SHIFT_PAGE_UP.id]    
    := (shiftPageUp != DEFAULT_IMPLEMENTATION) ? shiftPageUp : ACTION_SHIFT_PAGE_UP.default
  app[ACTION_PAGE_DOWN.id]        
    := (pageDown != DEFAULT_IMPLEMENTATION) ? pageDown : ACTION_PAGE_DOWN.default
  app[ACTION_SHIFT_PAGE_DOWN.id]
    := (shiftPageDown != DEFAULT_IMPLEMENTATION) ? shiftPageDown : .default
  app[ACTION_PREV_WORD.id]
    := (prevWord != DEFAULT_IMPLEMENTATION) ?  prevWord :     ACTION_PREV_WORD.default
  app[ACTION_SHIFT_PREV_WORD.id]
    := (shiftPrevWord != DEFAULT_IMPLEMENTATION) ?  shiftPrevWord :     ACTION_SHIFT_PREV_WORD.default
  app[ACTION_NEXT_WORD.id]
    := (nextWord != DEFAULT_IMPLEMENTATION) ?  nextWord :     ACTION_NEXT_WORD.default
  app[ACTION_SHIFT_NEXT_WORD.id]
    := (shiftNextWord != DEFAULT_IMPLEMENTATION) ?  shiftNextWord :     ACTION_SHIFT_NEXT_WORD.default

  ImplementInterface(__CURSOR_ID__, appsId, app)
}

/*
  Default implementation for the interface. See Implement<...>Interface function.
*/
DefaultImplementationCursorInterface(appsId) {
  ImplementCursorInterface(appsId
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION
    , DEFAULT_IMPLEMENTATION)
}

/*
  Run action.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunCursorAction(action, params*) {
  RunInterfaceAction(__CURSOR_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunCursorActionFree(action, params*) {
  RunInterfaceActionFree(__CURSOR_ID__, action, params*)
}

/*
  Run action, freeing modifiers before running it and setting them back after 
  running it.
  action -- Action to run. See Implement<...>Interface function.
  params -- Optional params to pass to the action.
*/
RunCursorActionIsolated(action, params*) {
  RunInterfaceActionIsolated(__CURSOR_ID__, action, params*)
}
 

