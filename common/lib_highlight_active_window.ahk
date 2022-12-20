#include %A_ScriptDir%\lib_active_window_polling.ahk

LibHighlightActiveWindowAutoExec:
  ; Window border properties.
  BORDER_THICKNESS := 4
  BORDER_COLOR := "FF0000"

  ; Flag that configs if a window border hightlight is draw or not.
  _highlightWindow := false

  ; 2022/08/13 -- On Windows 11, there is an option to accent the active
  ; window, therefore __HighlightWindowCallback is deprecated.

  ; Register function to be called when active window changes.
  RegisterActiveWindowChangedCallback(Func("__HighlightWindowCallback"))
return

/*
  Highlights the active window by drawing a rectangle in the outer border,
  only if the window is not maximized.
*/
__HighlightWindowCallback(active, prev) {
  global BORDER_THICKNESS, BORDER_COLOR, _highlightWindow
  x := active.x, y :=active.y, w :=active.w, h :=active.h 
  maximized := active.maximized

  if ((maximized) OR (!_highlightWindow)) {
;    WinSet, Region, 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 0-0 
;    Try {
;      Gui, Show, w0 h0 x0 y0 NoActivate, Highlight rectangle off
      Gui, Destroy
;    }
    return
  }

  Gui, +Lastfound +AlwaysOnTop +Toolwindow
  iw:= w - BORDER_THICKNESS 
  ih:= h - BORDER_THICKNESS
  Gui, Color, %BORDER_COLOR%
  Gui, -Caption

  ; outer rectangle
  o1x := 0, o1y := 0
  o2x := w, o2y := 0 
  o3x := w, o3y := h 
  o4x := 0, o4y := h 
  o5x := 0, o5y := 0

  ; inner rectangle
  i1x := BORDER_THICKNESS, i1y := BORDER_THICKNESS
  i2x := iw,               i2y := BORDER_THICKNESS
  i3x := iw,               i3y := ih
  i4x := BORDER_THICKNESS, i4y := ih
  i5x := BORDER_THICKNESS, i5y := BORDER_THICKNESS

  ; Draw outer & inner window(s)
  ; It creates a see-through rectangular hole inside. There are two 
  ; rectangles specified below: an outer and an inner. Each rectangle 
  ; consists of 5 pairs of X/Y coordinates because the first pair is 
  ; repeated at the end to "close off" each rectangle.
  WinSet, Region, %o1x%-%o1y% %o2x%-%o2y% %o3x%-%o3y% %o4x%-%o4y% %o5x%-%o5y%   %i1x%-%i1y% %i2x%-%i2y% %i3x%-%i3y% %i4x%-%i4y% %i5x%-%i5y%
  Try {
    Gui, Show, w%w% h%h% x%x% y%y% NoActivate, Highlight rectangle on
  }
}

/*
  Toggles window highlighting
  Returns true if highlight window is on. False otherwise.
*/
ToggleHighlightWindow() {
  global _highlightWindow
  _highlightWindow := !_highlightWindow
  ; Force window update by minimizing and restoring the active window.
  hwnd := WinExist("A")
  WinMinimize, % "ahk_id " . hwnd 
  WinRestore, % "ahk_id " . hwnd 
  return _highlightWindow
}
