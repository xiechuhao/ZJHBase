//
//  LDDNavigationController.swift
//
//  Created by HouWan
//

import UIKit

class LDDNavigationController: UINavigationController {

    // =============================================================================
    // MARK: - Propertys
    // =============================================================================

    override var childForStatusBarHidden: UIViewController? {
        presentedViewController ?? topViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        presentedViewController ?? topViewController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .default }

    override var prefersStatusBarHidden: Bool { false }

    // =============================================================================
    // MARK: - Methods
    // =============================================================================

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if !viewControllers.isEmpty {
            viewController.hidesBottomBarWhenPushed = true
        }
        super.pushViewController(viewController, animated: animated)
    }
}
