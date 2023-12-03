//
//  Keyboard.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 21/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

public class Keyboard: UIView {
    let keyboard: Lang
    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fillEqually
        return stack
    }()
    
    public init(_ keyboard: Lang) {
        self.keyboard = keyboard
        super.init(frame: CGRect())
        setup()
    }
    
    required public init?(coder: NSCoder) {
        self.keyboard = Lang.PTBRlo()
        super.init(coder: coder)
        setup()
    }
}

private extension Keyboard {
    func setup(){
        self.addSubview(stack)
        stack.fill(to: self)
        
        stack.addArrangedSubview(normalRow(with: keyboard.first))
        
        stack.addArrangedSubview(normalRow(with: keyboard.second))
        
        stack.addArrangedSubview(shiftRow(with: keyboard.thirth))
        
        stack.addArrangedSubview(systemRow())
    }
    
    func normalRow(with array: [CharKey], centering: Bool = true) -> UIStackView {
        let va = UIView()
        let vb = UIView()
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        
        row.addArrangedSubview(va)
        //TODO: FIX GAMBIARRA
        va.tag = 65
        va.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        vb.tag = 76
        vb.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        for key in array {
            row.addArrangedSubview(KeyboardButton(variations: key))
        }
        
        row.addArrangedSubview(vb)
        vb.size(equalTo: va)
        
        return row
    }
    
    func shiftRow(with array: [CharKey]) -> UIStackView {
        let va = UIView()
        let vb = UIView()
        let row = UIStackView()
        var expanded = false
        row.axis = .horizontal
        row.distribution = .fill
        
        switch keyboard.type {
        case .lowercase:
            let i: UIImage = KConst.dark
                ? KAsset.Keyboard.shiftOffDark.image
                : KAsset.Keyboard.shiftOff.image
            row.addArrangedSubview(KeyboardButton(variations: ["↑"], image: i, type: KeyType.shift))
        case .uppercase:
            let i: UIImage = KConst.dark
                ? KAsset.Keyboard.shiftOnDark.image
                : KAsset.Keyboard.shiftOn.image
            row.addArrangedSubview(KeyboardButton(variations: ["↓"], image: i, type: KeyType.shift))
        case .numeric:
            row.addArrangedSubview(KeyboardButton(variations: ["#+="], type: KeyType.symbolic))
            expanded = true
        case .symbolic:
            row.addArrangedSubview(KeyboardButton(variations: ["123"], type: KeyType.numeric))
            expanded = true
        }
        
        row.addArrangedSubview(va)
        
        for key in array {
            row.addArrangedSubview(KeyboardButton(variations: key, expanded: expanded))
        }
        
        row.addArrangedSubview(vb)
        vb.size(equalTo: va)
        
        let i: UIImage = KConst.dark
            ? KAsset.Keyboard.backspaceOffDark.image
            : KAsset.Keyboard.backspaceOff.image
        
        row.addArrangedSubview(KeyboardButton(image: i, type: KeyType.backspace))
        
        return row
    }
    
    func systemRow() -> UIStackView {
        let row = UIStackView()
        row.axis = .horizontal
        row.distribution = .fill
        
        switch keyboard.type {
        case .lowercase:
            row.addArrangedSubview(KeyboardButton(variations: ["123"], type: KeyType.numeric))
        case .uppercase:
            row.addArrangedSubview(KeyboardButton(variations: ["123"], type: KeyType.numeric))
        case .numeric:
            row.addArrangedSubview(KeyboardButton(variations: ["ABC"], type: KeyType.alphabetic))
        case .symbolic:
            row.addArrangedSubview(KeyboardButton(variations: ["ABC"], type: KeyType.alphabetic))
        }
        
        // if (ios 13 && notch && emoji) { add emoji button }
        /*
        if #available(iOS 13.0, *) {
            switch UIDevice().type {
            case .iPhone12ProMax, .iPhone12Pro, .iPhone12Mini, .iPhone12, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhoneX, .iPhoneXS, .iPhoneXR, .iPhoneXSMax:
                if let installedKeyboard = UserDefaults.standard.object(forKey: "AppleKeyboards") as? [String] {
                    if installedKeyboard.contains("Emoji") {
                        row.addArrangedSubview(KeyboardButton(variations: [""], type: KeyType.emoji))
                        
                    }
                }
            default:
                break
            }
        }
        */
        // if has only one doesnt need to show
        if (KConst.inputController.needsInputModeSwitchKey) {
            let i: UIImage = KConst.dark
                ? KAsset.Keyboard.switchKeyboardDark.image
                : KAsset.Keyboard.switchKeyboard.image
            let v = KeyboardButton(image: i, type: KeyType.globe)
            let c = UIControl(frame: v.frame)
            c.addTarget(self,
                        action: #selector(handleTouch(from:with:)),
                        for: .allTouchEvents)
            c.addSubview(v)
            v.fill(to: c)
            row.addArrangedSubview(c)
            
        }
        
        
        row.addArrangedSubview(KeyboardButton(variations: ["espaço"], type: KeyType.space))
        
        row.addArrangedSubview(KeyboardButton(variations: ["retorno"], type: KeyType.enter))
        
        return row
    }
}

