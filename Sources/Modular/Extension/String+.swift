//
//  String+.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 26/07/21.
//  Copyright © 2021 Rattova's Dev. All rights reserved.
//

import Foundation

extension String {
    func normalized() -> String {
        var norma = self.replacingOccurrences(of: "ã", with: "a")
        norma = norma.replacingOccurrences(of: "â", with: "a")
        norma = norma.replacingOccurrences(of: "á", with: "a")
        norma = norma.replacingOccurrences(of: "à", with: "a")
        norma = norma.replacingOccurrences(of: "ä", with: "a")
        
        norma = norma.replacingOccurrences(of: "ê", with: "e")
        norma = norma.replacingOccurrences(of: "é", with: "e")
        norma = norma.replacingOccurrences(of: "è", with: "e")
        norma = norma.replacingOccurrences(of: "ë", with: "e")
        
        norma = norma.replacingOccurrences(of: "î", with: "i")
        norma = norma.replacingOccurrences(of: "í", with: "i")
        norma = norma.replacingOccurrences(of: "ì", with: "i")
        norma = norma.replacingOccurrences(of: "ï", with: "i")
        
        norma = norma.replacingOccurrences(of: "ô", with: "o")
        norma = norma.replacingOccurrences(of: "õ", with: "o")
        norma = norma.replacingOccurrences(of: "ó", with: "o")
        norma = norma.replacingOccurrences(of: "ò", with: "o")
        norma = norma.replacingOccurrences(of: "ö", with: "o")
        
        norma = norma.replacingOccurrences(of: "û", with: "u")
        norma = norma.replacingOccurrences(of: "u", with: "u")
        norma = norma.replacingOccurrences(of: "ú", with: "u")
        norma = norma.replacingOccurrences(of: "ù", with: "u")
        norma = norma.replacingOccurrences(of: "ü", with: "u")
        
        norma = norma.replacingOccurrences(of: "ç", with: "c")
        norma = norma.replacingOccurrences(of: "ñ", with: "n")
        
        norma = norma.replacingOccurrences(of: ", ", with: " ")
        norma = norma.replacingOccurrences(of: ",", with: " ")
        
        var clean = ""
        for w in norma {
            if w.isLetter || w == " " {
                clean.append(w)
            } else {
                clean.append(" ")
            }
        }
        
        return clean
    }
    
    func titleCase() -> String {
        return self
            .replacingOccurrences(of: "([A-Z])",
                                  with: " $1",
                                  options: .regularExpression,
                                  range: range(of: self))
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .capitalized // If input is in llamaCase
    }
}
