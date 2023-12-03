//
//  KeyboardButton.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 20/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

/*
Button is entity for colision, contains a background and label/image
*/
public class KeyboardButton: UIView {
    var expanded: Bool
    var type: KeyType
    var variations: CharKey
    //Background
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = KAsset.Colors.surface.color
        view.clipsToBounds = true
        view.layer.cornerRadius = KConst.radius
        view.isUserInteractionEnabled = false
        return view
    }()
    //Label
    let label: UILabel = {
        let label = UILabel()
        //label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        //label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = KConst.dark
            ? KAsset.Colors.textDark.color
            : KAsset.Colors.text.color
        return label
    }()
    //ImageView
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        //imageView.isUserInteractionEnabled = false
        return imageView
    }()
    let sView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        view.layer.cornerRadius = KConst.radius
        view.isUserInteractionEnabled = false
        return view
    }()
    
    public init(variations: CharKey = [""], image: UIImage = UIImage(), type: KeyType = .char, expanded: Bool = false) {
        self.expanded = expanded
        self.imageView.image = image
        self.type = type
        self.variations = variations
        self.label.text = variations.first
        super.init(frame: CGRect())
        setup()
    }
    
    required public init?(coder: NSCoder) {
        self.expanded = false
        self.type = .char
        self.variations = [""]
        self.label.text = variations.first
        super.init(coder: coder)
        setup()
    }
}

private extension KeyboardButton {
    func setup() {
        let m: CGFloat = type == .backspace ? 0.7 : 0.5
        let w = (Keyboard.getWidth()-Keyboard.getBlank())/10
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        
        self.addSubview(sView)
        sView.fillHorizontal(to: self, constant: KConst.spacing)
        sView.height(constant: 10)
        sView.bottom(equalTo: self, constant: -KConst.spacing+0.5)
        
        self.addSubview(bgView)
        bgView.fillHorizontal(to: self, constant: KConst.spacing)
        bgView.fillVertical(to: self, constant: KConst.spacing)
        
        bgView.addSubview(label)
        if(type == .char) {
            if(label.text?.first?.isLowercase ?? false) {
                label.top(equalTo: bgView, constant: -4)
                label.fillHorizontal(to: bgView)
                label.bottom(equalTo: bgView, constant: 0)
                label.font = UIFont.systemFont(ofSize: 22)
            } else {
                label.font = UIFont.systemFont(ofSize: 20)
                label.fill(to: bgView)
            }
        } else {
            label.fill(to: bgView)
        }
        
        bgView.addSubview(imageView)
        imageView.center(in: bgView)
        imageView.size(equalTo: bgView, multiplier: m)
        
        switch type {
        case .char:
            setColor()
            _ = expanded ? width(constant: w*1.4) : width(constant: w)
        case .enter:
            setSystemColor()
            width(constant: w*2.5)
        case .space:
            setColor()
        case .shift:
            setColor()
            if(variations[0] == "↑") { setSystemColor() }
            width(constant: w*1.25)
            tag = 101
            label.isHidden = true
        case .globe:
            setSystemColor()
            width(constant: w*1.25)
            isUserInteractionEnabled = false
        default:
            setSystemColor()
            width(constant: w*1.25)
        }
    }
    
    func setSystemColor() {
        bgView.backgroundColor = KConst.dark
            ? KAsset.Colors.systemDark.color
            : KAsset.Colors.system.color
    }
    
    func setColor() {
        bgView.backgroundColor = KConst.dark
            ? KAsset.Colors.surfaceDark.color
            : KAsset.Colors.surface.color
    }
    
    func setTextColor() {
        label.textColor = KConst.dark
            ? KAsset.Colors.textDark.color
            : KAsset.Colors.text.color
    }
}
