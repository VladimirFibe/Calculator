import SwiftUI

class RoundCornerButton: UIButton {
    open override var frame: CGRect {
        didSet {
            setCorner(radius: self.radius)
        }
    }
    open override var bounds: CGRect {
        didSet {
            setCorner(radius: self.radius)
        }
    }
    private var radius: CGFloat?
    func setCorner(radius: CGFloat?) {
        let height = min(frame.width, frame.height)
        if let radius = radius {
            self.radius = radius
            layer.cornerRadius = radius
        } else {
            layer.cornerRadius = height / 2
        }
        titleLabel?.font = .boldSystemFont(ofSize: height / 2)
        if titleLabel?.text == "0" {
            contentHorizontalAlignment = .leading
            if let widht = titleLabel?.intrinsicContentSize.width {
                titleEdgeInsets = UIEdgeInsets(top: 0,
                                               left: (height - widht) / 2,
                                               bottom: 0,
                                               right: 0)
            }
        }
    }
}
