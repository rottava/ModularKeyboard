//
//  KeyboardController+Handler.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 02/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit

// MARK: Touch Handler
public extension KeyboardController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let position = touches.first?.location(in: view) {
            handleBeginAction(in: position)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        if let position = touches.first?.location(in: view) {
            handleMoveAction(in: position)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        //Handle timer
        if let position = touches.first?.location(in: view) {
            handleEndAction(in: position)
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        //Handle timer
        dismissHover()
        toolbarKey?.didDeselect()
        toolbarKey = nil
        doubleTimer?.invalidate()
        longTimer?.invalidate()
    }
}

// MARK: Action Handler
extension KeyboardController {
    func handleBeginAction(in position: CGPoint) {
        if let sv = view.hitTest(position, with: nil) {
            
            if sv.isKind(of: ToolbarButton.self) {
                toolbarKey = sv as? ToolbarButton
                toolbarKey?.didSelect()
            }
            
            if sv.isKind(of: KeyboardButton.self) {
                let key = sv as? KeyboardButton ?? KeyboardButton()
                currentKey = key
                touchStart(at: key)
                switch key.type {
                case .alphabetic:
                    alphabetAction()
                case .backspace:
                    longPress = true
                    backspaceAction()
                case .char:
                    showHover(at: key)
                case .emoji:
                    emojiAction()
                case .enter:
                    break // nothing yet
                case .globe:
                    break
                case .numeric:
                    updateKeyboard(with: Keyboard(.NUMB()))
                case .space:
                    break // noting yet
                case .shift:
                    shiftAction()
                case .symbolic:
                    updateKeyboard(with: Keyboard(.SYMB()))
                }
                
                startLongTimer()
            }
        }
    }
    
    func handleMoveAction(in position: CGPoint) {
        if let sv = view.hitTest(position, with: nil) {
            
            if sv.isKind(of: ToolbarButton.self) {
                if toolbarKey != sv {
                    toolbarKey?.didDeselect()
                    toolbarKey = sv as? ToolbarButton
                    toolbarKey?.didSelect()
                }
                dismissHover()
            }
            
            if sv.isKind(of: KeyboardButton.self) {
                let key = sv as? KeyboardButton ?? KeyboardButton()
                
                if (key != currentKey) {
                    turnOffKey()
                    currentKey = key
                    
                    if (key.type == .char) {
                        showHover(at: key)
                        startLongTimer()
                    } else {
                        dismissHover()
                    }
                }
                toolbarDeselect()
            } else {
                if sv.isKind(of: HoverButton.self) {
                    let key = sv as? HoverButton ?? HoverButton()
                    hoverKey?.unmark()
                    hoverKey = key
                    hoverKey?.mark()
                    toolbarDeselect()
                }
                turnOffKey()
            }
        }
    }
    
    func handleEndAction(in position: CGPoint) {
        if let sv = view.hitTest(position, with: nil) {
            
            if sv.isKind(of: ToolbarButton.self) {
                let word = toolbarKey?.label.text ?? ""
                if (!word.isEmpty) { didTapToolbar(with: word) }
            }
            
            if sv.isKind(of: KeyboardButton.self) {
                let key = sv as? KeyboardButton ?? KeyboardButton()
                
                switch key.type {
                case .alphabetic:
                    break
                case .backspace:
                    break
                case .char:
                    charAction(key.variations.first)
                case .emoji:
                    break
                case .enter:
                    enterAction()
                case .globe:
                    globeAction()
                case .numeric:
                    break
                case .space:
                    spaceAction()
                case .shift:
                    break
                case .symbolic:
                    break
                }
            } else {
                if sv.isKind(of: HoverButton.self) {
                    let key = sv as? HoverButton ?? HoverButton()
                    charAction(key.label.text)
                } else {
                    //TODO: FIX GAMBIARRA
                    switch sv.tag {
                    case 65:
                        currentKey = KeyboardButton()
                        let c = currentKeyboard.keyboard.type == .uppercase ? "A" : "a"
                        charAction(c)
                    case 76:
                        currentKey = KeyboardButton()
                        let c = currentKeyboard.keyboard.type == .uppercase ? "L" : "l"
                        charAction(c)
                    default:
                        break
                    }
                }
            }
        }
        
        dismissHover()
        toolbarDeselect()
        endLongTimer()
        touchEnd()
    }
}
