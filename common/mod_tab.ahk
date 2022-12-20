;
; Tab is used as modifier by creating custom combinations (Tab & <key>:: ...). 
;
TabModifierAutoExec:
return

; This hotkey allows to send tab when tab key is
; released, if no other key was pressed before letting go.
Tab Up:: 
  Send {Blind}{Tab}
return

; This hotkey allows to send shift tab when tab key is
; released (and shift is pressed), if no other key was pressed before 
; letting go.
+Tab Up::
  Send {Blind}{Shift}{Tab}
return 

; Enumarate all possible combos with tab. In this way they won't interfere
; if not set in any script. If any combination is needed, just write them
; in the script in a #if true ... #if statement.
Tab & `::
Tab & -::
Tab & =::
Tab & [::
Tab & ]::
Tab & \::
Tab & `;::
Tab & '::
Tab & ,::
Tab & .::
Tab & /::
Tab & 1::
Tab & 2::
Tab & 3::
Tab & 4::
Tab & 5::
Tab & 6::
Tab & 7::
Tab & 8::
Tab & 9::
Tab & 0::
Tab & a::
Tab & b::
Tab & c::
Tab & d::
Tab & e::
Tab & f::
Tab & g::
Tab & h::
Tab & i::
Tab & j::
Tab & k::
Tab & l::
Tab & m::
Tab & n::
Tab & o::
Tab & p::
Tab & q::
Tab & r::
Tab & s::
Tab & t::
Tab & u::
Tab & v::
Tab & w::
Tab & x::
Tab & y:: 
Tab & z:: 
Tab & SC056::    
Tab & SC055:: 
Tab & space::    
Tab & del::      
Tab & backspace::
Tab & left::     
Tab & down::     
Tab & up::       
Tab & right::    
Tab & F1::       
Tab & F2::       
Tab & F3::       
Tab & F4::       
Tab & F5::       
Tab & F6::       
Tab & F7::       
Tab & F8::       
Tab & F9::       
Tab & F10::      
Tab & F11::      
Tab & F12::      
Tab & ESC::      return
