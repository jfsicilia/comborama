/*
  This module provides a set of function to create autohotkey combos 
  combining different modifiers.

  @jfsicilia 2022.
*/

/*
  Shift combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}<key>{<pos>Shift up}"
*/
ShiftCombo(key, pos:="") {
  return "{" . pos . "Shift down}" . key . "{" . pos . "Shift up}"
}

/*
  Win combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Win down}<key>{<pos>Win up}"
*/
WinCombo(key, pos:="") {
  return "{" . pos . "Win down}" . key . "{" . pos . "Win up}"
}

/*
  Alt combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Alt down}<key>{<pos>Alt up}"
*/
AltCombo(key, pos:="") {
  return "{" . pos . "Alt down}" . key . "{" . pos . "Alt up}"
}

/*
  Ctrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Ctrl down}<key>{<pos>Ctrl up}"
*/
CtrlCombo(key, pos:="") {
  return "{" . pos . "Ctrl down}" . key . "{" . pos . "Ctrl up}"
}

/*
  LWin combo.
  key -- Key used in the combo.
  return -- "{LWin down}<key>{LWin up}"
*/
LWinCombo(key) {
  return WinCombo(key, "L")
}

/*
  LAlt combo.
  key -- Key used in the combo.
  return -- "{LAlt down}<key>{LAlt up}"
*/
LAltCombo(key) {
  return AltCombo(key, "L")
}

/*
  LCtrl combo.
  key -- Key used in the combo.
  return -- "{LCtrl down}<key>{LCtrl up}"
*/
LCtrlCombo(key) {
  return CtrlCombo(key, "L")
}

/*
  RWin combo.
  key -- Key used in the combo.
  return -- "{RWin down}<key>{RWin up}"
*/
RWinCombo(key) {
  return WinCombo(key, "R")
}

/*
  LAlt combo.
  key -- Key used in the combo.
  return -- "{RAlt down}<key>{RAlt up}"
*/
RAltCombo(key) {
  return AltCombo(key, "R")
}

/*
  RCtrl combo.
  key -- Key used in the combo.
  return -- "{RCtrl down}<key>{RCtrl up}"
*/
RCtrlCombo(key) {
  return CtrlCombo(key, "R")
}

ShiftWinCombo(key, pos:="") {
  return ShiftCombo(WinCombo(key, pos), pos) 
}
ShiftAltCombo(key, pos:="") {
  return ShiftCombo(AltCombo(key, pos), pos) 
}
ShiftCtrlCombo(key, pos:="") {
  return ShiftCombo(CtrlCombo(key, pos), pos) 
}
LShiftLWinCombo(key) {
  return ShiftCombo(WinCombo(key, "L"), "L")
}
LShiftLAltCombo(key) {
  return ShiftCombo(AltCombo(key, "L"), "L")
}
LShiftLCtrlCombo(key) {
  return ShiftCombo(CtrlCombo(key, "L"), "L")
}
RShiftRWinCombo(key) {
  return ShiftCombo(WinCombo(key, "R"), "R")
}
RShiftRAltCombo(key) {
  return ShiftCombo(AltCombo(key, "R"), "R")
}
RShiftRCtrlCombo(key) {
  return ShiftCombo(CtrlCombo(key, "R"), "R")
}

AltCtrlCombo(key, pos:="") {
  return AltCombo(CtrlCombo(key, pos), pos)
}
WinAltCombo(key, pos:="") {
  return WinCombo(AltCombo(key, pos), pos)
}
WinCtrlCombo(key, pos:="") {
  return WinCombo(CtrlCombo(key, pos), pos)
}
WinAltCtrlCombo(key, pos:="") {
  return WinCombo(AltCombo(CtrlCombo(key, pos), pos), pos)
}

LAltLCtrlCombo(key) {
  return AltCombo(CtrlCombo(key, "L"), "L")
}
LWinLAltCombo(key) {
  return WinCombo(AltCombo(key, "L"), "L")
}
LWinLCtrlCombo(key) {
  return WinCombo(CtrlCombo(key, "L"), "L")
}
LWinLAltLCtrlCombo(key) {
  return WinCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L")
}

RAltRCtrlCombo(key) {
  return AltCombo(CtrlCombo(key, "R"), "R")
}
RWinRAltCombo(key) {
  return WinCombo(AltCombo(key, "R"), "R")
}
RWinRCtrlCombo(key) {
  return WinCombo(CtrlCombo(key, "R"), "R")
}
RWinRAltRCtrlCombo(key) {
  return WinCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R")
}

ShiftAltCtrlCombo(key, pos:="") {
  return ShiftCombo(AltCombo(CtrlCombo(key, pos), pos), pos)
}
ShiftWinAltCombo(key, pos:="") {
  return ShiftCombo(WinCombo(AltCombo(key, pos), pos), pos)
}
ShiftWinCtrlCombo(key, pos:="") {
  return ShiftCombo(WinCombo(CtrlCombo(key, pos), pos), pos)
}
ShiftWinAltCtrlCombo(key, pos:="") {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, pos), pos), pos), pos)
}

LShiftLAltLCtrlCombo(key) {
  return ShiftCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L")
}
LShiftLWinLAltCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(key, "L"), "L"), "L")
}
LShiftLWinLCtrlCombo(key) {
  return ShiftCombo(WinCombo(CtrlCombo(key, "L"), "L"), "L")
}
LShiftLWinLAltLCtrlCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L"), "L")
}

RShiftRAltRCtrlCombo(key) {
  return ShiftCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R")
}
RShiftRWinRAltCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(key, "R"), "R"), "R")
}
RShiftRWinRCtrlCombo(key) {
  return ShiftCombo(WinCombo(CtrlCombo(key, "R"), "R"), "R")
}
RShiftRWinRAltRCtrlCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R"), "R")
}


