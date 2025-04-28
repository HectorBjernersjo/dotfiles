#NoEnv
#SingleInstance force
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Screen    ;  <—  this fixes the “all the way left” issue

MAIN_MONITOR := 1
SECONDARY_MONITOR := 0

; Helper: move the mouse cursor to the center of a window by its ID
MoveCursorToCenter(windowID) {
    WinGetPos, X, Y, W, H, ahk_id %windowID%, , , 
    CenterX := X + (W // 2)
    CenterY := Y + (H // 2)
    MouseMove, CenterX, CenterY
}

Launch(path, monitor, windowTitle:="", delay:=2000){
    WinGet, counts, count, %windowTitle%
    ; MsgBox, count with %windowTitle% is %counts%
    Run, %path%

    if (counts == 0){
        WinWait, %windowTitle%
    }
    else{
        Sleep, %delay%
    }
    if (counts == 0){
        winget, id, , %windowTitle%
    }
    else{
        winget, id, ID, A
    }

    ; WinSetTitle, %windowTitle%, , idk

    Sleep, 50

    if (monitor == MAIN_MONITOR){
        SysGet, mon1, MonitorWorkArea, 1
        WinRestore, ahk_id %id%
        WinMove, ahk_id %id%, , mon1Left, mon1Top
    }
    else {
        SysGet, mon2, MonitorWorkArea, 2
        WinRestore, ahk_id %id%
        WinMove, ahk_id %id%, , mon2Left, mon2Top
    }
    Sleep, 50
    WinMaximize, ahk_id %id%
    return %id%
}

HandleShortcut(id, path, monitor, windowTitle:="", delay:=2000){
    if (WinExist("ahk_id " . id)){
        WinActivate, ahk_id %id%
        MoveCursorToCenter(id)
    }
    else{
        id := Launch(path, monitor, windowTitle, delay)
    }
    return id
}

i_id := ""
#+i::
    WinGet, i_id, ID, A
#i::
    i_id := HandleShortcut(i_id, "C:\Program Files\Mozilla Firefox\firefox.exe", %MAIN_MONITOR%, "Mozilla Firefox")
return

b_id := ""
#+b::
    WinGet, b_id, ID, A
#b::
    b_id := HandleShortcut(b_id, "C:\Program Files\Mozilla Firefox\firefox.exe", SECONDARY_MONITOR, "Mozilla Firefox")

return

y_id := ""
#+y::
    WinGet, y_id, ID, A
#y::
    y_id := HandleShortcut(y_id, "C:\Program Files\Mozilla Firefox\firefox.exe --new-window youtube.com", SECONDARY_MONITOR, "Mozilla Firefox")
return

c_id := ""
#+c::
    WinGet, c_id, ID, A
return
#c::
    c_id := HandleShortcut(c_id, "C:\Program Files\Mozilla Firefox\firefox.exe --new-window chatgpt.com", SECONDARY_MONITOR) ;, "ChatGPT - Mozilla Firefox")
return

n_id := ""
#+n::
    WinGet, n_id, ID, A
return
#n::
    n_id := HandleShortcut(n_id, "wt.exe wsl", %MAIN_MONITOR%, "wsl")
return

m_id := ""
#+m::
    WinGet, m_id, ID, A
#m::
    m_id := HandleShortcut(m_id, "C:\Program Files\Mozilla Firefox\firefox.exe --new-window https://mail.one.com/mail/INBOX/1", %MAIN_MONITOR%)

return

e_id := ""
#+e::
    WinGet, e_id, ID, A
#e::
    e_id := HandleShortcut(e_id, "code", %MAIN_MONITOR%)
return

x_id := ""
#+x::
    WinGet, x_id, ID, A
#x::
    x_id := HandleShortcut(x_id, "explorer.exe", %SECONDARY_MONITOR%)
return

o_id := ""
#+o::
    WinGet, o_id, ID, A
#o::
    o_id := HandleShortcut(o_id, "C:\Users\chris\AppData\Local\Programs\obsidian\Obsidian.exe", %SECONDARY_MONITOR%)
return
