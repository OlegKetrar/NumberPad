//
//  KeyboardStyle.swift
//  NumberPad iOS
//
//  Created by Oleg Ketrar on 11.08.17.
//

import UIKit

/// Default implementaion represents default style.
public protocol KeyboardStyle {

    func fontFor(key: Key, state: Key.State) -> UIFont
    func titleColorFor(key: Key, state: Key.State) -> UIColor
    func titleFor(key: Key, state: Key.State) -> String?

    func imageFor(key: Key, state: Key.State) -> UIImage?
    func backgroundImageFor(key: Key, state: Key.State) -> UIImage?

    var separatorColor: UIColor { get }
    var separatorThickness: CGFloat { get }
}

public extension KeyboardStyle {

    func fontFor(key: Key, state: Key.State) -> UIFont {
        switch key {
        case .action:
            return UIFont.boldSystemFont(ofSize: 25)

        case .optional(.dot):
            return UIFont.boldSystemFont(ofSize: 30)

        default:
            return UIFont.systemFont(ofSize: 30)
        }
    }

    func titleColorFor(key: Key, state: Key.State) -> UIColor {
        switch (key, state) {
        case (.action, .normal):
            return .white
        default:
            return .darkText
        }
    }

    func titleFor(key: Key, state: Key.State) -> String? {
        switch key {
        case let .digit(number): return "\(number)"
        case .optional(.plus): return "+"
        case .optional(.dot): return "."
        case .action: return "Return"

        default:
            return nil
        }
    }

    func imageFor(key: Key, state: Key.State) -> UIImage? {
        switch (key, state) {
        case (.backspace, .normal): return defaultDeleteKeyImage
        case (.backspace, _): return defaultDeleteKeyImage

        default:
            return nil
        }
    }

    func backgroundImageFor(key: Key, state: Key.State) -> UIImage? {
        return UIImage(color:  {
            switch (key, state) {

            case (.action, .normal):
                return .init(red: 0, green: 0.479, blue: 1, alpha: 1)

            case (.digit, .normal),
                 (.action, _),
                 (.backspace, .selected),
                 (.backspace, .highlighted),
                 (.optional, .selected),
                 (.optional, .highlighted):
                return .white

            default:
                return .init(red: 0.82, green: 0.837, blue: 0.863, alpha: 1)
            }
        }())
    }

    var separatorColor: UIColor {
        return UIColor.groupTableViewBackground
    }

    var separatorThickness: CGFloat {
        return 2
    }

    func attributedTitleFor(key: Key, state: Key.State) -> NSAttributedString? {
        guard let titleStr = titleFor(key: key, state: state) else { return nil }

        return NSAttributedString(string: titleStr, attributes: [
            .font : fontFor(key: key, state: state),
            .foregroundColor : titleColorFor(key: key, state: state)
        ])
    }

    var defaultDeleteKeyImage: UIImage? {
        return UIImage(
            named: "deleteKey",
            in: .init(for: NumberPad.self),
            compatibleWith: nil)
    }
}
