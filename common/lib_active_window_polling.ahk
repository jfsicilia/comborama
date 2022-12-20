/*
  This module sets a timer to check periodically if the active window has 
  changed. If so and callback functions have been registered, those will
  be called whenever a change in the active window is detected.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_desktop.ahk

LibActiveWindowPollingAutoExec:
  ; Array with functions to call if active window has changed. Functions will
  ; be called with two paramenters: active and previous. Each of this 
  ; parameters is an object with the following properties:
  ;     hwnd - Window handler.
  ;     maximized - If window is maximized (boolean).
  ;     x - X position of window.
  ;     y - Y position of window.
  ;     w - Width of the window.
  ;     h - Height of the window.
  ;     desktop - Desktop where the window is.
  ;     monitor - Monitor where the window is. 
  ; Active object will have the data for the current active window, and Previous 
  ; will hold the data for the former active window (before the change was 
  ; detected). 
  _callbacks := []

  ; Saves current active window data.
  _active := [] 
  _active.x := -1, _active.y := -1, _active.w := -1, _active.h := -1
  _active.hwnd := -1, _active.desktop := -1, _active.monitor := -1

  ; Saves previous active window data.
  _prev := []
  _prev.x := -1, _prev.y := -1, _prev.w := -1, _prev.h := -1
  _prev.hwnd := -1, _prev.desktop := -1, _prev.monitor := -1

  ; Set a timer to call CheckActiveWindow subroutine periodically.
  SetTimer, CheckActiveWindow, 100
return

; Subroutine invoked by a timer periodically, to check active window changes.
CheckActiveWindow:
  ; Sanity checks
  WinGetPos, x, y, w, h, A
  if (x = "")
    return

  WinGet, hwnd, ID, A
  desktop := GetDesktop()
  monitor := GetMonitor()

  ; If nothing has changed, exit.
  if ((_active.hwnd = hwnd) 
    AND (_active.x = x) AND (_active.y = y) 
    AND (_active.w = w) AND (_active.h = h) 
    AND (_active.desktop = desktop) AND (_active.monitor = monitor))
    return

  ; Save previous active window data.
  _prev.x := _active.x, _prev.y := _active.y
  _prev.w := _active.w, _prev.h := _active.h
  _prev.hwnd := _active.hwnd, _prev.maximized := _active.maximized
  _prev.desktop := _active.desktop, _prev.monitor := _active.monitor

  ; Update active window data.
  WinGet, maximized, MinMax, A
  _active.x := x, _active.y := y, _active.w := w, _active.h := h 
  _active.hwnd := hwnd, _active.maximized := maximized
  _active.desktop := desktop, _active.monitor := monitor

  ; Call all registered callback functions with new data.
  for i, f in _callbacks 
    f.Call(_active, _prev)
return

/*
  Registers a function callback. This callback function will be called 
  whenever there is a change in the active window. The properties of the 
  window that will be monitored are: x position, y position, width, height, 
  desktop, monitor and the window handler. The function must have 2
  parameters: active and previous. Each of this parameters is an object with 
  the following properties:
      hwnd - Window handler.
      maximized - If window is maximized (boolean).
      x - X position of window.
      y - Y position of window.
      w - Width of the window.
      h - Height of the window.
      desktop - Desktop where the window is.
      monitor - Monitor where the window is. 
  Active object will have the data for the current active window, and Previous 
  will hold the data for the former active window (before the change was 
  detected). 
*/
RegisterActiveWindowChangedCallback(callback) {
  global _callbacks
  if (_callbacks = "")
    return false
  _callbacks.Push(callback)
  return true
}
