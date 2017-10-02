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

        textField.returnKeyType = .done

        textField.inputView = NumberPad(optionalKey: .plus)
            .with(styleFrom: textField)
            .withStandardInputController()

        textField.becomeFirstResponder()
    }
}
