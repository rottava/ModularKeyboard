//
//  KeyboardController+Autocomplete.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 02/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit

// MARK: Auto Complete
extension KeyboardController {
    @objc
    open func resetAutocomplete() {
        
    }
    
    @objc
    open func performAutocomplete() {
        let entry = textDocumentProxy.documentContextBeforeInput ?? ""
        let last = lastWord(entry)
        let words = checkWord(last) ?? []
        toolbar.updateWords(with: noRepeat(last, at: words))
        checkUpdateKeyboard()
    }
    
    func checkWord(_ word: String) -> [String]? {
        if(isReal(word)) { return hasCompletion(word) }
        else { return hasCorrection(word) }
    }
    
    func lastWord(_ word: String) -> String {
        let w = word.split(separator: " ")
        
        return String(w.last ?? "")
    }
    
    func isReal(_ word: String) -> Bool {
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = textChecker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "pt_BR")
        
        return misspelledRange.location == NSNotFound
    }
    
    func hasCompletion(_ word: String) -> [String]? {
        let range = NSRange(location: 0, length: word.utf16.count)
        let completions = textChecker.completions(forPartialWordRange: range, in: word, language: "pt_BR")
        
        return completions
    }
    
    func hasCorrection(_ word: String) -> [String]? {
        let range = NSRange(location: 0, length: word.utf16.count)
        let guesses = textChecker.guesses(forWordRange: range, in: word, language: "pt_BR")
        
        return guesses
    }
    
    func noRepeat(_ word: String, at words: [String]) -> [String] {
        if words.isEmpty { return words }
        var w = words
        
        if(word.lowercased().normalized().elementsEqual(words.first?.lowercased().normalized() ?? "")) {
            w.removeFirst()
        }
        
        return w
    }
    
    func didTapToolbar(with word: String) {
        guard let entry = textDocumentProxy.documentContextBeforeInput else { return }
        
        let last = lastWord(entry)
        
        for _ in last {
            textDocumentProxy.deleteBackward()
        }
        
        textDocumentProxy.insertText(word)
    }
}
