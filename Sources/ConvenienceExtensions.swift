//
//  ConvenienceExtensions.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 28.11.16.
//
//

import UIKit

// MARK: - Reusable

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nibName: String         { return String(describing: Self.self) }
    static var nib: UINib			   { return UINib(nibName: nibName, bundle: Bundle(for: self)) }
}

// MARK: Reusable UIView (loaded from nib)

extension Reusable where Self: UIView {
    func replaceWithNib() {
        if let reusableView = Self.nib.instantiate(withOwner: self, options: nil)[0] as? UIView {
            reusableView.backgroundColor = UIColor.clear
            reusableView.isOpaque        = false
            reusableView.clipsToBounds   = true

            addSubview(reusableView)
            addPinConstraints(toSubview: reusableView)
        }
    }
}

// MARK: - UIView + AutoLayout

extension UIView {

    func addPinConstraint(toSubview subview: UIView, attribute: NSLayoutAttribute, withSpacing spacing: CGFloat = 0) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addConstraint(NSLayoutConstraint(item: subview, attribute: attribute, relatedBy: .equal,
                                         toItem: self, attribute: attribute, multiplier: 1.0, constant: spacing))
    }

    func addPinConstraints(toSubview subview: UIView, withSpacing spacing: CGFloat = 0) {
        addPinConstraint(toSubview: subview, attribute: .left, withSpacing: spacing)
        addPinConstraint(toSubview: subview, attribute: .top, withSpacing: spacing)
        addPinConstraint(toSubview: subview, attribute: .right, withSpacing: -spacing)
        addPinConstraint(toSubview: subview, attribute: .bottom, withSpacing: -spacing)
    }

    /// pin current view to its superview with attribute
    func pinToSuperview(attribute: NSLayoutAttribute, spacing: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addPinConstraint(toSubview: self, attribute: attribute, withSpacing: spacing)
    }
}

// MARK: - UIImage

extension UIImage {

    convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        if let patternImage = image?.cgImage {
            self.init(cgImage: patternImage)
        } else {
            self.init()
        }
    }
}




