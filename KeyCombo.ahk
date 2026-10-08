; =========================
; COSMIC KEY TIMER - FUTURISTIC HACKER STYLE
; AutoHotkey v1.1 compatible
; =========================

; ---------- БАЗОВЫЕ НАСТРОЙКИ ----------
#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Mouse, Screen

; ---------- GUI ----------
Gui, Color, 0B1020
Gui, Font, s12 cFFFFFF, Segoe UI

; Прозрачные/светящиеся секции
Gui, Add, Text, x20 y20 w520 h40 +0x200 c00D9FF Center, COSMIC KEY TIMER
Gui, Font, s9 c55D9FF, Segoe UI
Gui, Add, Text, x20 y58 w520 h20 +0x200 c55D9FF Center, Hotkey automation control panel
Gui, Font, s12 cFFFFFF, Segoe UI

; Основная панель
Gui, Add, GroupBox, x20 y90 w520 h460 +Theme BackgroundTrans c0A0BFF, CUSTOM COMMAND

; Горячая клавиша
Gui, Add, Text, x40 y120 w180 h25 c77D6FF, Trigger hotkey:
Gui, Add, Edit, x220 y120 w250 h30 vHotKeyInput -Background +Center, q

; Клавиша для нажатия
Gui, Add, Text, x40 y175 w180 h25 c77D6FF, Key to press:
Gui, Add, Edit, x220 y175 w250 h30 vActionKeyInput -Background +Center, q

; Секунды
Gui, Add, Text, x40 y230 w180 h25 c77D6FF, Seconds:
Gui, Add, Edit, x220 y230 w110 h30 vSecondsInput -Background +Center, 2

; Миллисекунды
Gui, Add, Text, x360 y230 w70 h25 c77D6FF, ms:
Gui, Add, Edit, x430 y230 w110 h30 vMillisecondsInput -Background +Center, 0

; Статус
Gui, Add, Text, x40 y285 w180 h25 c77D6FF, Status:
Gui, Add, Text, x220 y285 w250 h30 +Border vStatusText c00FF88, Ready to orbit

; Кнопки
Gui, Font, s10 cFFFFFF Bold, Segoe UI
Gui, Add, Button, x40 y350 w140 h40 gSaveHotkey, SAVE
Gui, Add, Button, x210 y350 w140 h40 gDeleteHotkey, DELETE
Gui, Add, Button, x380 y350 w140 h40 gResetAll, RESET
Gui, Add, Button, x40 y420 w480 h50 gExitApp, EXIT

; Нижняя строка
Gui, Font, s9 c77D6FF, Segoe UI
Gui, Add, Text, x40 y500 w500 h20 c77D6FF, Mode: active | Delay: custom | Version: 1.0 cosmic edition

; --------- ПЕРЕМЕННЫЕ ---------
CurrentHotKey := ""
CurrentActionKey := ""
CurrentDelay := 0

; ---------- ДЕЙСТВИЯ ----------
Gui, Show, w560 h560, Cosmic Key Timer
return

SaveHotkey:
{
    GuiControlGet, HotKey,, HotKeyInput
    GuiControlGet, ActionKey,, ActionKeyInput
    GuiControlGet, Seconds,, SecondsInput
    GuiControlGet, Milliseconds,, MillisecondsInput

    if (HotKey = "" || ActionKey = "")
    {
        GuiControl,, StatusText, Empty fields
        return
    }

    if (!IsNumber(Seconds) || !IsNumber(Milliseconds))
    {
        GuiControl,, StatusText, Only numbers allowed
        return
    }

    TotalDelay := (Seconds * 1000) + Milliseconds

    if (CurrentHotKey != "")
        Hotkey, %CurrentHotKey%, Off

    CurrentHotKey := HotKey
    CurrentActionKey := ActionKey
    CurrentDelay := TotalDelay

    Hotkey, %HotKey%, PressKey
    GuiControl,, StatusText, Ready: %HotKey% -> %ActionKey% (%Seconds%s %Milliseconds%ms)
}
return

DeleteHotkey:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
        CurrentHotKey := ""
        CurrentActionKey := ""
        CurrentDelay := 0
        GuiControl,, StatusText, Removed
    }
    else
    {
        GuiControl,, StatusText, Nothing to remove
    }
}
return

ResetAll:
{
    if (CurrentHotKey != "")
        Hotkey, %CurrentHotKey%, Off

    CurrentHotKey := ""
    CurrentActionKey := ""
    CurrentDelay := 0
    GuiControl,, HotKeyInput, q
    GuiControl,, ActionKeyInput, q
    GuiControl,, SecondsInput, 2
    GuiControl,, MillisecondsInput, 0
    GuiControl,, StatusText, System reset
}
return

PressKey:
{
    Send, {%CurrentActionKey%}
    GuiControl,, StatusText, Triggered: %CurrentActionKey% | delay %CurrentDelay% ms
    Sleep, %CurrentDelay%
    GuiControl,, StatusText, Complete
}
return

ExitApp:
{
    if (CurrentHotKey != "")
        Hotkey, %CurrentHotKey%, Off
    ExitApp
}
return

GuiClose:
{
    if (CurrentHotKey != "")
        Hotkey, %CurrentHotKey%, Off
    ExitApp
}
return

IsNumber(value)
{
    if value is number
        return true
    return false
}