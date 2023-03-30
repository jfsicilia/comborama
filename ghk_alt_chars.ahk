/*
  This module enables 2 methods to write alternative characters for some
  letters.

  There is a first way using combos like RWin + letter / RWin + Shift + letter / 
  RWin + LWin + letter / RWin + LWin + Shift + letter, to produce an alternative
  characters.

  The second way is optional (can be enabled/disabled at any time, see 
  ToggleAltChars() or ToggleAltCharsWithNotification()), and when it is enabled,
  multiple characters can be written with the same keyboard key, by pressing 
  it more than one time, in a short period of time. On each new stroke an 
  alternative caracter can be get. 

  For example, 'A' key can produce letters a, á, à and â. 
  a is produced with 1 stroke.
  á is produced with 2 strokes.
  à is produced with 3 strokes.
  â is produced with 4 strokes.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_window.ahk

;-----------------------------------------------------------------------------
; If you want to use this file as a module from other, this subroutine must
; be invoked by a GoSub instruction (e.g. GoSub AltCharsAutoExec).
;-----------------------------------------------------------------------------
AltCharsAutoExec:
  ; Enable/Disables _toggleAltChars.
  global _toggleAltChars := ""

  ;a á à â
  global c970:=4, c971:=chr(097), c972:=chr(0225), c973:=chr(0224), c974:=chr(0226)				
  ;A Á À Â
  global c650:=4, c651:=chr(065), c652:=chr(0193), c653:=chr(0192), c654:=chr(0194)				
  ;e é è ê ë
  global c1010:=5, c1011:=chr(0101), c1012:=chr(0233), c1013:=chr(0232), c1014:=chr(0234), c1015:=chr(0235)	
  ;E É È Ê Ë
  global c690:=5, c691:=chr(069), c692:=chr(0201), c693:=chr(0200), c694:=chr(0202), c695:=chr(0203)		
  ;i í î ï
  global c1050:=4, c1051:=chr(0105), c1052:=chr(0237), c1053:=chr(0238), c1054:=chr(0239)			
  ;I Í Î Ï 
  global c730:=4, c731:=chr(073), c732:=chr(205), c733:=chr(0206), c734:=chr(0207)				
  ;o ó ò ô
  global c1110:=4, c1111:=chr(0111), c1112:=chr(0243), c1113:=chr(0242), c1114:=chr(0244)			
  ;O Ó
  global c790:=2, c791:=chr(079), c792:=chr(211)								
  ;u ú ü µ ù û
  global c1170:=6, c1171:=chr(0117), c1172:=chr(0250), c1173:=chr(0x00FC), c1174:=chr(0181), c1175:=chr(0249), c1176:=chr(0251)	
  ;U Ú Ü
  global c850:=3, c851:=chr(085), c852:=chr(218), c853:=chr(0x00DC)								
  ;c ç
  global c990:=2, c991:=chr(099), c992:=chr(0231)								
  ;C Ç
  global c670:=2, c671:=chr(067), c672:=chr(0199)								
  ;n ñ
  global c1100:=2, c1101:=chr(110), c1102:=chr(241)							
  ;N Ñ
  global c780:=2, c781:=chr(078), c782:=chr(209)								
  ;? ¿ 
  global c630:=2, c631:=chr(063), c632:=chr(0191)								
  ;! ¡
  global c330:=2, c331:="{!}", c332:=chr(0161)								
  ;$ € £ ¢ ¥
  global c360:=5, c361:=chr(036), c362:=chr(0x20AC), c363:=chr(0163), c364:=chr(0162), c365:=chr(0165)				
  ;@ © ®
  global c640:=3, c641:=chr(064), c642:=chr(0169), c643:=chr(0174)						
  ;` ° ª º
  global c960:=4, c961:=chr(096), c962:=chr(0176), c963:=chr(0x00AA), c964:=chr(0x00BA)
return

;-----------------------------------------------------------------------------
;                                 Hotkeys
;-----------------------------------------------------------------------------

; Get spanish characters with right window key combos.
>#a:: SendInput(chr(0225))        ; á
>#+a:: SendInput(chr(0193))       ; Á
>#e:: SendInput(chr(0233))        ; é
>#+e:: SendInput(chr(0201))       ; É
>#<#e:: SendInput(chr(0x20AC))    ; €
>#i:: SendInput(chr(0237))        ; í
>#+i:: SendInput(chr(0205))       ; Í
>#o:: SendInput(chr(0243))        ; ó
>#+o:: SendInput(chr(0211))       ; Ó
>#u:: SendInput(chr(0250))        ; ú
>#+u:: SendInput(chr(0218))       ; Ú
>#<#u:: SendInput(chr(0x00FC))    ; ü
>#<#+u:: SendInput(chr(0x00DC))   ; Ü
>#n:: SendInput(chr(0241))        ; ñ
>#+n:: SendInput(chr(0209))       ; Ñ
>#+=:: SendInput(chr(0191))       ; ¿
>#=:: SendInput(chr(0161))        ; ¡
>#+-:: SendInput(chr(0x00AA))     ; ª
>#-:: SendInput(chr(0x00BA))      ; º
>#<#-:: SendInput(chr(0176))      ; °
>#\:: SendInput(chr(0231))        ; ç
>#+\:: SendInput(chr(0199))       ; Ç

; Alternative chars produced by pressing each key multiple times.
#if IsAltCharsEnabled()
  ; ----------------- Accent letters/keys go here. --------------------
  ~a::  
  ~e::	
  ~i::
  ~o::
  ~u::
  ~n::
  ~+A::
  ~+E::
  ~+I::
  ~+O::
  ~+U::
  ~+N::
  ~?::
  ~!::
  ~$::
  ~`:: __DoNTimesKey(substr(a_thisHotKey,0), 100, 300)
  ~@:: ; For '@' and 'c' I prefer slower detection.
  ~c::
  ~+C:: __DoNTimesKey(substr(a_thisHotKey,0), 300, 600)

  ; ---------------- No accent letters/keys go here. ------------------
  ~b::
  ~d::
  ~f::
  ~g::
  ~h::
  ~j::
  ~k::
  ~l::
  ~m::
  ~p::
  ~q::
  ~r::
  ~s::
  ~t::
  ~v::
  ~w::
  ~x::
  ~y::
  ~z::
  ~+B::
  ~+D::
  ~+F::
  ~+G::
  ~+H::
  ~+J::
  ~+K::
  ~+L::
  ~+M::
  ~+P::
  ~+Q::
  ~+R::
  ~+S::
  ~+T::
  ~+V::
  ~+W::
  ~+X::
  ~+Y::
  ~+Z::
  ~1::
  ~2::
  ~3::
  ~4::
  ~5::
  ~6::
  ~7::
  ~8::
  ~9::
  ~0::
  ~-::
  ~=::
  ~[::
  ~]::
  ~\::
  ~/::
  ~*::
  ~#::
  ~%::
  ~;::
  ~'::
  ~,::
  ~.::
  ~right::
  ~down::
  ~left::
  ~up::
  ~bs:: 
  ~space::
  ~Enter:: __DoNTimesKey("")
#if

;-----------------------------------------------------------------------------
;                             Helper functions.
;-----------------------------------------------------------------------------

/* 
  Returns if Alt Chars are enabled.
  return -- True if enabled. False, otherwise.
*/
IsAltCharsEnabled() {
  return _toggleAltChars
}

