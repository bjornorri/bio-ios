//
//  DeepLinkManager.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 02/03/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class DeepLinkManager {

    static let shared = DeepLinkManager()

    private init() {}

    func openLink(_ link: String) {
        let prefix = "bio://"
        guard link.starts(with: prefix) else { return }
        let path = link.dropFirst(prefix.count)
        var parts = path.split(separator: "/").reversed().map { String($0) }

        guard let tab = parts.popLast(),
        let tabIndex = ["showtimes", "upcoming"].index(of: tab) else { return }
        selectTab(tabIndex)

        guard let imdbId = parts.popLast() else { return }
        pushDetailVC(withImdbId: imdbId)
    }

    private func selectTab(_ index: Int) {
        guard let window = UIApplication.shared.keyWindow,
        let tabVC = window.rootViewController as? UITabBarController else { return }
        tabVC.selectedIndex = index
    }

    private func pushDetailVC(withImdbId imdbId: String) {
        guard let window = UIApplication.shared.keyWindow,
        let tabVC = window.rootViewController as? UITabBarController,
        let navVC = tabVC.selectedViewController as? UINavigationController else { return }

        navVC.popToRootViewController(animated: false)
        guard let currentVC = navVC.visibleViewController else { return }

        let detailVC = ShowtimeDetailViewController()
        detailVC.imdbId = imdbId
        currentVC.show(detailVC, sender: nil)
    }
}

