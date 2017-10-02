//
//  InputController.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 27.11.16.
//  Copyright © 2016 Oleg Ketrar. All rights reserved.
//

import UIKit

// TODO: add handling of delegates shouldChangeCharactersInRange

public extension NumberPad {

    /// Uses system style with preferences from sepcified control.
    /// - parameter textInput: instance of control which conforms to `UITextInputTraits`.
    @discardableResult
    public func with(styleFrom textInput: UITextInputTraits) -> Self {
        return with(style: SystemStyle(textInput))
    }

    /// Handles text input & deletion & returnKey logic like system.
    @discardableResult
    public func withStandardInputController() -> Self {
        return onTextInput { (symbol) in
            (UIResponder.first as? UIKeyInput)?.insertText(symbol)
        }.onBackspace {
            (UIResponder.first as? UIKeyInput)?.deleteBackward()
        }.onReturn {

            // find first responder
            guard let responder = UIResponder.first else { return }

            // ask known delegate
            let shouldReturn: Bool = {
                if let textField = responder as? UITextField {
                    return textField.delegate?.textFieldShouldReturn?(textField) ?? false
                } else {
                    return true
                }
            }()

            // dismiss keyboard
            if shouldReturn {
                responder.resignFirstResponder()
            }
        }
    }
}

// MARK: Cocoa FirstResponder Magic

private extension UIResponder {

    private struct SharedContainer {
        static var firstResponder: UIResponder?
    }

    /// This method will be called only on first responder.
    /// Cocoa will ask each responders by chain.
    @objc private func _number_pad_findFirstResponder() {
        SharedContainer.firstResponder = self
    }

    /// Current first responder.
    static var first: UIResponder? {
        SharedContainer.firstResponder = nil
        UIApplication.shared.sendAction(#selector(_number_pad_findFirstResponder), to: nil, from: nil, for: nil)
        return SharedContainer.firstResponder
    }
}
