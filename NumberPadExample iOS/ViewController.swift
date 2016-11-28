//
//  ViewController.swift
//  NumberPadExample iOS
//
//  Created by Oleg Ketrar on 27.11.16.
//
//

import UIKit
import NumberPad

class ViewController: UIViewController {

    @IBOutlet private weak var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        textField.inputView = NumberPad(buttons: [])
                                .configure(with: textField)
                                .withInputController()
    }
}

