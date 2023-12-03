//
//  ToolbarButton.swift
//  ModularKeyboard
//
//  Created by EdsonRottava on 03/06/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import UIKit

class ToolbarButton: UIView {
    let bgView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.isUserInteractionEnabled = false
        return view
    }()
    
    let label: UILabel = {
        let c = KConst.dark ? KAsset.Colors.textDark.color : KAsset.Colors.text.color
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        //label.isUserInteractionEnabled = false
        label.font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
        label.text = ""
        label.textAlignment = .center
        label.textColor = c
        return label
    }()
    
    convenience init(_ text: String?) {
        self.init(frame: CGRect())
        label.text = text
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
}

private extension ToolbarButton {
    func setup() {
        self.isUserInteractionEnabled = true
        self.backgroundColor = UIColor.black.withAlphaComponent(0.01)
        self.addSubview(bgView)
        bgView.fill(to: self, constant: KConst.spacing)
        bgView.addSubview(label)
        label.fill(to: bgView)
    }
}

extension ToolbarButton {
    func didSelect() {
        if (label.text?.isEmpty ?? true) { return }
        bgView.backgroundColor = KConst.dark
            ? KAsset.Colors.surfaceDark.color
            : KAsset.Colors.surface.color
    }
    
    func didDeselect() {
        bgView.backgroundColor = .clear
    }
    
    func refresh(with text: String?) {
        label.text = text
    }
}
