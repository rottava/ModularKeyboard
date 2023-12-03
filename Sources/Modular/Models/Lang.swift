//
//  Lang.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 21/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

public typealias CharKey = [String]

public class Lang {
    let type: KeyboardType
    let first: [CharKey]
    let second: [CharKey]
    let thirth: [CharKey]
    
    init(first: [CharKey], second: [CharKey], thirth: [CharKey], type: KeyboardType){
        self.first = first
        self.second = second
        self.thirth = thirth
        self.type = type
    }
}

public extension Lang {
    class func PTBRlo() -> Lang {
        let first = [["q"],
                     ["w"],
                     ["e","é","ê","è","ė","ē","ë"],
                     ["r"],
                     ["t"],
                     ["y"],
                     ["u","ú","ü","ù","û","ū"],
                     ["i","í","î","ì","ï","ī"],
                     ["o","ó","õ","ô","ò","ö","ø","ō","º"],
                     ["p"]]
        let second = [["a","á","ã","à","â","ä","å","ª"],
                      ["s"],
                      ["d"],
                      ["f"],
                      ["g"],
                      ["h"],
                      ["j"],
                      ["k"],
                      ["l"]]
        let thirth = [["z"],
                      ["x"],
                      ["c","ç"],
                      ["v"],
                      ["b"],
                      ["n","ñ"],
                      ["m"]]
        return Lang(first: first, second: second, thirth: thirth, type: .lowercase)
    }
    
    class func PTBRup() -> Lang {
        let first = [["Q"],
                     ["W"],
                     ["E","É","Ê","È","Ė","Ē","Ë"],
                     ["R"],
                     ["T"],
                     ["Y"],
                     ["U","Ú","Ü","Ù","Û","Ū"],
                     ["I","Í","Î","Ì","Ï","Ī"],
                     ["O","Ó","Õ","Ô","Ò","Ö","Ø","Ō","º"],
                     ["P"]]
        let second = [["A","Á","Ã","À","Â","Ä","Å","ª"],
                      ["S"],
                      ["D"],
                      ["F"],
                      ["G"],
                      ["H"],
                      ["J"],
                      ["K"],
                      ["L"]]
        let thirth = [["Z"],
                      ["X"],
                      ["C","Ç"],
                      ["V"],
                      ["B"],
                      ["N","Ñ"],
                      ["M"]]
        return Lang(first: first, second: second, thirth: thirth, type: .uppercase)
    }
    
    class func NUMB() -> Lang {
        let first = [["1","1º","1ª"],
                     ["2","2º","2ª"],
                     ["3","3º","3ª"],
                     ["4","4º","4ª"],
                     ["5","5º","5ª"],
                     ["6","6º","6ª"],
                     ["7","7º","7ª"],
                     ["8","8º","8ª"],
                     ["9","9º","9ª"],
                     ["0","°"]]
        let second = [["-","–","—","•"],
                      ["/","\\"],
                      [":"],
                      [";"],
                      ["("],
                      [")"],
                      ["$","€","£","¥","₩","₽"],
                      ["&","§"],
                      ["@"],
                      ["“","\"","”","„","»","«"]]
        let thirth = [[".","…"],
                      [","],
                      ["?","¿"],
                      ["!","¡"],
                      ["‘","’","'","`"]]
        return Lang(first: first, second: second, thirth: thirth, type: .numeric)
    }
    
    class func SYMB() -> Lang {
        let first = [["["],
                     ["]"],
                     ["{"],
                     ["}"],
                     ["#"],
                     ["%","‰"],
                     ["^"],
                     ["*"],
                     ["+"],
                     ["=","≠","≈"]]
        let second = [["_"],
                      ["\\"],
                      ["|"],
                      ["~"],
                      ["<"],
                      [">"],
                      ["€"],
                      ["£"],
                      ["¥"],
                      ["•"]]
        let thirth = [[".","…"],
                      [","],
                      ["?","¿"],
                      ["!","¡"],
                      ["‘","’","'","`"]]
        return Lang(first: first, second: second, thirth: thirth, type: .symbolic)
    }
}
