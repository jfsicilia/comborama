/*
  Remap CapsLock to behave like ESC when pressed alone. If pressed in combination
  with another key, new functionality can be defined. In this script, functionality
  for Vim like apps has been defined. In this environment a Capslock + <key> combo
  is translated to a RCtrl + <key>. Instead of using CTRL, it will send right CTRL,
  this allows to have another behaviour with left CTRL if needed (simulate CMD 
  key for example).
*/

; If this hotkey is detected, it means that the capslock key was pressed alone,
; therefore a ESC is sent.
SC055::
  Send {Blind}{Esc}
return


; Enumarate all possible combos with capslock. By default it will behave like
; a Ctrl combo. In this way they won't interfere if not set in any script. 
; If any combination is needed, just write them in the script in a 
; #if ... #if statement.
SC055 & `::          ^`
SC055 & -::          ^-
SC055 & =::          ^=
SC055 & [::          ^[
SC055 & ]::          ^]
SC055 & \::          ^\
SC055 & `;::         ^;
SC055 & '::          ^'
SC055 & ,::          ^,
SC055 & .::          ^.
SC055 & /::          ^/
SC055 & 1::          ^1
SC055 & 2::          ^2
SC055 & 3::          ^3
SC055 & 4::          ^4
SC055 & 5::          ^5
SC055 & 6::          ^6
SC055 & 7::          ^7
SC055 & 8::          ^8
SC055 & 9::          ^9
SC055 & 0::          ^0
SC055 & a::          ^a
SC055 & b::          ^b
SC055 & c::          ^c
SC055 & d::          ^d
SC055 & e::          ^e
SC055 & f::          ^f
SC055 & g::          ^g
SC055 & h::          ^h
SC055 & i::          ^i
SC055 & j::          ^j
SC055 & k::          ^k
SC055 & l::          ^l
SC055 & m::          ^m
SC055 & n::          ^n
SC055 & o::          ^o
SC055 & p::          ^p
SC055 & q::          ^q
SC055 & r::          ^r
SC055 & s::          ^s 
SC055 & t::          ^t
SC055 & u::          ^u
SC055 & v::          ^v
SC055 & w::          ^w
SC055 & x::          ^x
SC055 & y::          ^y
SC055 & z::          ^z
SC055 & SC056::      send, ^{RWin} 
SC055 & Tab::        send, ^{Tab}
SC055 & space::      send, ^{space}
SC055 & del::        send, ^{del}
SC055 & backspace::  send, ^{backspace}
SC055 & left::       send, ^{left}
SC055 & down::       send, ^{down}
SC055 & up::         send, ^{up}
SC055 & right::      send, ^{right}
SC055 & F1::         send, ^{F1}
SC055 & F2::         send, ^{F2}
SC055 & F3::         send, ^{F3}
SC055 & F4::         send, ^{F4}
SC055 & F5::         send, ^{F5}
SC055 & F6::         send, ^{F6}
SC055 & F7::         send, ^{F7}
SC055 & F8::         send, ^{F8}
SC055 & F9::         send, ^{F9}
SC055 & F10::        send, ^{F10}
SC055 & F11::        send, ^{F11}
SC055 & F12::        send, ^{F12}
SC055 & ESC::        send, ^{ESC}
SC055 & PrintScreen::send, ^{PrintScreen}
; TODO Check if this interferes with something
LCtrl & SC055::      return
LWin & SC055::       return
LAlt & SC055::       return
RCtrl & SC055::      return
RWin & SC055::       return
RAlt & SC055::       return
RShift & SC055::     return
LShift & SC055::     return


