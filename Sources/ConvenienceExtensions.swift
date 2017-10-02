//
//  ConvenienceExtensions.swift
//  NumberPad
//
//  Created by Oleg Ketrar on 28.11.16.
//
//

import UIKit

protocol Reusable: class {
    static var reuseIdentifier: String { get }
    static var nibName: String { get }
}

extension Reusable {
    static var reuseIdentifier: String { return String(describing: Self.self) }
    static var nibName: String         { return String(describing: Self.self) }
    static var nib: UINib              { return UINib(nibName: nibName, bundle: Bundle(for: self)) }
}

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

extension UIImage {

    /// Creates image with specified color.
    /// - parameter color: specified color with alpha.
    /// - parameter size: image size, default 1x1.
    convenience init?(color: UIColor, size: CGSize = .init(width: 1, height: 1)) {

        let image: UIImage? = {
            defer { UIGraphicsEndImageContext() }

            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            color.setFill()
            UIRectFill(.init(origin: .zero, size: size))

            return UIGraphicsGetImageFromCurrentImageContext()
        }()

        guard let createdImage = image,
            let patternImage = createdImage.cgImage else { return nil }

        self.init(cgImage: patternImage, scale: createdImage.scale, orientation: createdImage.imageOrientation)
    }
}
