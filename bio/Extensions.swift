//
//  Extensions.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    static let bioGray = UIColor(red: 31, green: 31, blue: 31)
    static let bioOrange = UIColor.orange
}

extension UIFont {

    static let myriadBoldCond = UIFont(name: "MyriadPro-BoldCond", size: 17)!
}

extension UIImageView {

    func stylePosterView() {
        layer.borderColor = UIColor.white.withAlphaComponent(0.7).cgColor
        layer.borderWidth = 1.0
        contentMode = .scaleAspectFill
        clipsToBounds = true
    }
}

extension String {

    func attributedInfoString() -> NSAttributedString {
        let aString = NSMutableAttributedString(string: self, attributes: [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 12)])
        self.enumerateSubstrings(in: startIndex ..< endIndex, options: .byWords) { sub, range, enclosingRange, _ in
            let substring = self[enclosingRange]
            if substring.hasSuffix(": ") {
                aString.addAttribute(.font, value: UIFont.boldSystemFont(ofSize: 13), range: NSRange(range, in: self))
            }
        }
        return aString
    }

    func toURL() -> URL? {
        let encoded = self.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed) ?? self
        return URL(string: encoded)
    }
}

extension Date {

    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        return formatter.string(from: self)
    }

    func isPast() -> Bool {
        return self.compare(Date()) == .orderedAscending
    }
}
