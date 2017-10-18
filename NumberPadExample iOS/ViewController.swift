//
//  ViewController.swift
//  NumberPadExample iOS
//
//  Created by Oleg Ketrar on 27.11.16.
//
//

import UIKit
import NumberPad

final class ViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet fileprivate weak var systemTextField: UITextField!
    @IBOutlet fileprivate weak var numberTextField: UITextField!
    @IBOutlet fileprivate weak var numberTextView: UITextView!

    // MARK: Overrides

    override func viewDidLoad() {
        super.viewDidLoad()

        // enabled autocorrection will increase keyboard height
        systemTextField.autocorrectionType = .no
        numberTextField.autocorrectionType = .no
        numberTextView.autocorrectionType  = .no

        // remove insertion of extra whitespace
        if #available(iOS 11, *) {
            systemTextField.smartInsertDeleteType = .no
            numberTextField.smartInsertDeleteType = .no
            numberTextView.smartInsertDeleteType  = .no
        }

        numberTextField.inputView = NumberPad()
            .with(styleFrom: numberTextField)
            .withStandardInputController()

        numberTextView.inputView = NumberPad(optionalKey: .plus)
            .with(styleFrom: numberTextView)
            .withStandardInputController()

        systemTextField.delegate = self
        numberTextField.delegate = self
        numberTextView.delegate  = self
    }
}

extension ViewController: UITextFieldDelegate, UITextViewDelegate {

    // MARK: UITextFieldDelegate

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {

        guard textField === numberTextField else { return true }

        let allowedChars = CharacterSet(charactersIn: "0123456789")
        let wholeString  = ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)
        let components   = wholeString.components(separatedBy: allowedChars.inverted)

        return components.count == 1 && wholeString.count <= 5
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField === systemTextField {
            numberTextField.becomeFirstResponder()
        } else if textField === numberTextField {
            numberTextView.becomeFirstResponder()
        }

        return false
    }

    // MARK: UITextViewDelegate

    func textView(
        _ textView: UITextView,
        shouldChangeTextIn range: NSRange,
        replacementText text: String) -> Bool {

        let wholeString = (textView.text as NSString).replacingCharacters(in: range, with: text)

        return wholeString.count <= 5
    }
}
