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

/*
  ShiftWin combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Win down}<key>{<pos>Win up}{<pos>Shift up}"
*/
ShiftWinCombo(key, pos:="") {
  return ShiftCombo(WinCombo(key, pos), pos) 
}

/*
  ShiftAlt combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Alt down}<key>{<pos>Alt up}{<pos>Shift up}"
*/
ShiftAltCombo(key, pos:="") {
  return ShiftCombo(AltCombo(key, pos), pos) 
}

/*
  ShiftCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Shift up}"
*/
ShiftCtrlCombo(key, pos:="") {
  return ShiftCombo(CtrlCombo(key, pos), pos) 
}

/*
  LShiftLWin combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LWin down}<key>{LWin up}{LShift up}"
*/
LShiftLWinCombo(key) {
  return ShiftCombo(WinCombo(key, "L"), "L")
}

/*
  LShiftLAlt combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LAlt down}<key>{LAlt up}{LShift up}"
*/
LShiftLAltCombo(key) {
  return ShiftCombo(AltCombo(key, "L"), "L")
}

/*
  LShiftLCtrl combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LCtrl down}<key>{LCtrl up}{LShift up}"
*/
LShiftLCtrlCombo(key) {
  return ShiftCombo(CtrlCombo(key, "L"), "L")
}

/*
  RShiftRWin combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RWin down}<key>{RWin up}{RShift up}"
*/
RShiftRWinCombo(key) {
  return ShiftCombo(WinCombo(key, "R"), "R")
}

/*
  RShiftRAlt combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RAlt down}<key>{RAlt up}{RShift up}"
*/
RShiftRAltCombo(key) {
  return ShiftCombo(AltCombo(key, "R"), "R")
}

/*
  RShiftRCtrl combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RCtrl down}<key>{RCtrl up}{RShift up}"
*/
RShiftRCtrlCombo(key) {
  return ShiftCombo(CtrlCombo(key, "R"), "R")
}

/*
  AltCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Alt down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Alt up}"
*/
 AltCtrlCombo(key, pos="") {
  return AltCombo(CtrlCombo(key, pos), pos)
}

/*
  WinAlt combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Win down}{<pos>Alt down}<key>{<pos>Alt up}{<pos>Win up}"
*/
WinAltCombo(key, pos="") {
  return WinCombo(AltCombo(key, pos), pos)
}

/*
  WinCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Win down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Win up}"
*/
WinCtrlCombo(key, pos="") {
  return WinCombo(CtrlCombo(key, pos), pos)
}

/*
  WinAltCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Win down}{<pos>Alt down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Alt up}{<pos>Win up}"
*/
WinAltCtrlCombo(key, pos="") {
  return WinCombo(AltCombo(CtrlCombo(key, pos), pos), pos)
}

/*
  LAltLCtrl combo.
  key -- Key used in the combo.
  return -- "{LAlt down}{LCtrl down}<key>{LCtrl up}{LAlt up}"
*/
LAltLCtrlCombo(key) {
  return AltCombo(CtrlCombo(key, "L"), "L")
}

/*
  LWinLAlt combo.
  key -- Key used in the combo.
  return -- "{LWin down}{LAlt down}<key>{LAlt up}{LWin up}"
*/
LWinLAltCombo(key) {
  return WinCombo(AltCombo(key, "L"), "L")
}

/*
  LWinLCtrl combo.
  key -- Key used in the combo.
  return -- "{LWin down}{LCtrl down}<key>{LCtrl up}{LWin up}"
*/
LWinLCtrlCombo(key) {
  return WinCombo(CtrlCombo(key, "L"), "L")
}

/*
  LWinLAltLCtrl combo.
  key -- Key used in the combo.
  return -- "{LWin down}{LAlt down}{LCtrl down}<key>{LCtrl up}{LAlt up}{LWin up}"
*/
LWinLAltLCtrlCombo(key) {
  return WinCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L")
}

/*
  RAltRCtrl combo.
  key -- Key used in the combo.
  return -- "{RAlt down}{RCtrl down}<key>{RCtrl up}{RAlt up}"
*/
RAltRCtrlCombo(key) {
  return AltCombo(CtrlCombo(key, "R"), "R")
}

