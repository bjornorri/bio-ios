//
//  Extensions.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 11/01/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import AVKit
import UIKit
import RxSwift
import XCDYouTubeKit

extension UIColor {

    convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    static let bioGray = UIColor(red: 31, green: 31, blue: 31)
    static let bioYellow = UIColor(red: 226, green: 176, blue: 28)
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

    func isThisYear() -> Bool {
        return Calendar.current.component(.year, from: self) == Calendar.current.component(.year, from: Date())
    }

    func releaseDateString() -> String {
        let formatter = DateFormatter()
        if isThisYear() {
            formatter.dateFormat = "d. MMMM"
        } else {
            formatter.dateFormat = "d. MMMM YYYY"
        }
        formatter.locale = Locale(identifier: "is-IS")
        return formatter.string(from: self)
    }

    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }

    func isPast() -> Bool {
        return self.compare(Date()) == .orderedAscending
    }
}

extension UIViewController: PosterViewDelegate {

    func playTrailer(_ movie: Movie) {
        guard let trailerId = movie.trailerId else { return }

        let playerVC = AVPlayerViewController()
        playerVC.entersFullScreenWhenPlaybackBegins = true
        playerVC.exitsFullScreenWhenPlaybackEnds = true
        self.present(playerVC, animated: true)

        let keys: [AnyHashable] = [XCDYouTubeVideoQualityHTTPLiveStreaming, XCDYouTubeVideoQuality.HD720.rawValue, XCDYouTubeVideoQuality.medium360.rawValue, XCDYouTubeVideoQuality.small240.rawValue]

        XCDYouTubeClient.default().getVideoWithIdentifier(trailerId) { [weak playerVC] (video, error) in
            let streams = keys.map({ video?.streamURLs[$0] }).flatMap({ $0 })
            if let streamURL = streams.first {
                playerVC?.player = AVPlayer(url: streamURL)
                playerVC?.player?.play()
            } else {
                playerVC?.dismiss(animated: true)
            }
        }
    }
}

extension UITableView {

    func reloadData(animated: Bool) {
        if !animated {
            reloadData()
            return
        }
        UIView.transition(with: self, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.reloadData()
        })
    }
}

