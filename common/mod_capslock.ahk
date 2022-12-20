/*
  NOTE: I have used sharpkeys to make the Capslock key issue the scan code 055 
  (SC055) to avoid dealing with some misbehaviours that led the Capslock 
  leaving "shift state on" when used as a modifier. Therefore the physical
  Capslock key will be treated in the scripts as the SC055 key.

  The SC055 key will be used as ESC when pressed alone, and as a modifier
  when pressed with another key.

  By default, the SC055 + <key> combo is translated to Ctrl + <key>. This 
  behaviour could be changed in other scripts, just redefining the 
  SC055 + <key> combo inside a #if ... #if statement.
*/

; If this hotkey is detected, it means that the SC055 key was pressed alone,
; therefore a ESC is sent.
SC055::
  Send {Blind}{Esc}
return


; Enumarate all possible combos with SC055. By default it will behave like
; a RCtrl combo. In this way they won't interfere if not set in any script. 
; If any combination is needed, just write them in the script in a 
; #if ... #if statement.
SC055 & `::          sendinput, {RCtrl down}`{RCtrl up}
SC055 & -::          sendinput, {RCtrl down}-{RCtrl up}
SC055 & =::          sendinput, {RCtrl down}={RCtrl up}
SC055 & [::          sendinput, {RCtrl down}[{RCtrl up}
SC055 & ]::          sendinput, {RCtrl down}]{RCtrl up}
SC055 & \::          sendinput, {RCtrl down}\{RCtrl up}
SC055 & `;::         sendinput, {RCtrl down};{RCtrl up}
SC055 & '::          sendinput, {RCtrl down}'{RCtrl up}
SC055 & ,::          sendinput, {RCtrl down},{RCtrl up}
SC055 & .::          sendinput, {RCtrl down}.{RCtrl up}
SC055 & /::          sendinput, {RCtrl down}/{RCtrl up}
SC055 & 1::          sendinput, {RCtrl down}1{RCtrl up}
SC055 & 2::          sendinput, {RCtrl down}2{RCtrl up}
SC055 & 3::          sendinput, {RCtrl down}3{RCtrl up}
SC055 & 4::          sendinput, {RCtrl down}4{RCtrl up}
SC055 & 5::          sendinput, {RCtrl down}5{RCtrl up}
SC055 & 6::          sendinput, {RCtrl down}6{RCtrl up}
SC055 & 7::          sendinput, {RCtrl down}7{RCtrl up}
SC055 & 8::          sendinput, {RCtrl down}8{RCtrl up}
SC055 & 9::          sendinput, {RCtrl down}9{RCtrl up}
SC055 & 0::          sendinput, {RCtrl down}0{RCtrl up}
SC055 & a::          sendinput, {RCtrl down}a{RCtrl up}
SC055 & b::          sendinput, {RCtrl down}b{RCtrl up}
SC055 & c::          sendinput, {RCtrl down}c{RCtrl up}
SC055 & d::          sendinput, {RCtrl down}d{RCtrl up}
SC055 & e::          sendinput, {RCtrl down}e{RCtrl up}
SC055 & f::          sendinput, {RCtrl down}f{RCtrl up}
SC055 & g::          sendinput, {RCtrl down}g{RCtrl up}
SC055 & h::          sendinput, {RCtrl down}h{RCtrl up}
SC055 & i::          sendinput, {RCtrl down}i{RCtrl up}
SC055 & j::          sendinput, {RCtrl down}j{RCtrl up}
SC055 & k::          sendinput, {RCtrl down}k{RCtrl up}
SC055 & l::          sendinput, {RCtrl down}l{RCtrl up}
SC055 & m::          sendinput, {RCtrl down}m{RCtrl up}
SC055 & n::          sendinput, {RCtrl down}n{RCtrl up}
SC055 & o::          sendinput, {RCtrl down}o{RCtrl up}
SC055 & p::          sendinput, {RCtrl down}p{RCtrl up}
SC055 & q::          sendinput, {RCtrl down}q{RCtrl up}
SC055 & r::          sendinput, {RCtrl down}r{RCtrl up}
SC055 & s::          sendinput, {RCtrl down}s{RCtrl up} 
SC055 & t::          sendinput, {RCtrl down}t{RCtrl up}
SC055 & u::          sendinput, {RCtrl down}u{RCtrl up}
SC055 & v::          sendinput, {RCtrl down}v{RCtrl up}
SC055 & w::          sendinput, {RCtrl down}w{RCtrl up}
SC055 & x::          sendinput, {RCtrl down}x{RCtrl up}
SC055 & y::          sendinput, {RCtrl down}y{RCtrl up}
SC055 & z::          sendinput, {RCtrl down}z{RCtrl up}
SC055 & SC056::      sendinput, {RCtrl down}{RWin}{RCtrl up}
SC055 & Tab::        sendinput, {RCtrl down}{Tab}{RCtrl up}
SC055 & space::      sendinput, {RCtrl down}{space}{RCtrl up}
SC055 & del::        sendinput, {RCtrl down}{del}{RCtrl up}
SC055 & backspace::  sendinput, {RCtrl down}{backspace}{RCtrl up}
SC055 & left::       sendinput, {RCtrl down}{left}{RCtrl up}
SC055 & down::       sendinput, {RCtrl down}{down}{RCtrl up}
SC055 & up::         sendinput, {RCtrl down}{up}{RCtrl up}
SC055 & right::      sendinput, {RCtrl down}{right}{RCtrl up}
SC055 & F1::         sendinput, {RCtrl down}{F1}{RCtrl up}
SC055 & F2::         sendinput, {RCtrl down}{F2}{RCtrl up}
SC055 & F3::         sendinput, {RCtrl down}{F3}{RCtrl up}
SC055 & F4::         sendinput, {RCtrl down}{F4}{RCtrl up}
SC055 & F5::         sendinput, {RCtrl down}{F5}{RCtrl up}
SC055 & F6::         sendinput, {RCtrl down}{F6}{RCtrl up}
SC055 & F7::         sendinput, {RCtrl down}{F7}{RCtrl up}
SC055 & F8::         sendinput, {RCtrl down}{F8}{RCtrl up}
SC055 & F9::         sendinput, {RCtrl down}{F9}{RCtrl up}
SC055 & F10::        sendinput, {RCtrl down}{F10}{RCtrl up}
SC055 & F11::        sendinput, {RCtrl down}{F11}{RCtrl up}
SC055 & F12::        sendinput, {RCtrl down}{F12}{RCtrl up}
SC055 & ESC::        sendinput, {RCtrl down}{ESC}{RCtrl up}
SC055 & PrintScreen::sendinput, {RCtrl down}{PrintScreen}{RCtrl up}
