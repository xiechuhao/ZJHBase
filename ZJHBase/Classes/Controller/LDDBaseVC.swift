//
//  LDDBaseVC.swift
//  Created by HouWan
//

import UIKit

/**
 Base ViewController
 */
class LDDBaseVC: UIViewController {

    /// 是否需要执行某些事情，比如App切回前台，是否需要刷新等。默认是`false`
    lazy var needPerform = false

    /// 隐藏自带的`NavigationBar`，default: YES, (当前，前提是有`self.navigationController`)
    lazy var hiddenNavigationBar = true

    /// Custom navigation bar. default: nil
    weak var bar: LDDNavigationBar?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(0xF7F7F7)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let navc = navigationController, hiddenNavigationBar {
            navc.navigationBar.isHidden = true
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navc = navigationController, hiddenNavigationBar {
            navc.navigationBar.isHidden = true
        }
    }

    /// App没有隐藏状态栏的页面
    override var prefersStatusBarHidden: Bool { false }

    /// 默认`UIStatusBarStyleDefault`，特殊页面，子类去重写
    /// info.plist文件中有 View controller-based status bar appearance 属性
    /// 当设置为NO时 通过`UIApplication.shared.statusBarStyle = .lightContent`;
    /// 设置statusBar的整体样式，而且程序中不能修改。
    /// 当设置为YES时 在各个ViewController中通过`[preferredStatusBarStyle]`
    /// 方法修改statusBarStyle，UIApplication的方法不再生效。
    /// 项目默认的样式是UIStatusBarStyleDefault 也就是深色的样式。
    override var preferredStatusBarStyle: UIStatusBarStyle { .default }

    deinit {
        // Observers are automatically unregistered on dealloc (iOS 9 / macOS 10.11)
        // so you should't call `removeObserver(self)` in the deinit.
        // NotificationCenter.default.removeObserver(self)
    }
}

// =============================================================================
// MARK: - Methods
// =============================================================================

extension LDDBaseVC {

    /// 关闭当前控制 (有`navigationController`是pop，没有则是dismiss)
    ///
    /// - Parameter animated: 是否有动画，default: True
    @objc func pop(_ animated: Bool) {
        if let navc = navigationController {
            navc.popViewController(animated: animated)
            return
        }
        dismiss(animated: animated, completion: nil)
    }

    /// 关闭当前控制 (有`navigationController`是pop，没有则是dismiss)，此方法为了配合按钮的`#selector`调用
    @objc func popSelector() { pop(true) }

    /// 快捷创建一个白色的返回`<`箭头的导航栏
    /// - Parameter t: 导航栏标题，可以不传
    @discardableResult
    @objc func createLightNavigationBar(_ t: String? = nil) -> LDDNavigationBar {
        _createNavigationBar("common_back_white", t: t)
        // 这里有问题，创建出来的title颜色是黑色，没有去处理成白色
    }

    /// 快捷创建一个黑色的返回`<`箭头的导航栏
    /// - Parameter t: 导航栏标题，可以不传
    @discardableResult
    @objc func createDarkNavigationBar(_ t: String? = nil) -> LDDNavigationBar {
        _createNavigationBar("common_back_black", t: t)
    }

    /// 创建一个导航栏
    /// - Parameters:
    ///   - icon: 左侧Item的icon
    ///   - t: 导航栏标题，可以不传
    private func _createNavigationBar(_ icon: String, t: String?) -> LDDNavigationBar {
        if let tempBar = bar {
            tempBar.removeFromSuperview()
            bar = nil
        }

        let back = LDDNavigationIconItem(icon: UIImage(icon), target: self, action: #selector(popSelector))
        let tempBar = LDDNavigationBar()
        tempBar.addLeftItem(back)
        tempBar.title = t
        view.addSubview(tempBar)
        bar = tempBar
        return tempBar
    }
}