extension Keyboard {
    class func getHR() -> CGFloat {
        return Keyboard.getHeight()/852
    }
    
    class func getWR() -> CGFloat {
        return Keyboard.getWidth()/414
    }
    
    class func getToolbarHeight() -> CGFloat {
        return isLandscape() ? KConst.toolbarL : KConst.toolbarP
    }
    
    class func getHeight() -> CGFloat {
        return isLandscape() ? getHeightLandscape() : getHeightPortrait()
    }
    
    class func getWidth() -> CGFloat {
        return isLandscape() ? getWidthLandscape() : getWidthPortrait()
    }
    
    class func getBlank() -> CGFloat {
        if(isLandscape()) {  // landscape
            switch UIDevice().type {
            case .iPhone6, .iPhone6S, .iPhone7, .iPhone8:
                return 132 //66*2
            case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneSE2:
                return 126 //63*2
            default:
                return 0
            }
        } else {
            return 0
        }
    }
    
    class func getHeightPortrait() -> CGFloat {
        switch UIDevice().type {
        case .iPhone5S, .iPhoneSE, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return 216
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return 226
        case .iPhoneX, .iPhoneXS, .iPhone11Pro, .iPhone12, .iPhone12Pro, .iPhone12Mini:
            return 233
        case .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11ProMax, .iPhone12ProMax:
            return 243
        default:
            return 216
        }
    }
    
    class func getHeightLandscape() -> CGFloat {
        switch UIDevice().type {
        case .iPhone5S, .iPhoneSE, .iPhone6, .iPhone6S, .iPhone6Plus, .iPhone6SPlus, .iPhone7, .iPhone7Plus, .iPhone8, .iPhone8Plus, .iPhoneSE2:
            return 162
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12Mini:
            return 169
        case .iPhone12, .iPhone12Pro, .iPhone12ProMax:
            return 179
        default:
            return 162
        }
    }
    
    class func getWidthPortrait() -> CGFloat {
        switch UIDevice().type {
        case .iPhone5S, .iPhoneSE:
            return 320
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhoneX, .iPhoneXS, .iPhone11Pro, .iPhone12Mini, .iPhoneSE2:
            return 375
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11ProMax :
            return 414
        case .iPhone12, .iPhone12Pro:
            return 390
        case .iPhone12ProMax:
            return 428
        default:
            return 320
        }
    }
    
    class func getWidthLandscape() -> CGFloat {
        switch UIDevice().type {
        case .iPhone5S, .iPhoneSE:
            return 568
        case .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhoneSE2:
            return 667
        case .iPhone6Plus, .iPhone6SPlus, .iPhone7Plus, .iPhone8Plus:
            return 736
        case .iPhoneX, .iPhoneXS, .iPhoneXSMax, .iPhoneXR, .iPhone11, .iPhone11Pro, .iPhone11ProMax, .iPhone12Mini:
            return 662
        case .iPhone12, .iPhone12Pro:
            return 694
        case .iPhone12ProMax:
            return 692
        default:
            return 568
        }
    }
    
    class func isLandscape() -> Bool {
        return UIScreen.main.bounds.height < UIScreen.main.bounds.width
    }
}

extension Keyboard {
    @objc
    func handleTouch(from view: UIView, with event: UIEvent) {
        KConst.inputController.handleInputModeList(from: view, with: event)
    }
}
