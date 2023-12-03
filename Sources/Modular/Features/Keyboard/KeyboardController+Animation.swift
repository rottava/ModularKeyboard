//
//  KeyboardController+Animation.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 02/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit
import AudioToolbox

// MARK: Animations
public extension KeyboardController {
    func showHover(at key: KeyboardButton) {
        //currentKey = key
        dismissHover()
        hover.updateKey(with: key, fill: false)
        currentKeyboard.addSubview(hover)
    }
    
    func dismissHover() {
        hover.removeFromSuperview()
    }
    
    func fillHover() {
        hover.showAll()
    }
    
    func toolbarSelect() {
        toolbarKey?.didSelect()
    }
    
    func toolbarDeselect() {
        toolbarKey?.didDeselect()
    }
    
    func turnOnKey() {
        switch currentKey.type {
        case .backspace:
            currentKey.bgView.backgroundColor = getSurfaceColor()
            currentKey.imageView.image = KConst.dark
                ? KAsset.Keyboard.backspaceOnDark.image
                : KAsset.Keyboard.backspaceOn.image
        case .enter:
            currentKey.bgView.backgroundColor = getSurfaceColor()
        case .space:
            currentKey.bgView.backgroundColor = getSystemColor()
        default:
            break
        }
    }
    
    func turnOffKey() {
        switch currentKey.type {
        case .backspace:
            currentKey.bgView.backgroundColor = getSystemColor()
            currentKey.imageView.image = KConst.dark
                ? KAsset.Keyboard.backspaceOffDark.image
                : KAsset.Keyboard.backspaceOff.image
        case .enter:
            currentKey.bgView.backgroundColor = getSystemColor()
        case .space:
            currentKey.bgView.backgroundColor = getSurfaceColor()
        default:
            break
        }
    }
    
    func audioFeedback(of type: KeyType) {
        if (hasFullAccess && KConst.audio) {
            switch type {
            case .backspace:
                AudioServicesPlaySystemSound(1155)
            case .char:
                AudioServicesPlaySystemSound(1104)
            default:
                AudioServicesPlaySystemSound(1156)
            }
        }
    }
}
