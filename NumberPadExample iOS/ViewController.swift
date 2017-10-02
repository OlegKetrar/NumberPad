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
    @IBOutlet private weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // enabled autocorrection will increase keyboard height
        textField.autocorrectionType = .no

        textField.inputView = NumberPad()
            .with(styleFrom: textField)
            .withStandardInputController()

        textField.becomeFirstResponder()
    }
}
