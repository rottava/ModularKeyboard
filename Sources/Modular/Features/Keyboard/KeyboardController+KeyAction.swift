//
//  KeyboardController+KeyAction.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 02/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit

// MARK: Key Action
extension KeyboardController {
    
    func alphabetAction() {
        capsLock = false
        let full = fullText()
        if (full.isEmpty || full.hasSuffix("\n")) {
            updateKeyboard(with: Keyboard(.PTBRup()))
        } else {
            updateKeyboard(with: Keyboard(.PTBRlo()))
        }
    }
    
    func backspaceAction() {
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        let sel = textDocumentProxy.selectedText ?? ""
        if (!before.isEmpty || !sel.isEmpty) { //must be preset
            delCount = 0
            textDocumentProxy.deleteBackward()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.backspaceRepeat()
            }
        }
        
        lastKey = .backspace
    }
    
    func backspaceRepeat() {
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        if (longPress && lastKey == .backspace && !before.isEmpty) {
            if delCount > 20 {
                //remove entire word
                for c in before.reversed() {
                    if c == " " {
                        textDocumentProxy.deleteBackward()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.textDocumentProxy.deleteBackward()
                        }
                        break
                    } else {
                        textDocumentProxy.deleteBackward()
                    }
                }
            } else {
                textDocumentProxy.deleteBackward()
                delCount += 1
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.backspaceRepeat()
                }
            }
        }
    }
    
    func charAction(_ c: String?) {
        textDocumentProxy.insertText(c ?? "")
        
        lastKey = .char
    }
    
    func emojiAction() {
        print(":)")
        
        lastKey = .emoji
    }
    
    func enterAction() {
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        let shouldUpdate = !(currentKeyboard.keyboard.type == .uppercase)
            || currentKeyboard.keyboard.type == .lowercase
            || !before.isEmpty || !before.hasSuffix("\n")
        
        textDocumentProxy.insertText("\n")
        
        if(shouldUpdate) {
            updateKeyboard(with: Keyboard(.PTBRup()))
        }
        
        lastKey = .enter
    }
    
    func globeAction() {
        advanceToNextInputMode()
        lastKey = .globe
    }
    
    func spaceAction() {
        let before = textDocumentProxy.documentContextBeforeInput ?? ""
        let a = before.dropLast()
        if (KConst.double && doubleTap && lastKey == .space && a.last != " " ) {
            textDocumentProxy.deleteBackward()
            textDocumentProxy.insertText(". ")
        } else {
            textDocumentProxy.insertText(" ")
            doubleTap = true
            startDoubleTimer()
        }
        
        lastKey = .space
    }
    
    func shiftAction() {
        if (doubleTap && lastKey == .shift) {
            capsLock = true
            updateKeyboard(with: Keyboard(.PTBRup()))
            let sv = currentKeyboard.viewWithTag(101) as? KeyboardButton
            sv?.imageView.image = KConst.dark
                ? KAsset.Keyboard.capslockDark.image
                : KAsset.Keyboard.capslock.image
        } else {
            capsLock = false
            if currentKeyboard.keyboard.type == .lowercase {
                updateKeyboard(with: Keyboard(.PTBRup()))
            } else {
                updateKeyboard(with: Keyboard(.PTBRlo()))
            }
            startDoubleTimer()
        }
         
        lastKey = .shift
    }
}
