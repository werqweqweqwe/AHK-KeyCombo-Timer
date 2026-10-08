#Requires AutoHotkey v2.0
#SingleInstance Force

; =========================
; GUI НАСТРОЙКИ
; =========================

MyGui := Gui()
MyGui.Opt("+AlwaysOnTop")
MyGui.Title := "AHK Key Combo Timer"

; Добавляем элементы интерфейса
MyGui.Add("Text",, "Горячая клавиша:")
HotKeyInput := MyGui.Add("Edit", "w150", "q")

MyGui.Add("Text",, "Клавиша для нажатия:")
ActionKeyInput := MyGui.Add("Edit", "w150", "q")

MyGui.Add("Text",, "Секунды:")
SecondsInput := MyGui.Add("Edit", "w150", "2")

MyGui.Add("Text",, "Миллисекунды:")
MillisecondsInput := MyGui.Add("Edit", "w150", "0")

MyGui.Add("Text",, "Статус:")
StatusText := MyGui.Add("Text", "w300 h30 Border", "Ожидание...")

; Кнопки
MyGui.Add("Button", "w150 h30", "Сохранить").OnEvent("Click", SaveHotkey)
MyGui.Add("Button", "w150 h30", "Удалить").OnEvent("Click", DeleteHotkey)
MyGui.Add("Button", "w150 h30", "Выход").OnEvent("Click", ExitApp)

MyGui.Show()

; =========================
; ПЕРЕМЕННЫЕ
; =========================

global HotKeys := Map()
global CurrentHotKey := ""
global CurrentActionKey := ""
global CurrentDelay := 0

; =========================
; ФУНКЦИИ
; =========================

SaveHotkey(GuiCtrlObj, Info) {
    global HotKeys, CurrentHotKey, CurrentActionKey, CurrentDelay
    
    hotkey := HotKeyInput.Value
    actionKey := ActionKeyInput.Value
    seconds := SecondsInput.Value
    milliseconds := MillisecondsInput.Value
    
    if (hotkey = "" || actionKey = "") {
        MsgBox("Заполните все поля!")
        return
    }
    
    ; Проверяем цифры
    if (!IsNumber(seconds) || !IsNumber(milliseconds)) {
        MsgBox("Секунды и миллисекунды должны быть цифрами!")
        return
    }
    
    ; Переводим в миллисекунды
    totalDelay := (seconds * 1000) + milliseconds
    
    ; Если уже была горячая клавиша, удаляем
    if (CurrentHotKey != "") {
        Hotkey(CurrentHotKey, "Off")
    }
    
    ; Сохраняем новую конфигурацию
    CurrentHotKey := hotkey
    CurrentActionKey := actionKey
    CurrentDelay := totalDelay
    
    HotKeys[hotkey] := {action: actionKey, delay: totalDelay}
    
    ; Активируем горячую клавишу
    Hotkey(hotkey, PressKey)
    
    UpdateStatus("Сохранено! Комбинация: " hotkey " -> " actionKey " (" seconds "s " milliseconds "ms)")
}

DeleteHotkey(GuiCtrlObj, Info) {
    global CurrentHotKey, HotKeys
    
    if (CurrentHotKey != "") {
        Hotkey(CurrentHotKey, "Off")
        HotKeys.Delete(CurrentHotKey)
        CurrentHotKey := ""
        UpdateStatus("Удалено!")
    } else {
        MsgBox("Нечего удалять!")
    }
}

PressKey() {
    global CurrentActionKey, CurrentDelay
    
    Send("{" CurrentActionKey "}")
    
    UpdateStatus("НАЖАТА! Ожидание " CurrentDelay "ms...")
    
    Sleep(CurrentDelay)
    
    UpdateStatus("Готово!")
}

UpdateStatus(message) {
    StatusText.Value := message
}

IsNumber(value) {
    try {
        return (value + 0) = value
    }
    catch {
        return false
    }
}

; =========================
; ПРИМЕРЫ ГОРЯЧИХ КЛАВИШ
; =========================

; Ctrl+Alt+Q = нажать Q с задержкой
^!q::{
    if (CurrentHotKey = "^!q") {
        PressKey()
    }
}