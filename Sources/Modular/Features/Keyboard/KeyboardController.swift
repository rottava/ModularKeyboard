//
//  KeyboardController.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 25/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//
// https://stackoverflow.com/a/58543417
import UIKit

open class KeyboardController: UIInputViewController {
    let textChecker = UITextChecker()
    let toolbarView = UIView()
    let keyboardView = UIView()
    
    var currentKey: KeyboardButton = KeyboardButton()
    var currentKeyboard: Keyboard = Keyboard(.PTBRup())
    let hover: Hover = Hover(key: KeyboardButton())
    var hoverKey: HoverButton?
    var lastKey: KeyType = .char
    
    lazy var toolbar: Toolbar = Toolbar()
    var toolbarKey: ToolbarButton?
    
    var hconst: NSLayoutConstraint?
    var wconst: NSLayoutConstraint?
    var tconst: NSLayoutConstraint?
    var sconst: NSLayoutConstraint?
    
    var capsLock = false
    var longPress = false
    var doubleTap = false
    var delCount = 0
    
    var longTimer: Timer?
    var doubleTimer: Timer?
        
    let bgView: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fill
        return view
    }()
    
    let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fill
        return view
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        KConst.inputController = self
        //setup()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //setup()
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.toolbarView.removeFromSuperview()
        self.keyboardView.removeFromSuperview()
        self.hover.removeFromSuperview()
        doubleTimer?.invalidate()
        longTimer?.invalidate()
    }
    
    open override func selectionWillChange(_ textInput: UITextInput?) {
        super.selectionWillChange(textInput)
        resetAutocomplete()
    }
    
    open override func selectionDidChange(_ textInput: UITextInput?) {
        super.selectionDidChange(textInput)
        resetAutocomplete()
    }
    
    open override func textDidChange(_ textInput: UITextInput?) {
        super.textDidChange(textInput)
        performAutocomplete()
    }
    
    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        //setupKeyboard()
        reloadView()
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        //setupKeyboard()
        reloadView()
    }
    
}
// MARK: Internal Funcitions
public extension KeyboardController {
    func setup() {
        view.translatesAutoresizingMaskIntoConstraints = false
        
        hconst?.isActive = false
        hconst = view.heightAnchor.constraint(equalToConstant: Keyboard.getHeight() + Keyboard.getToolbarHeight()/4)
            hconst?.isActive = true
        
        wconst?.isActive = false
        wconst = view.widthAnchor.constraint(equalToConstant: Keyboard.getWidth())
            wconst?.isActive = true
        
        bgView.backgroundColor = KConst.dark
            ? KAsset.Colors.backgroundDark.color.withAlphaComponent(0.8)
            : .clear
        
        setupStack()
        //setupKeyboard()
        checkUpdateKeyboard()
    }
    
    func setupStack() {
        let a = UIView()
        let b = UIView()
        
        view.addSubview(bgView)
        bgView.fill(to: view)
        stackView.removeFromSuperview()
        
        bgView.addArrangedSubview(a)
        bgView.addArrangedSubview(stackView)
        bgView.addArrangedSubview(b)
        b.size(equalTo: a)
        
        stackView.addArrangedSubview(toolbarView)
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        tconst = toolbarView.heightAnchor.constraint(equalToConstant: Keyboard.getToolbarHeight())
        tconst?.isActive = true
        
        stackView.addArrangedSubview(keyboardView)
        //keyboardView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setupKeyboard() {
        switch currentKeyboard.keyboard.type {
        case .lowercase:
            updateKeyboard(with: Keyboard(.PTBRlo()))
        case .uppercase:
            updateKeyboard(with: Keyboard(.PTBRup()))
        case .symbolic:
            updateKeyboard(with: Keyboard(.SYMB()))
        case .numeric:
            updateKeyboard(with: Keyboard(.NUMB()))
        }
    }
    
