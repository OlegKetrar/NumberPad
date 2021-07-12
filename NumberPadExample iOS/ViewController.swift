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
        numberTextView.autocorrectionType = .no

        // remove insertion of extra whitespace
        if #available(iOS 11, *) {
            systemTextField.smartInsertDeleteType = .no
            numberTextField.smartInsertDeleteType = .no
            numberTextView.smartInsertDeleteType = .no
        }

        numberTextField.inputView = NumberPad()
            .with(styleFrom: numberTextField)
            .withStandardInputController()

        numberTextView.inputView = NumberPad(optionalKey: .plus)
            .with(styleFrom: numberTextView)
            .withStandardInputController()

        systemTextField.delegate = self
        numberTextField.delegate = self
    }
}

extension ViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if textField === systemTextField {
            numberTextField.becomeFirstResponder()
        } else if textField === numberTextField {
            numberTextView.becomeFirstResponder()
        }

        return false
    }
}
