; =========================
; GUI НАСТРОЙКИ
; =========================

Gui, Add, Text,, Горячая клавиша:
Gui, Add, Edit, w150 vHotKeyInput, q

Gui, Add, Text,, Клавиша для нажатия:
Gui, Add, Edit, w150 vActionKeyInput, q

Gui, Add, Text,, Секунды:
Gui, Add, Edit, w150 vSecondsInput, 2

Gui, Add, Text,, Миллисекунды:
Gui, Add, Edit, w150 vMillisecondsInput, 0

Gui, Add, Text, w300 h30 Border vStatusText, Ожидание...

Gui, Add, Button, w150 h30 gSaveHotkey, Сохранить
Gui, Add, Button, w150 h30 gDeleteHotkey, Удалить
Gui, Add, Button, w150 h30 gExitApp, Выход

Gui, Show, w350 h400, AHK Key Combo Timer
return

; =========================
; ПЕРЕМЕННЫЕ
; =========================

CurrentHotKey := ""
CurrentActionKey := ""
CurrentDelay := 0

; =========================
; ФУНКЦИИ
; =========================

SaveHotkey:
{
    GuiControlGet, HotKey,, HotKeyInput
    GuiControlGet, ActionKey,, ActionKeyInput
    GuiControlGet, Seconds,, SecondsInput
    GuiControlGet, Milliseconds,, MillisecondsInput

    if (HotKey = "" || ActionKey = "")
    {
        MsgBox, Заполните все поля!
        return
    }

    if (!IsNumber(Seconds) || !IsNumber(Milliseconds))
    {
        MsgBox, Секунды и миллисекунды должны быть цифрами!
        return
    }

    TotalDelay := (Seconds * 1000) + Milliseconds

    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
    }

    CurrentHotKey := HotKey
    CurrentActionKey := ActionKey
    CurrentDelay := TotalDelay

    Hotkey, %HotKey%, PressKey

    Status := "Сохранено! " HotKey " -> " ActionKey " (" Seconds "s " Milliseconds "ms)"
    GuiControl,, StatusText, %Status%
}
return

DeleteHotkey:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
        CurrentHotKey := ""
        GuiControl,, StatusText, Удалено!
    }
    else
    {
        MsgBox, Нечего удалять!
    }
}
return

PressKey:
{
    Send, {%CurrentActionKey%}
    Status := "НАЖАТА! Ожидание " CurrentDelay "ms..."
    GuiControl,, StatusText, %Status%
    Sleep, %CurrentDelay%
    GuiControl,, StatusText, Готово!
}
return

ExitApp:
ExitApp
return

IsNumber(value)
{
    if value is number
        return true
    return false
}