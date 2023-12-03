//
//  HoverButton.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 20/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

/*
 Button is entity for colision, contains a background and label
 Uses an empty view to stay in line
*/
public class HoverButton: UIView {
    //Background
    let bgView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.isUserInteractionEnabled = false
        view.layer.cornerRadius = 5
        return view
    }()
    //Label
    let label: UILabel = {
        let label = UILabel()
        //label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize+4)
        label.isUserInteractionEnabled = false
        label.textAlignment = .center
        label.textColor = KAsset.Colors.text.color
        return label
    }()
    
    convenience public init(text: String = "") {
        self.init()
        label.text = text
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

private extension HoverButton {
    func setup() {
        self.isUserInteractionEnabled = true
        self.addSubview(bgView)
        bgView.top(equalTo: self, constant: KConst.spacing*3)
        bgView.fillHorizontal(to: self, constant: KConst.spacing*2)
        bgView.height(equalTo: self, multiplier: 0.34)
        bgView.addSubview(label)
        label.fill(to: bgView, constant: -KConst.spacing*2)
        let v = UIView()
        self.addSubview(v)
        v.bottom(equalTo: self)
        v.topToBottom(of: bgView)
        v.fillHorizontal(to: self)
        v.isHidden = true
        setColor()
    }
    
    func setColor() {
        label.textColor = KConst.dark
            ? KAsset.Colors.textDark.color
            : KAsset.Colors.text.color
    }
}

public extension HoverButton {
    func mark() {
        bgView.backgroundColor = UIColor(red: 0, green: 0.48, blue: 1, alpha: 1)
        label.textColor = .white
    }
    
    func unmark() {
        bgView.backgroundColor = .clear
        setColor()
    }
    
    func getText() -> String {
        return label.text ?? ""
    }
}
