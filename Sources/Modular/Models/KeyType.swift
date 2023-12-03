//
//  KeyType.swift
//  ModularKeyboard
//
//  Created by Edson Rottava on 21/05/21.
//  Copyright © 2020 Rattova's Dev. All rights reserved.
//

import UIKit

public enum KeyType: Int {
    case alphabetic // Change to Alphabet
    case backspace  // Delete last char
    case char       // Input char
    case emoji      // Change to Emoji
    case enter      // Return or new line
    case globe      // Chage to next system keyboard
    case numeric    // Change to Numeric
    case space      // Input space
    case shift      // Change to some variant
    case symbolic   // Change to Symbolic
}