/*
 Toggle on/off writing with accents.
*/
ToggleAltChars() {
  _toggleAltChars := !_toggleAltChars
}

/*
 Toggle on/off writing with accents.
*/
ToggleAltCharsWithNotification() {
  ToggleAltChars()
  message := _toggleAltChars ? "Alternative chars are ON" : "Alternative chars are OFF"
  ShowTrayTip(message)
}

/*
  Checks if char has been pressed multiple times in a short period of time.

  key -- Char to check.
  minKeyDelay -- The elapsed time between two key-press must be greater than 
                 this time (milisecs) to take it into account.
  maxKeyDelay -- The elapsed time between two key-press must be less than 
                 this time (milisecs) to take it into account.
*/
__DoNTimesKey(key, minKeyDelay=100, maxKeyDelay=300){ ;
	static lastKeyTime := 0
	static lastKey := ""
	static altCharIndex := 0

  if (key != "") {
    elapseKeyTime := a_tickCount - lastKeyTime
    ; Get alternative character if available for current key pressed. Variable 
    ; altCharIndex, will be increased if the same key has been pressed recently.
    charNum := asc(key)
    altCharIndex := altCharIndex >= c%charNum%0 ? 1 : altCharIndex += 1
    altChar := c%charNum%%altCharIndex%
    ; If the key is the same as the last key, there is an alternative
    ; char for the key, and the key has been pressed in the right time, then
    ; remove the last two chars and replace them with the alternative char.
    if (key = lastKey AND altChar != "" AND elapseKeyTime < maxKeyDelay AND elapseKeyTime > minKeyDelay)
      sendInput %  "{bs 2}" altChar
    else ; No alternative char was issued, therefore reset index.
      altCharIndex := 1
  }
	lastKey := key
  lastKeyTime := a_tickCount
} 
