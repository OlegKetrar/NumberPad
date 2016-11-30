//
//  NumberPad.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 27.11.16.
//  Copyright © 2016 Oleg Ketrar. All rights reserved.
//

import UIKit

fileprivate enum ButtonType {
    case digit(Int)
    case plus
    case dot
    case backspace
    case hide
    case action
}

public class NumberPad: UIInputView, Reusable {
	
	public enum OptionalButton {
		case dot
		case plus
		case hide
	}
	
	public typealias AdditionalButtons = [OptionalButton]
	
	// MARK: 
	
	private let visualEffectView: UIVisualEffectView = {
		return UIVisualEffectView(frame: CGRect.zero)
	}()
	
	var returnKeyTitle: String = "Return" {
		didSet { actionButton.setTitle(returnKeyTitle, for: .normal) }
	}
	
	private var onTextInputClosure: (String) -> Void = { _ in }
	private var onBackspaceClosure: () -> Void       = {}
	private var onHideClosure:      () -> Void       = {}
	private var onActionClosure:    () -> Void       = {}
	
	private let additionalButtons: AdditionalButtons
	
	// MARK: - Outlets
	
	@IBOutlet private weak var contentView: UIView!
	
	@IBOutlet private var digitButtons: [UIButton]!

	@IBOutlet private weak var zeroButton: UIButton!
	@IBOutlet private weak var plusButton: UIButton!
	@IBOutlet private weak var dotButton: UIButton!
	@IBOutlet private weak var actionButton: UIButton!
	
	@IBOutlet private weak var hideButton: UIButton! {
		didSet {
            let hideImage = UIImage(named: "hideKey",
                                    in: Bundle(for: type(of: self)),
                                    compatibleWith: nil)

			hideButton.setTitle("", for: .normal)
			hideButton.imageView?.tintColor = UIColor.darkText
			hideButton.setImage(hideImage, for: .normal)
		}
	}
	
	@IBOutlet private weak var backspaceButton: LongPressButton! {
		didSet {
            let deleteImage = UIImage(named: "deleteKey",
                                      in: Bundle(for: type(of: self)),
                                      compatibleWith: nil)

			backspaceButton.setTitle("", for: .normal)
			backspaceButton.imageView?.tintColor = UIColor.darkText
			backspaceButton.setImage(deleteImage, for: .normal)
		}
	}
	
	// MARK: - Init
	
	override public init(frame: CGRect, inputViewStyle: UIInputViewStyle) {
		additionalButtons = []
		super.init(frame: frame, inputViewStyle: inputViewStyle)
		replaceWithNib()
		defaultConfiguring()
	}
	
	required public init?(coder aDecoder: NSCoder) {
		additionalButtons = []
		super.init(coder: aDecoder)
		replaceWithNib()
		defaultConfiguring()
	}
	
	public init(buttons: AdditionalButtons) {
		additionalButtons = buttons
		super.init(frame: CGRect.zero, inputViewStyle: .keyboard)
		replaceWithNib()
		defaultConfiguring()
		self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
	}
	
	private func defaultConfiguring() {
		
		// customizer buttons
		let normalFillColor    = UIColor.white
		let highlightFillColor = UIColor(colorLiteralRed: 0.82, green: 0.837, blue: 0.863, alpha: 1)
		let actionFillColor    = UIColor(colorLiteralRed: 0, green: 0.479, blue: 1, alpha: 1)
		
		let normalControlColor    = UIColor.darkText
		let highlightControlColor = UIColor.darkText
		
		(digitButtons + [hideButton, actionButton, backspaceButton, plusButton, dotButton]).forEach { (button) in
			button.setBackgroundImage(UIImage(color: normalFillColor), for: .normal)
			button.setBackgroundImage(UIImage(color: highlightFillColor), for: .highlighted)
			button.setBackgroundImage(UIImage(color: highlightFillColor), for: .selected)
			
			button.setTitleColor(normalControlColor, for: .normal)
			button.setTitleColor(highlightControlColor, for: .highlighted)
			button.setTitleColor(highlightControlColor, for: .selected)
			
			button.layer.borderColor = UIColor.groupTableViewBackground.cgColor
			button.layer.borderWidth = 1 / UIScreen.main.scale
		}
		
		// action button
		actionButton.setBackgroundImage(UIImage(color: actionFillColor), for: .normal)
		actionButton.setBackgroundImage(UIImage(color: normalFillColor), for: .highlighted)
		actionButton.setBackgroundImage(UIImage(color: normalFillColor), for: .selected)
		
		actionButton.setTitleColor(UIColor.white, for: .normal)
		actionButton.setTitleColor(normalControlColor, for: .highlighted)
		actionButton.setTitleColor(normalControlColor, for: .selected)
		
		actionButton.layer.borderWidth = 0
		
		// configure additional buttons
		if !additionalButtons.contains(.plus) {
			plusButton.removeFromSuperview()
			zeroButton.pinToSuperview(attribute: .left)
		}

		if !additionalButtons.contains(.dot) {
			dotButton.removeFromSuperview()
			zeroButton.pinToSuperview(attribute: .right)
		}
		
		if !additionalButtons.contains(.hide) {
			hideButton.removeFromSuperview()
			backspaceButton.pinToSuperview(attribute: .top)
		}

        // observe continius holds
        backspaceButton.addAction(forContiniusHoldWith: 0.1) { [weak self] in
            self?.didPress(button: .backspace)
        }
	}

	// MARK: - Actions
	
	@IBAction private func digitButtonDidPressed(_ button: UIButton) {
		
		// validate button tag (indexes is same as elements)
		guard let buttonDigit = (0..<10).index(of: button.tag - 1) else { return }
		didPress(button: .digit(buttonDigit))
	}
	
	@IBAction private func plusButtonDidPressed() {
		didPress(button: .plus)
	}
	
	@IBAction private func dotButtonDidPressed() {
		didPress(button: .dot)
	}

	@IBAction private func actionButtonDidPressed() {
		didPress(button: .action)
	}
	
	@IBAction private func hideButtonDidPressed() {
		didPress(button: .hide)
	}
	
	private func didPress(button: ButtonType) {
		
		// inform delegate
		switch button {
		case .digit(let digit): onTextInputClosure("\(digit)")
		case .dot:			    onTextInputClosure(".")
		case .plus:				onTextInputClosure("+")
		case .action:			onActionClosure()
		case .backspace:		onBackspaceClosure()
		case .hide:				onHideClosure()
		}
		
		// play click
		switch button {
		case .digit(_),
		     .backspace,
		     .dot,
		     .plus: UIDevice.current.playInputClick()
			
		default:
			break
		}
	}
	
	// MARK: -
	
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
	public func onDismiss(_ closure: @escaping () -> Void) -> Self {
		onHideClosure = closure
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
















