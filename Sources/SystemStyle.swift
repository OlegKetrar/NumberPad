//
//  asd.swift
//  NumberPad iOS
//
//  Created by Oleg Ketrar on 12.08.17.
//

import Foundation

// TODO: iOS 10 light & dark style
// TODO: iOS 11 light & dark style

private struct DefaultStyle: KeyboardStyle {}

/// Uses `returnKeyType` & `keyboardAppearance` for styling.
struct SystemStyle {
    fileprivate let returnKeyType: UIReturnKeyType

    init(_ traits: UITextInputTraits) {
        returnKeyType = traits.returnKeyType ?? .default

        // TODO: get appearance
    }
}

extension SystemStyle: KeyboardStyle {

    func titleColorFor(key: Key, state: Key.State) -> UIColor {

        guard case .action = key else {
            return DefaultStyle().titleColorFor(key: key, state: state)
        }

        switch (returnKeyType, state) {
        case (.search, .normal),
             (.done, .normal),
             (.join, .normal),
             (.send, .normal),
             (.go, .normal) : return .white

        default:
            return .darkText
        }
    }

    func titleFor(key: Key, state: Key.State) -> String? {
        guard case .action = key else {
            return DefaultStyle().titleFor(key: key, state: state)
        }

        return returnKeyType.localized
    }

    func backgroundImageFor(key: Key, state: Key.State) -> UIImage? {
        guard case .action = key else {
            return DefaultStyle().backgroundImageFor(key: key, state: state)
        }

        return UIImage(color: {
            switch (returnKeyType, state) {
            case (.search, .normal),
                 (.done, .normal),
                 (.join, .normal),
                 (.send, .normal),
                 (.go, .normal): return .init(red: 0, green: 0.479, blue: 1, alpha: 1)

            case (.default, .normal):
                return .init(red: 0.82, green: 0.837, blue: 0.863, alpha: 1)

            default:
                return .white
            }
        }())
    }
}

// MARK: UIReturnKeyType localization

private extension UIReturnKeyType {

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

private extension String {
    func localized(with bundle: Bundle?) -> String {
        return bundle?.localizedString(forKey: self, value: "", table: nil) ?? self
    }
}