    func reloadView() {
        bgView.backgroundColor = KConst.dark
            ? KAsset.Colors.backgroundDark.color.withAlphaComponent(0.8)
            : .clear
        hconst?.constant = Keyboard.getHeight() + Keyboard.getToolbarHeight()/4
        wconst?.constant = Keyboard.getWidth()
        tconst?.constant = Keyboard.getToolbarHeight()
        setupKeyboard()
    }
    
    func fullText() ->  String {
        let b = textDocumentProxy.documentContextBeforeInput ?? ""
        let a = textDocumentProxy.documentContextAfterInput ?? ""
        return b+a
    }
    
    func updateKeyboard(with keyboard: Keyboard) {
        currentKeyboard.removeFromSuperview()
        currentKeyboard = keyboard
        keyboardView.addSubview(currentKeyboard)
        currentKeyboard.fill(to: keyboardView)
        //keyboardView.sendSubviewToBack(currentKeyboard)
        lastKey = .alphabetic //placeholder
    }
    
    func checkUpdateKeyboard() {
        let b = textDocumentProxy.documentContextBeforeInput ?? ""
        switch currentKey.type {
        case .backspace:
            switch currentKeyboard.keyboard.type {
            case .lowercase:
                if (b.isEmpty || b.hasSuffix(". ")) {
                    updateKeyboard(with: Keyboard(.PTBRup()))
                }
            case .uppercase:
                if (b.last?.isLowercase ?? false) {
                    updateKeyboard(with: Keyboard(.PTBRlo()))
                }
            default:
                break
            }
        case .char:
            if(b.isEmpty) {
                updateKeyboard(with: Keyboard(.PTBRup()))
            } else {
                if (currentKeyboard.keyboard.type == .uppercase && !capsLock) {
                    updateKeyboard(with: Keyboard(.PTBRlo()))
                }
            }
        case .enter:
            if (currentKeyboard.keyboard.type == .lowercase) {
                updateKeyboard(with: Keyboard(.PTBRup()))
            }
        case .space:
            if (currentKeyboard.keyboard.type == .lowercase && b.hasSuffix(". ")) {
                updateKeyboard(with: Keyboard(.PTBRup()))
            }
        default:
            break
        }
    }
    
    func touchStart(at key: KeyboardButton) {
        //TODO SOUND FOR EACH KEYTYPE
        DispatchQueue.main.async {
            self.audioFeedback(of: key.type)
        }
        turnOnKey()
    }
    
    func touchEnd() {
        //TODO REMOVE ANIMATION FROM LASTKEY
        turnOffKey()
        performAutocomplete()
    }
    
    func getSurfaceColor() -> UIColor {
        return KConst.dark
            ? KAsset.Colors.surfaceDark.color
            : KAsset.Colors.surface.color
    }
    
    func getSystemColor() -> UIColor {
        return KConst.dark
            ? KAsset.Colors.systemDark.color
            : KAsset.Colors.system.color
    }
}

// MARK: Timers
public extension KeyboardController {
    func startLongTimer() {
        endLongTimer()
        longPress = false
        longTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(handleLongTimer),
                                         userInfo: nil,
                                         repeats: false)
    }
    
    func endLongTimer() {
        longPress = false
        longTimer?.invalidate()
    }
    
    @objc
    func handleLongTimer() {
        longPress = true
        if (hover.superview != nil) {
            hover.showAll()
            hoverKey = hover.getFirst()
            hoverKey?.mark()
        }
    }
    
    func startDoubleTimer() {
        endLongTimer()
        doubleTap = true
        doubleTimer = Timer.scheduledTimer(timeInterval: 0.2,
                                         target: self,
                                         selector: #selector(handleDoubleTimer),
                                         userInfo: nil,
                                         repeats: false)
    }
    
    func endDoubleTimer() {
        doubleTap = false
        doubleTimer?.invalidate()
    }
    
    @objc
    func handleDoubleTimer() {
        doubleTap = false
    }
    
}
