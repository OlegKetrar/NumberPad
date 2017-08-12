//
//  NumberPad.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 27.11.16.
//  Copyright © 2016 Oleg Ketrar. All rights reserved.
//

import UIKit

///
public final class NumberPad: UIInputView, Reusable {

	/// Uses default style.
	private struct DefaultStyle: KeyboardStyle {}
	
	// MARK: 
	
	private let visualEffectView: UIVisualEffectView = {
		return UIVisualEffectView(frame: CGRect.zero)
	}()
	
	private var onTextInputClosure: (String) -> Void = { _ in }
	private var onBackspaceClosure: () -> Void       = {}
	private var onActionClosure:    () -> Void       = {}
	
	private let optionalKey: Key.Optional?
	
	// MARK: Outlets
	
	@IBOutlet private weak var contentView: UIView!
	@IBOutlet private weak var zeroButton: UIButton!
	@IBOutlet private weak var optionalButton: UIButton!
	@IBOutlet private weak var actionButton: UIButton!

	@IBOutlet private var digitButtons: [UIButton]!
	@IBOutlet private weak var backspaceButton: LongPressButton!

	// MARK: Init
	
	override public init(frame: CGRect, inputViewStyle: UIInputViewStyle) {
		optionalKey = nil
		super.init(frame: frame, inputViewStyle: inputViewStyle)
		replaceWithNib()
		defaultConfiguring()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		optionalKey = nil
		super.init(coder: aDecoder)
		replaceWithNib()
		defaultConfiguring()
	}
	
	public init(optionalKey: Key.Optional) {
		self.optionalKey = optionalKey
		super.init(frame: .zero, inputViewStyle: .keyboard)
		replaceWithNib()
		defaultConfiguring()
		autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	private func defaultConfiguring() {

		// adjust actionButton title font size
		actionButton.titleLabel?.numberOfLines             = 1
		actionButton.titleLabel?.adjustsFontSizeToFitWidth = true
		actionButton.titleLabel?.minimumScaleFactor        = 0.5
		actionButton.titleLabel?.lineBreakMode             = .byClipping

		// configure additional buttons
		if optionalKey == nil {
			optionalButton.removeFromSuperview()
			backspaceButton.pinToSuperview(attribute: .right)
		}

        // observe continius holds
        backspaceButton.addAction(forContiniusHoldWith: 0.1) { [weak self] in
            self?.didPress(key: .backspace)
        }

		// apply default style
		with(style: DefaultStyle())
	}

	// MARK: Actions
	
	@IBAction private func digitButtonDidPressed(_ button: UIButton) {
		
		// validate button tag (indexes is same as elements)
		guard let buttonDigit = (0..<10).index(of: button.tag - 1) else { return }
		didPress(key: .digit(buttonDigit))
	}

	@IBAction private func optionalButtonDidPressed() {
		guard let key = optionalKey else { return }
		didPress(key: .optional(key))
	}

	@IBAction private func actionButtonDidPressed() {
		didPress(key: .action)
	}

	private func didPress(key: Key) {
		
		// inform delegate
		switch key {
		case .digit(let digit): onTextInputClosure("\(digit)")
		case .optional(.plus):  onTextInputClosure("+")
		case .optional(.dot):   onTextInputClosure(".")
		case .action:			onActionClosure()
		case .backspace:		onBackspaceClosure()
		}
		
		// play click
		switch key {
		case .digit(_),
		     .backspace,
		     .optional: UIDevice.current.playInputClick()
			
		default:
			break
		}
	}
	
	// MARK: Configure

	/// Apply custom visual style to keyboard.
	@discardableResult
	public func with(style: KeyboardStyle) -> Self {

		var buttonsTuple: [(UIButton, Key)] = digitButtons.enumerated().map { ($1, .digit($0)) }
		buttonsTuple.append((actionButton, .action))
		buttonsTuple.append((backspaceButton, .backspace))

		if let optionalKey = optionalKey {
			buttonsTuple.append((optionalButton, .optional(optionalKey)))
		}

		buttonsTuple.forEach { (button, key) in
			button.setAttributedTitle(style.attributedTitleFor(key: key, state: .normal), for: .normal)
			button.setAttributedTitle(style.attributedTitleFor(key: key, state: .selected), for: .selected)
			button.setAttributedTitle(style.attributedTitleFor(key: key, state: .highlighted), for: .highlighted)

			button.setImage(style.imageFor(key: key, state: .normal), for: .normal)
			button.setImage(style.imageFor(key: key, state: .selected), for: .selected)
			button.setImage(style.imageFor(key: key, state: .highlighted), for: .highlighted)

			button.setBackgroundImage(style.backgroundImageFor(key: key, state: .normal), for: .normal)
			button.setBackgroundImage(style.backgroundImageFor(key: key, state: .selected), for: .selected)
			button.setBackgroundImage(style.backgroundImageFor(key: key, state: .highlighted), for: .highlighted)

			button.layer.borderWidth = 0.5 * style.separatorThickness
			button.layer.borderColor = style.separatorColor.cgColor
		}

		return self
	}

	@discardableResult
	public func onTextInput(_ closure: @escaping (String) -> Void) -> Self {
		onTextInputClosure = closure
		return self
	}
	
	@discardableResult
	public func onBackspace(_ closure: @escaping () -> Void) -> Self {
		onBackspaceClosure = closure
		return self
	}

    @discardableResult
	public func onReturn(_ closure: @escaping () -> Void) -> Self {
		onActionClosure = closure
		return self
	}
}

extension NumberPad: UIInputViewAudioFeedback {
	public var enableInputClicksWhenVisible: Bool { return true }
}
