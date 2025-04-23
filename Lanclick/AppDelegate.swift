//
//  AppDelegate.swift
//  Lanclick
//
//  Created by Nikita Gostevsky on 23.04.2025.
//
import Cocoa
import HotKey
import ApplicationServices

class AppDelegate: NSObject, NSApplicationDelegate {
    var hotKey: HotKey?
    private var isRussianToEnglish = true // true - русский в английский, false - английский в русский

    // Словарь для транслитерации с русского на английский
    private let russianToEnglishMap: [Character: String] = [
        "а": "f", "б": ",", "в": "d", "г": "u", "д": "l", "е": "t", "ё": "|",
        "ж": ";", "з": "p", "и": "b", "й": "q", "к": "r", "л": "k", "м": "v",
        "н": "y", "о": "j", "п": "g", "р": "h", "с": "c", "т": "n", "у": "e",
        "ф": "a", "х": "[", "ц": "w", "ч": "x", "ш": "i", "щ": "o",
        "ъ": "]", "ы": "s", "ь": "m", "э": "'", "ю": ".", "я": "z",
        "А": "F", "Б": ",", "В": "D", "Г": "U", "Д": "L", "Е": "T", "Ё": "|",
        "Ж": ";", "З": "P", "И": "B", "Й": "Q", "К": "R", "Л": "K", "М": "V",
        "Н": "Y", "О": "J", "П": "G", "Р": "H", "С": "C", "Т": "N", "У": "E",
        "Ф": "A", "Х": "[", "Ц": "W", "Ч": "X", "Ш": "I", "Щ": "O",
        "Ъ": "]", "Ы": "S", "Ь": "M", "Э": "'", "Ю": ".", "Я": "Z"
    ]
    
    // Словарь для транслитерации с английского на русский
    private let englishToRussianMap: [Character: String] = [
        "a": "ф", "b": "и", "c": "с", "d": "в", "e": "у", "f": "а", "g": "п",
        "h": "р", "i": "ш", "j": "о", "k": "л", "l": "д", "m": "ь", "n": "т",
        "o": "щ", "p": "з", "q": "й", "r": "к", "s": "ы", "t": "е", "u": "г",
        "v": "м", "w": "ц", "x": "ч", "y": "н", "z": "я",
        "A": "Ф", "B": "И", "C": "С", "D": "В", "E": "У", "F": "А", "G": "П",
        "H": "Р", "I": "Ш", "J": "О", "K": "Л", "L": "Д", "M": "Ь", "N": "Т",
        "O": "Щ", "P": "З", "Q": "Й", "R": "К", "S": "Ы", "T": "Е", "U": "Г",
        "V": "М", "W": "Ц", "X": "Ч", "Y": "Н", "Z": "Я",
        ",": "б", ";": "ж", "[": "х", "]": "ъ", "'": "э", ".": "ю", "|": "ё"
    ]

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Проверяем разрешения для Accessibility
        checkAccessibilityPermissions()
        
        // Регистрируем горячие клавиши
        hotKey = HotKey(key: .l, modifiers: [.command, .shift])
        hotKey?.keyDownHandler = {
            _ = self.getSelectedText()
        }
    }
    
    // Проверка разрешений для Accessibility
    private func checkAccessibilityPermissions() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        let accessEnabled = AXIsProcessTrustedWithOptions(options as CFDictionary)
        
        if !accessEnabled {
            let prefpaneUrl = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
            NSWorkspace.shared.open(prefpaneUrl)
        }
    }
    
    // Определение языка текста
    private func isRussianText(_ text: String) -> Bool {
        let russianLetters = CharacterSet(charactersIn: "абвгдеёжзийклмнопрстуфхцчшщъыьэюяАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ")
        return text.unicodeScalars.contains { russianLetters.contains($0) }
    }
    
    // Транслитерация текста
    private func transliterate(_ text: String) -> String {
        var result = ""
        let map = isRussianText(text) ? russianToEnglishMap : englishToRussianMap
        
        for char in text {
            if let transliterated = map[char] {
                result += transliterated
            } else {
                result.append(char)
            }
        }
        return result
    }
    
    // Получение и замена выделенного текста
    private func getSelectedTextViaPasteboard() -> String? {
        let pasteboard = NSPasteboard.general
        let oldContents = pasteboard.string(forType: .string)
        
        // Копируем выделенный текст
        let source = CGEventSource(stateID: .hidSystemState)
        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: true)
        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x08, keyDown: false)
        
        keyDown?.flags = .maskCommand
        keyUp?.flags = .maskCommand
        
        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
        
        Thread.sleep(forTimeInterval: 0.2)
        
        guard let selectedText = pasteboard.string(forType: .string) else { return nil }
        
        // Транслитерируем и вставляем текст
        let transliteratedText = transliterate(selectedText)
        pasteboard.clearContents()
        pasteboard.setString(transliteratedText, forType: .string)
        
        Thread.sleep(forTimeInterval: 0.1)
        
        let vKeyDown = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: true)
        let vKeyUp = CGEvent(keyboardEventSource: source, virtualKey: 0x09, keyDown: false)
        
        vKeyDown?.flags = .maskCommand
        vKeyUp?.flags = .maskCommand
        
        vKeyDown?.post(tap: .cghidEventTap)
        vKeyUp?.post(tap: .cghidEventTap)
        
        Thread.sleep(forTimeInterval: 0.1)
        
        // Очищаем буфер обмена после вставки
        pasteboard.clearContents()
        
        // Восстанавливаем старое содержимое буфера обмена
        if let oldContents = oldContents {
            pasteboard.setString(oldContents, forType: .string)
        }
        
        return transliteratedText
    }
    
    func getSelectedText() -> String? {
        return getSelectedTextViaPasteboard()
    }
}
