//
//  InputController.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 27.11.16.
//  Copyright © 2016 Oleg Ketrar. All rights reserved.
//

import UIKit

public protocol InputController: AnyObject {
    func keyPressed(_ key: String)
    func backspacePressed()
    func returnPressed()
}

public extension NumberPad {

    /// Uses system style with preferences from specified control.
    /// - parameter textInput: instance of control which conforms to `UITextInputTraits`.
    @discardableResult
    func with(styleFrom textInput: UITextInputTraits) -> Self {
        return with(style: SystemStyle(textInput))
    }

    /// Use custom input controller for handling keyboard events.
    @discardableResult
    func with(inputController: InputController) -> Self {

        return onTextInput { inputController.keyPressed($0) }
            .onBackspace { inputController.backspacePressed() }
            .onReturn { inputController.returnPressed() }
    }

    /// Handles text input & deletion & returnKey logic like system.
    @discardableResult
    func withStandardInputController() -> Self {
        return with(inputController: StandardInputController())
    }
}
