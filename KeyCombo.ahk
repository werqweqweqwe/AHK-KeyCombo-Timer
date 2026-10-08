; =========================
; AHK KEY COMBO TIMER - FUTURISTIC DESIGN
; =========================

Gui, Color, 0A0E27
Gui, Font, s11 cFFFFFF, Segoe UI

; Заголовок с иконкой
Gui, Add, Text, x20 y20 w500 h40 c00D9FF Center, ⚡ COSMIC KEY TIMER ⚡
Gui, Font, s10 cAAAAFF
Gui, Add, Text, x20 y60 w500 h20 c00D9FF Center, Управление горячими клавишами в будущем
Gui, Font, s11 cFFFFFF

; Разделитель
Gui, Add, Text, x20 y90 w500 h2 cFF00FF, 

; ===== РАЗДЕЛ 1: ОСНОВНЫЕ НАСТРОЙКИ =====
Gui, Font, s10 c00D9FF Bold
Gui, Add, Text, x20 y110 w300 h25, ▶ ГОРЯЧАЯ КЛАВИША:
Gui, Font, s11 cFFFFFF
Gui, Add, Edit, x20 y140 w300 h35 vHotKeyInput cFFFFFF -Border, q
Gui, Add, Text, x330 y140 w35 h35 Center c00D9FF, ⬅

; ===== РАЗДЕЛ 2: КЛАВИША ДЛЯ НАЖАТИЯ =====
Gui, Font, s10 c00D9FF Bold
Gui, Add, Text, x20 y185 w300 h25, ▶ КЛАВИША ДЛЯ НАЖАТИЯ:
Gui, Font, s11 cFFFFFF
Gui, Add, Edit, x20 y215 w300 h35 vActionKeyInput cFFFFFF -Border, q
Gui, Add, Text, x330 y215 w35 h35 Center c00D9FF, ⬅

; ===== РАЗДЕЛ 3: ВРЕМЯ ЗАДЕРЖКИ =====
Gui, Font, s10 c00D9FF Bold
Gui, Add, Text, x20 y260 w140 h25, ▶ СЕКУНДЫ:
Gui, Font, s11 cFFFFFF
Gui, Add, Edit, x20 y290 w140 h35 vSecondsInput cFFFFFF -Border, 2

Gui, Font, s10 c00D9FF Bold
Gui, Add, Text, x180 y260 w140 h25, ▶ МИЛЛИСЕКУНДЫ:
Gui, Font, s11 cFFFFFF
Gui, Add, Edit, x180 y290 w140 h35 vMillisecondsInput cFFFFFF -Border, 0

; Разделитель
Gui, Add, Text, x20 y340 w500 h2 cFF00FF, 

; ===== СТАТУС И ИНФОРМАЦИЯ =====
Gui, Font, s10 c00D9FF Bold
Gui, Add, Text, x20 y360 w500 h20, ◆ СТАТУС СИСТЕМЫ:
Gui, Font, s10 c00FF00
Gui, Add, Text, x20 y385 w500 h50 Border vStatusText c00FF00, ➤ Ожидание активации...

; ===== КНОПКИ УПРАВЛЕНИЯ =====
Gui, Font, s10 Bold
Gui, Add, Button, x20 y450 w150 h45 gSaveHotkey cFFFFFF, ✓ СОХРАНИТЬ
Gui, Add, Button, x190 y450 w150 h45 gDeleteHotkey cFFFFFF, ✕ УДАЛИТЬ
Gui, Add, Button, x360 y450 w160 h45 gResetAll cFFFFFF, ⟲ СБРОС

; ===== КНОПКА ВЫХОДА =====
Gui, Add, Button, x20 y510 w500 h40 gExitApp c00FF00, ◄ ЗАВЕРШИТЬ

; Панель информации
Gui, Font, s9 c0088FF
Gui, Add, Text, x20 y560 w500 h50, ► Активные комбинации: 1  |  ► Версия: 1.0  |  ► Статус: ОНЛАЙН ✓

Gui, Show, w540 h620, COSMIC KEY TIMER - FUTURISTIC EDITION
return

; =========================
; ПЕРЕМЕННЫЕ
; =========================

CurrentHotKey := ""
CurrentActionKey := ""
CurrentDelay := 0
PresetCount := 0

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
        GuiControl,, StatusText, ✗ ОШИБКА: Заполните все поля!
        return
    }

    if (!IsNumber(Seconds) || !IsNumber(Milliseconds))
    {
        GuiControl,, StatusText, ✗ ОШИБКА: Используйте только цифры!
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

    Status := "✓ СОХРАНЕНО! [" HotKey "] → [" ActionKey "] (" Seconds "s " Milliseconds "ms)"
    GuiControl,, StatusText, %Status%
    
    PresetCount++
}
return

DeleteHotkey:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
        CurrentHotKey := ""
        GuiControl,, StatusText, ✕ УДАЛЕНО! Комбинация деактивирована.
        PresetCount--
    }
    else
    {
        GuiControl,, StatusText, ⚠ ВНИМАНИЕ: Нечего удалять!
    }
}
return

ResetAll:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
    }
    
    GuiControl,, HotKeyInput, q
    GuiControl,, ActionKeyInput, q
    GuiControl,, SecondsInput, 2
    GuiControl,, MillisecondsInput, 0
    GuiControl,, StatusText, ⟲ СИСТЕМА ПЕРЕЗАГРУЖЕНА
    
    CurrentHotKey := ""
    CurrentActionKey := ""
    CurrentDelay := 0
    PresetCount := 0
}
return

PressKey:
{
    GuiControl,, StatusText, ► АКТИВИРОВАНА! Выполнение команды...
    Send, {%CurrentActionKey%}
    Sleep, %CurrentDelay%
    GuiControl,, StatusText, ✓ ГОТОВО! (" CurrentDelay "ms задержка применена)
}
return

ExitApp:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
    }
    ExitApp
}
return

GuiClose:
{
    if (CurrentHotKey != "")
    {
        Hotkey, %CurrentHotKey%, Off
    }
    ExitApp
}
return

IsNumber(value)
{
    if value is number
        return true
    return false
}