/*
  RWinRAlt combo.
  key -- Key used in the combo.
  return -- "{RWin down}{RAlt down}<key>{RAlt up}{RWin up}"
*/
RWinRAltCombo(key) {
  return WinCombo(AltCombo(key, "R"), "R")
}

/*
  RWinRCtrl combo.
  key -- Key used in the combo.
  return -- "{RWin down}{RCtrl down}<key>{RCtrl up}{RWin up}"
*/
RWinRCtrlCombo(key) {
  return WinCombo(CtrlCombo(key, "R"), "R")
}

/*
  RWinRAltRCtrl combo.
  key -- Key used in the combo.
  return -- "{RWin down}{RAlt down}{RCtrl down}<key>{RCtrl up}{RAlt up}{RWin up}"
*/
RWinRAltRCtrlCombo(key) {
  return WinCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R")
}

/*
  ShiftAltCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Alt down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Alt up}{<pos>Shift up}"
*/
ShiftAltCtrlCombo(key, pos="") {
  return ShiftCombo(AltCombo(CtrlCombo(key, pos), pos), pos)
}

/*
  ShiftWinAlt combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Win down}{<pos>Alt down}<key>{<pos>Alt up}{<pos>Win up}{<pos>Shift up}"
*/
ShiftWinAltCombo(key, pos="") {
  return ShiftCombo(WinCombo(AltCombo(key, pos), pos), pos)
}

/*
  ShiftWinCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Win down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Win up}{<pos>Shift up}"
*/
ShiftWinCtrlCombo(key, pos="") {
  return ShiftCombo(WinCombo(CtrlCombo(key, pos), pos), pos)
}

/*
  ShiftWinAltCtrl combo.
  key -- Key used in the combo.
  pos -- Could be "" (default), "L" for a left modifier, or "R" for a right
         modifier.
  return -- "{<pos>Shift down}{<pos>Win down}{<pos>Alt down}{<pos>Ctrl down}<key>{<pos>Ctrl up}{<pos>Alt up}{<pos>Win up}{<pos>Shift up}"
*/
ShiftWinAltCtrlCombo(key, pos="") {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, pos), pos), pos), pos)
}

/*
  LShiftLAltLCtrl combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LAlt down}{LCtrl down}<key>{LCtrl up}{LAlt up}{LShift up}"
*/
LShiftLAltLCtrlCombo(key) {
  return ShiftCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L")
}

/*
  LShiftLWinLAlt combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LWin down}{LAlt down}<key>{LAlt up}{LWin up}{LShift up}"
*/
LShiftLWinLAltCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(key, "L"), "L"), "L")
}

/*
  LShiftLWinLCtrl combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LWin down}{LCtrl down}<key>{LCtrl up}{LWin up}{LShift up}"
*/
LShiftLWinLCtrlCombo(key) {
  return ShiftCombo(WinCombo(CtrlCombo(key, "L"), "L"), "L")
}

/*
  LShiftLWinLAltLCtrl combo.
  key -- Key used in the combo.
  return -- "{LShift down}{LWin down}{LAlt down}{LCtrl down}<key>{LCtrl up}{LAlt up}{LWin up}{LShift up}"
*/
LShiftLWinLAltLCtrlCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, "L"), "L"), "L"), "L")
}

/*
  RShiftRAltRCtrl combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RAlt down}{RCtrl down}<key>{RCtrl up}{RAlt up}{RShift up}"
*/
RShiftRAltRCtrlCombo(key) {
  return ShiftCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R")
}

/*
  RShiftRWinRAlt combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RWin down}{RAlt down}<key>{RAlt up}{RWin up}{RShift up}"
*/
RShiftRWinRAltCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(key, "R"), "R"), "R")
}

/*
  RShiftRWinRCtrl combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RWin down}{RCtrl down}<key>{RCtrl up}{RWin up}{RShift up}"
*/
RShiftRWinRCtrlCombo(key) {
  return ShiftCombo(WinCombo(CtrlCombo(key, "R"), "R"), "R")
}

/*
  RShiftRWinRAltRCtrl combo.
  key -- Key used in the combo.
  return -- "{RShift down}{RWin down}{RAlt down}<key>{RAlt up}{RWin up}{RShift up}"
*/
RShiftRWinRAltRCtrlCombo(key) {
  return ShiftCombo(WinCombo(AltCombo(CtrlCombo(key, "R"), "R"), "R"), "R")
}
