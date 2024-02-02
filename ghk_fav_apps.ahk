/*
  This module allow to access favourite apps with a key combo.

  @jfsicilia 2022.
*/
#include %A_ScriptDir%\lib_apps.ahk

;-----------------------------------------------------------------------------
;                                 Hotkeys
;-----------------------------------------------------------------------------

; Still available keys: A hH iI J K lL M N O p qQ rR uU x Y Z

; ------ 'a'tani ------
>!a:: FocusOrLaunchAtani()
; ------ 'b'rave ------
>!b:: FocusOrLaunchBrave()
; ------ 'B'lender ------
>!+b:: FocusOrLaunchBlender()
; ------ Visual Studio 'c'ode ------
>!c:: FocusOrLaunchVSCode()
; ------ 'C'ura -------
>!+c:: FocusOrLaunchCura()
; ------ 'd'iscord -------
>!d:: FocusOrLaunchDiscord()
; ------ Affinity 'D'esigner -------
>!+d:: FocusOrLaunchAffinityDesigner()
; ----- File 'e'xplorer -----
>!e:: FocusOrLaunchFileExplorer()
$<#e::
  ; Open file explorer with winkey+E, then goto to default folder.
  Send, <#e
  WinWait, ahk_class ExploreWClass,,3
  FileExplorerGoTo(DEFAULT_FOLDER)
return
; ----- 'E'verything -----
RAlt & LCtrl:: ToggleEverythingApp()
>!+e:: FocusOrLaunchEverything()
; ------ 'f'irefox -------
>!f:: FocusOrLaunchFirefox()
; ------ 'F'usion 360 -------
>!+f:: FocusOrLaunchFusion360()
; ----- Microsfot Ed'g'e -----
>!g:: FocusOrLaunchEdge()
; ------ 'G'oldenDict -------
>!+g:: FocusOrLaunchGoldenDict()
; ------ 'j'oplin -------
>!j:: FocusOrLaunchJoplin()
; ------ 'k'eePass -------
>!k:: FocusOrLaunchKeePassXC()
; ------ 'k'eypirinha -----
; >!space:: ; This combo is defined in the keypirinha settings.
; ------ Chro'm'e ------
>!m:: FocusOrLaunchChrome()
; ------ C'M'D ------
>!+m:: FocusOrLaunchCmd()
; ------ O'n'e Commander -------
>!n:: FocusOrLaunchOneCommander()
; ------ 'o'pera ------
>!o:: FocusOrLaunchOpera()
; ------ Affinity 'P'hoto -------
>!+p:: FocusOrLaunchAffinityPhoto()
; ------ 's'potify -------
>!s:: FocusOrLaunchSpotify()
; ------ FreeFile'S'ync -------
>!+s:: FocusOrLaunchFreeFileSync()
; ----- Windows 't'erminal ------
>!t:: FocusOrLaunchWindowsTerminal()
; ----- 'T'elegram ------
>!+t::FocusOrLaunchTelegram()
; ------ 'U'Pdf ------
>!u:: FocusOrLaunchUPdf()
; ------ 'v'im ------
>!v:: FocusOrLaunchVim()
; ------ 'V'irtualBox ------
>!+v:: FocusOrLaunchVirtualBox()
; ------ 'w'hatsapp -------
>!w:: FocusOrLaunchWhatsApp()
; ------ 'W'ord -------
>!+w:: FocusOrLaunchWord()
; ------ E'X'cel -------
>!+x:: FocusOrLaunchExcel()
; ------ T'y'pora -------
>!y:: FocusOrLaunchTypora()
; ------ 'z'eal -------
>!z:: FocusOrLaunchZeal()

