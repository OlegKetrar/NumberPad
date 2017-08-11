//
//  InputController.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 27.11.16.
//  Copyright © 2016 Oleg Ketrar. All rights reserved.
//

import UIKit

// MARK: Handle text input and adopt it to UITextField & UITextView
// TODO: add handling of delegates shouldChangeCharactersInRange

public extension NumberPad {
	
	@discardableResult
	public func withInputController() -> Self {
		return onTextInput { (symbol) in
                (UIResponder.first as? UIKeyInput)?.insertText(symbol)
            }.onReturn {
				
				// find first responder
				guard let responder = UIResponder.first else { return }
				
				// ask known delegate
				let shouldReturn: Bool
				
				switch responder {
				case let textField as UITextField:
					shouldReturn = textField.delegate?.textFieldShouldReturn?(textField) ?? false
					
				default:
					shouldReturn = true
				}
				
				// dismiss keyboard
				if shouldReturn {
					responder.resignFirstResponder()
				}
				
			}.onDismiss {
				(UIResponder.first)?.resignFirstResponder()
			}.onBackspace {
				(UIResponder.first as? UIKeyInput)?.deleteBackward()
		}
	}
	
	@discardableResult
	public func configure(with textInput: UITextInputTraits) -> Self {

		if let keyboardReturnKey = textInput.returnKeyType {
			returnKeyTitle = keyboardReturnKey.localized
		}

        // TODO: add appearance
		
		return self
	}
}

// MARK: Cocoa FirstResponder Magic

fileprivate extension UIResponder {
	
	private struct SharedContainer {
		static var firstResponder: UIResponder?
	}
	
	/// this method will be called only on first responder
	/// cocoa will ask each responders by chain
	@objc private func _number_pad_findFirstResponder() {
		SharedContainer.firstResponder = self
	}
	
	static var first: UIResponder? {
		SharedContainer.firstResponder = nil
		UIApplication.shared.sendAction(#selector(_number_pad_findFirstResponder), to: nil, from: nil, for: nil)
		return SharedContainer.firstResponder
	}
}

// MARK:

fileprivate extension UITextField {
	fileprivate var selectedRange: NSRange {
		guard let textRange = selectedTextRange, !textRange.isEmpty else { return NSRange() }
		
		let startPosition = offset(from: beginningOfDocument, to: textRange.start)
		let endPosition   = offset(from: beginningOfDocument, to: textRange.end)
		
		return NSRange(location: startPosition, length: endPosition - startPosition)
	}
}

// MARK: UIReturnKeyType

fileprivate extension UIReturnKeyType {
	
	var localized: String {
		let UIKitBundle = Bundle(identifier: "com.apple.UIKit")
		
		switch self {
		case .done: return "Done".localized(with: UIKitBundle)
		case .next: return "Next".localized(with: UIKitBundle)
		case .go:   return "Go".localized(with: UIKitBundle)
		case .join: return "Join".localized(with: UIKitBundle)
		case .send: return "Send".localized(with: UIKitBundle)
		default:    return "Return".localized(with: UIKitBundle)
		}
	}
}

fileprivate extension String {
    func localized(with bundle: Bundle?) -> String {
        return bundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
}
