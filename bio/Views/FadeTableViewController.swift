//
//  FadeTableViewController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 17/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

protocol FadeView {
    var foreground: UIView { get }
}

class FadeTableViewController: UITableViewController {

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let header = tableView.tableHeaderView {
            updateMask(forView: header)
        }
        for cell in tableView.visibleCells {
            updateMask(forView: cell)
        }
    }

    private func updateMask(forView view: UIView) {
        var v = view
        if let fadeView = view as? FadeView {
            v = fadeView.foreground
        }
        if v.mask == nil {
            v.mask = GradientView(frame: view.bounds)
        }
        let maskY = tableView.contentOffset.y - view.frame.minY
        v.mask?.frame = CGRect(x: 0, y: maskY, width: v.bounds.width, height: v.bounds.height - maskY)
    }
}

