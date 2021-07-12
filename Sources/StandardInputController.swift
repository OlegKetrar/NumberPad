//
//  StandardInputController.swift
//  NumberPad iOS
//
//  Created by Oleg Ketrar on 18.10.17.
//

import UIKit

/// Standard input contoller.
/// Handles UITextField & UITextView.
final class StandardInputController: InputController {

    func keyPressed(_ key: String) {

        guard let textInput = UIResponder.first as? UITextInput,
            let selectedRange = textInput.selectedTextRange else { return }

        textInput.replaceText(at: selectedRange, with: key)
    }

    func backspacePressed() {

        guard
            let textInput = UIResponder.first as? UITextInput,
            let selectedRange = textInput.selectedTextRange,
            let startPosition = textInput.position(from: selectedRange.start, offset: -1),
            let rangeToDelete = textInput.textRange(from: startPosition, to: selectedRange.end)
        else { return }

        textInput.replaceText(at: rangeToDelete, with: "")
    }

    func returnPressed() {
        switch UIResponder.first {

        case let textField as UITextField:
            _ = textField.delegate?.textFieldShouldReturn?(textField)

        case let textView as UITextView:
            textView.insertText("\n")

        default:
            break
        }
    }
}

private extension UITextInput {

    func replaceText(at range: UITextRange, with text: String) {

        // calculate the NSRange for the textInput text in the UITextRange textRange
        let nsRange: NSRange = {
            let start  = offset(from: beginningOfDocument, to: range.start)
            let length = offset(from: range.start, to: range.end)

            return NSRange(location: start, length: length)
        }()

        if shouldChangeCharacters(in: nsRange, with: text) {
            replace(range, withText: text)
        }
    }

    private func shouldChangeCharacters(in range: NSRange, with string: String) -> Bool {
        switch self {

        case let textField as UITextField:
            return textField.delegate?.textField?(
                textField,
                shouldChangeCharactersIn: range,
                replacementString: string) ?? true

        case let textView as UITextView:
            return textView.delegate?.textView?(
                textView,
                shouldChangeTextIn: range,
                replacementText: string) ?? true

        default:
            return true
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

        UIApplication.shared.sendAction(
            #selector(_number_pad_findFirstResponder),
            to: nil,
            from: nil,
            for: nil)

        return SharedContainer.firstResponder
    }
}
