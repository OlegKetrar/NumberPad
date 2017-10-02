//
//  Key.swift
//  NumberPad iOS
//
//  Created by Oleg Ketrar on 11.08.17.
//

import Foundation

/// 
public enum Key {

    ///
    public enum Optional {
        case dot
        case plus
    }

    case digit(Int)
    case backspace
    case action
    case optional(Optional)

    public enum State {
        case normal
        case selected
        case highlighted
    }
}
