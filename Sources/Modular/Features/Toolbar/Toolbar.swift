//
//  Toolbar.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 03/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit

open class Toolbar: UIView {
    let leftLabel = ToolbarButton()
    let centerLabel = ToolbarButton()
    let rightLabel = ToolbarButton()
    
    let dividerL: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = KAsset.Colors.surfaceDark.color
        return view
    }()
    
    let dividerR: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = KAsset.Colors.surfaceDark.color
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
}

private extension Toolbar {
    func setup() {
        self.addSubview(leftLabel)
        leftLabel.fillVertical(to: self)
        leftLabel.left(equalTo: self)
        //leftLabel.width(equalTo: self, multiplier: 0.3)
        
        self.addSubview(dividerL)
        dividerL.left(equalTo: leftLabel.rightAnchor, constant: KConst.spacing)
        dividerL.fillVertical(to: self, constant: KConst.spacing*3)
        dividerL.width(constant: 1)
        
        self.addSubview(centerLabel)
        centerLabel.fillVertical(to: self)
        centerLabel.left(equalTo: dividerL.rightAnchor, constant: KConst.spacing)
        centerLabel.width(equalTo: leftLabel)
        
        self.addSubview(dividerR)
        dividerR.left(equalTo: centerLabel.rightAnchor, constant: KConst.spacing)
        dividerR.fillVertical(to: self, constant: KConst.spacing*3)
        dividerR.width(constant: 1)
        
        self.addSubview(rightLabel)
        rightLabel.fillVertical(to: self)
        rightLabel.left(equalTo: dividerR.rightAnchor, constant: KConst.spacing)
        rightLabel.width(equalTo: leftLabel)
        rightLabel.right(equalTo: self, constant: -KConst.spacing)
    }
}

extension Toolbar {
    func updateWords(with words: [String]) {
        switch words.count {
        case 0:
            UIView.animate(withDuration: 0.3, animations: {
                self.leftLabel.refresh(with: "")
                self.centerLabel.refresh(with: "")
                self.rightLabel.refresh(with: "")
                self.dividerL.alpha = 0
                self.dividerR.alpha = 0
            })
        case 1:
            UIView.animate(withDuration: 0.3, animations: {
                self.leftLabel.refresh(with: words[0])
                self.centerLabel.refresh(with: "")
                self.rightLabel.refresh(with: "")
                self.dividerL.alpha = 0
                self.dividerR.alpha = 0
            })
        case 2:
            UIView.animate(withDuration: 0.3, animations: {
                self.leftLabel.refresh(with: words[0])
                self.centerLabel.refresh(with: words[1])
                self.rightLabel.refresh(with: "")
                self.dividerL.alpha = 1
                self.dividerR.alpha = 0
            })
        default:
            UIView.animate(withDuration: 0.3, animations: {
                self.leftLabel.refresh(with: words[0])
                self.centerLabel.refresh(with: words[1])
                self.rightLabel.refresh(with: words[2])
                self.dividerL.alpha = 1
                self.dividerR.alpha = 1
            })
        }
    }
}
