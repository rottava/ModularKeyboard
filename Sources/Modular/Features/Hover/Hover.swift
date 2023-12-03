//
//  HoverFrame.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 20/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

/*
 Frame is entity for colision, contains a stack of hoverButton
 Roughly 2*height and (1+n)*w, where half w each side
*/
public class Hover: UIView {
    private var key: KeyboardButton
    private var dir = true
    private var fill = false
    
    private var shape: CAShapeLayer = {
        let shape = CAShapeLayer()
        shape.fillColor = KAsset.Colors.surface.color.cgColor
        shape.strokeColor = UIColor.black.withAlphaComponent(0.1).cgColor
        shape.shadowColor = UIColor.black.cgColor
        shape.shadowOpacity = 0.3
        shape.shadowOffset = .zero
        shape.shadowRadius = 2
        return shape
    }()
    
    private var stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.backgroundColor = .clear
        stack.distribution = .fillEqually
        //stack.isUserInteractionEnabled = false
        return stack
    }()
    
    init(key: KeyboardButton = KeyboardButton()) {
        self.key = key
        super.init(frame: key.frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.key = KeyboardButton()
        super.init(coder: coder)
    }
}

public extension Hover {
    func updateKey(with key: KeyboardButton, fill: Bool = false) {
        self.key = key
        self.fill = fill
        validateDir()
        generateFrame()
        generatePath()
        updateStack()
        setColor()
        //markFirst()
    }
    
    func getFirst() -> HoverButton? {
        return dir
            ? stack.arrangedSubviews.last as? HoverButton
            : stack.arrangedSubviews.first as? HoverButton
    }
    
    func showAll() {
        self.fill = true
        generateFrame()
        generatePath()
        updateStack()
        setColor()
        //markFirst()
    }
    
    func showFirst() {
        self.fill = false
        generateFrame()
        generatePath()
        updateStack()
        setColor()
        //markFirst()
    }
}

private extension Hover {
    func setup() {
        //self.isUserInteractionEnabled = false
        validateDir()
        generateFrame()
        generatePath()
        self.layer.addSublayer(shape)
        self.addSubview(stack)
        stack.fill(to: self)
        updateStack()
        setColor()
    }
    
    func setColor() {
        shape.fillColor = KConst.dark
            ? KAsset.Colors.surfaceDark.color.cgColor
            : KAsset.Colors.surface.color.cgColor
    }
    
    func validateDir() {
        let w = key.superview?.bounds.width ?? 0
        dir = key.frame.minX + CGFloat(key.variations.count) * key.frame.width > w
    }
    
    func generateFrame() {
        let c = fill ? key.variations.count : 1
        let y = key.superview?.frame.minY ?? 0
        var x = key.frame.minX//-(key.frame.width/2)
        if dir { x -=  key.frame.width * CGFloat(c-1) }
        let frame = CGRect(x: x,
                           y: y-key.frame.height,
                           width: CGFloat((c))*key.frame.width,//+1
                           height: key.frame.height*2)
        self.frame = frame
    }
    
    func generatePath() {
        let s: CGFloat = 5 // slope
        let r = KConst.radius
        let sp = KConst.spacing
        let ds = KConst.spacing*2
        let w = self.frame.width
        let h = self.frame.height
        let kw = key.frame.width
        let kw2 = kw/2.5
        let kh = key.frame.height
        let cp = dir ? w-sp : kw-sp //-(kw/2)
        let path = UIBezierPath()
        // StartPoint
        //path.move(to: CGPoint(x: r, y: 0))
        // TL UP Corner
        path.addArc(withCenter: (CGPoint(x: r-kw2, y: r+s)), radius: r, startAngle: CGFloat.pi, endAngle: CGFloat.pi*1.5, clockwise: true)
        // TOP UP → Line
        //path.addLine(to: CGPoint(x: w-r, y: 0))
        // TR UP Corner
        path.addArc(withCenter: (CGPoint(x: w-r+kw2, y: r+s)), radius: r, startAngle: CGFloat.pi*1.5, endAngle: 0, clockwise: true)
        // TOP ↓ Line
        //path.addLine(to: CGPoint(x: w, y: kh-r-s))
        // TR DOWN Corner
        path.addArc(withCenter: (CGPoint(x: w-r+kw2, y: kh-r)), radius: r, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        // TOP DOWN ← Line
        path.addLine(to: CGPoint(x: cp+s, y: kh))
        // /
        path.addLine(to: CGPoint(x: cp, y: kh+s))
        // BOTTOM ↓
        //path.addLine(to: CGPoint(x: cp, y: h-r))
        // BOTTOM RIGHT Corner
        path.addArc(withCenter: (CGPoint(x: cp-r, y: h-r-sp)), radius: r, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        // BOTTOM ←
        //path.addLine(to: CGPoint(x: cp-kw-r, y: h))
        // BOTTOM LEFT Corner
        path.addArc(withCenter: (CGPoint(x: cp-kw+r+ds, y: h-r-sp)), radius: r, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        // BOTTOM ↑
        path.addLine(to: CGPoint(x: cp-kw+ds, y: kh+s))
        // \
        path.addLine(to: CGPoint(x: cp-kw+ds-s, y: kh))
        // TOP UP ← Line
        //path.addLine(to: CGPoint(x: r, y: kh-s))
        // TL DOWN Corner
        path.addArc(withCenter: (CGPoint(x: -kw2+r, y: kh-r)), radius: r, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        // TOP ↑ Line
        //path.addLine(to: CGPoint(x: 0, y: r))
        
        path.close()
        shape.path = path.cgPath
        shape.shadowPath = path.cgPath
    }
    
    func updateStack() {
        for v in stack.arrangedSubviews {
            v.removeFromSuperview()
        }
        
        if (fill) {
            let kv = dir ? key.variations.reversed() : key.variations
            for v in kv {
                stack.addArrangedSubview(HoverButton(text: v))
            }
        } else {
            stack.addArrangedSubview(HoverButton(text: key.variations.first ?? "-"))
        }
    }
}
