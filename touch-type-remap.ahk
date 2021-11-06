;;
;; An autohotkey script that provides emacs-like keybinding on Windows
;;
#InstallKeybdHook
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
#UseHook ; Ensures that hotkeys are not triggered again when using the Send command.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.

; The following line is a contribution of NTEmacs wiki http://www49.atwiki.jp/ntemacs/pages/20.html
SetKeyDelay 0

enabledIcon := "assets/emacs_everywhere_16.ico"
disabledIcon := "assets/emacs_everywhere_disabled_16.ico"
IsInEmacsMode := false
NumericPrefix = 1
CtrlXPrefix = 0

SetEmacsMode(true)

SetEmacsMode(toActive) {
  local iconFile := toActive ? enabledIcon : disabledIcon
  local state := toActive ? "ON" : "OFF"

  IsInEmacsMode := toActive
;  TrayTip, Emacs Everywhere, Emacs mode is %state%, 10, 1
  Menu, Tray, Icon, %iconFile%,
  Menu, Tray, Tip, Emacs Everywhere`nEmacs mode is %state%
;  Sleep, 1500
;  TrayTip
}

SendCommand(k1, k2="", k3="", k4="", k5="", k6="") {
  global IsInEmacsMode
  global NumericPrefix
  global CtrlXPrefix

  if (IsInEmacsMode) {

    Send, %k1%
    if (k2<>"") {
      Send, %k2%
    }
    if (k3<>"") {
      Send, %k3%
    }
    if (k4<>"") {
      Send, %k4%
    }
    if (k5<>"") {
      Send, %k5%
    }
    if (k6<>"") {
      Send, %k6%
    }
  } else {
  ; Pass through the original keystroke.
  ; This requires parsing A_ThisHotkey to determine the modifiers to specify for the Send command.
  ; Originally just had: Send, %A_ThisHotkey%
  ; .. but this caused the string "Delete" to be sent when pressing the Delete key.
  ;
  ; Code taken from https://autohotkey.com/boards/viewtopic.php?f=5&t=25643
  ; Alternative approach: Laszlo's reply at https://autohotkey.com/board/topic/9223-the-shortest-way-to-send-a-thishotkey/
    FoundPos := RegExMatch(A_ThisHotkey, "O)([\^!#+]+)(.*)", m)
    if (FoundPos = 0)
    {
      Modifiers =
      Key = %A_ThisHotkey%
    } else {
      Modifiers := m[1]
      Key := m[2]

    }
    ; MsgBox, % Modifiers "`n" Key
    Send, % Modifiers "{" Key "}"
  }
  NumericPrefix = 1
  CtrlXPrefix = 0
  return
}

^!Enter::SetEmacsMode(!IsInEmacsMode)

; key remapping when emacs is active

; ignore the ";" key
`;::SendCommand("{}")

`; & q::SendCommand("{" . chr(34) . "}")
`; & w::SendCommand("{Up}")
`; & e::SendCommand("{=}")
`; & r::SendCommand("{[}")
`; & t::SendCommand("{]}")
`; & y::SendCommand("{~}")
`; & i::SendCommand("{tab}")
`; & o::SendCommand("{Delete}")
`; & a::SendCommand("{Left}")
`; & s::SendCommand("{Down}")
`; & d::SendCommand("{Right}")
`; & f::SendCommand("{enter}")
`; & g::SendCommand("{(}")
`; & h::SendCommand("{)}")
`; & j::SendCommand("{;}")
`; & k::SendCommand("{<}")
`; & l::SendCommand("{>}")
`; & z::SendCommand("{+}")
`; & x::SendCommand("{\}")
`; & c::SendCommand("{{}")
`; & v::SendCommand("{}}")
`; & b::SendCommand("{-}")
`; & n::SendCommand("{_}")
`; & m::SendCommand("{:}")
