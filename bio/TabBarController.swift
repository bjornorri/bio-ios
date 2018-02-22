//
//  TabBarController.swift
//  bio
//
//  Created by Bjorn Orri Saemundsson on 19/02/2018.
//  Copyright © 2018 Bjorn Orri Saemundsson. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    let circle = FloatingCircle()
    let overlay = UIView()

    let animatioDuration = 0.15

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupViews()
    }

    func setupViews() {
        let size = CGFloat(64)
        circle.frame = CGRect(x: view.bounds.midX - 30, y: view.bounds.maxY - 80, width: size, height: size)
        let circleGesture = TouchGestureRecognizer(target: self, action: #selector(toggleTabBar))
        circle.addGestureRecognizer(circleGesture)

        overlay.frame = view.bounds
        overlay.backgroundColor = UIColor.black
        overlay.alpha = 0.0
        let overlayGesture = TouchGestureRecognizer(target: self, action: #selector(toggleTabBar))
        overlay.addGestureRecognizer(overlayGesture)

        let tabBarGesture = TouchGestureRecognizer(target: self, action: #selector(touchedTabBar))
        tabBar.addGestureRecognizer(tabBarGesture)

        view.insertSubview(overlay, belowSubview: tabBar)
        view.addSubview(circle)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setTabBar(visible: false, animated: false)
    }

    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        guard let viewControllers = viewControllers else { return }
        for vc in viewControllers {
            if let navVC = vc as? UINavigationController {
                navVC.delegate = self
            }
        }
    }

    private func setTabBar(visible: Bool, animated: Bool) {
        if tabBar.isHidden == !visible { return }
        if !animated {
            setTabBar(visible: visible)
            tabBar.isHidden = !visible
            return
        }
        if visible { tabBar.isHidden = false }
        UIView.animate(withDuration: animatioDuration, animations: {
            self.setTabBar(visible: visible)
        }, completion: {_ in
            if !visible { self.tabBar.isHidden = true }
        })
    }

    private func setTabBar(visible: Bool) {
        let tabBarHeight = tabBar.frame.height
        let y = visible ? view.bounds.maxY - tabBarHeight : view.bounds.maxY
        overlay.alpha = visible ? 0.8 : 0.0
        tabBar.frame = tabBar.frame.offsetBy(dx: 0, dy: y - tabBar.frame.minY)
        circle.setTransformed(visible)
        circle.frame = visible ? tabBarCircleFrame() : normalCircleFrame()
    }

    @objc func toggleTabBar(gesture: UIGestureRecognizer) {
        setTabBar(visible: tabBar.isHidden, animated: true)
    }

    @objc func touchedTabBar(gesture: TouchGestureRecognizer) {
        guard let viewControllers = viewControllers else { return }
        let point = gesture.location(in: tabBar)
        let subviews = tabBar.subviews.filter{ $0.isUserInteractionEnabled }.sorted(by: { $0.frame.minX < $1.frame.minX })
        for (i, item) in subviews.enumerated() {
            if item.frame.contains(point) {
                if tabBarController(self, shouldSelect: viewControllers[i]) {
                    selectedIndex = i
                    tabBar(tabBar, didSelect: tabBar.items![i])
                }
                return
            }
        }
    }

    private func setCircle(visible: Bool, animated: Bool) {
        if !animated {
            setCircle(visible: visible)
            return
        }
        UIView.animate(withDuration: animatioDuration) {
            self.setCircle(visible: visible)
        }
    }

    private func setCircle(visible: Bool) {
        if visible {
            circle.frame = normalCircleFrame()
        } else {
            circle.frame = hiddenCircleFrame()
        }
    }

    private func normalCircleFrame() -> CGRect {
        let bottomMargin = view.safeAreaInsets.bottom > 0 ? view.safeAreaInsets.bottom : 20
        let size = CGFloat(60)
        let x = view.bounds.midX - size / 2.0
        let y = view.bounds.maxY - bottomMargin - size
        return CGRect(x: x, y: y, width: size, height: size)
    }

    private func tabBarCircleFrame() -> CGRect {
        let frame = normalCircleFrame()
        let tabBarHeight = tabBar.frame.height
        let y = view.bounds.maxY - tabBarHeight - 6
        return frame.offsetBy(dx: 0, dy: y - frame.minY)
    }

    private func hiddenCircleFrame() -> CGRect {
        let frame = normalCircleFrame()
        let y = view.bounds.maxY
        return frame.offsetBy(dx: 0, dy: y - frame.minY)
    }

    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        setTabBar(visible: false, animated: true)
    }
}

extension TabBarController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count > 1 {
            setCircle(visible: false, animated: true)
        }
    }

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count == 1 {
            setCircle(visible: true, animated: true)
        }
    }
}

extension TabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if selectedViewController == nil || viewController == selectedViewController {
            return false
        }
        guard let fromView = selectedViewController?.view else { return true }
        guard let toView = viewController.view else { return true }
        UIView.transition(from: fromView, to: toView, duration: 0.1, options: [.transitionCrossDissolve], completion: nil)
        return true
    }
}
