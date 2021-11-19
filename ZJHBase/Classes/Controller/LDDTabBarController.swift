//
//  LDDTabBarController.swift
//
//  Created by HouWan
//

import UIKit
import ZJHHome
import ZJHMe

/// [Notification key] 双击`TabBar`通知key
let NDoubleTapTabBarNotification = NSNotification.Name("DoubleTapTabBar")

/// 项目根控制器 TabBarController
class LDDTabBarController: UITabBarController {
    /// 发送这个通知，让`LDDTabBarController`主动选中到某个控制器
    static let NTabBarToNotification = NSNotification.Name("NTabBarToNotification")
    /// 通知`NTabBarToNotification`的带参数userInfo里面的key，值是`Int`
    static let Index: String = "index"
    /// 临时柜
    private var cabinetBtn: UIButton!
    var cabinetCenter: CGPoint = .zero
    var startCenter: CGPoint = .zero
    var isHaveTempLocker: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // 0.Config
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 2.KVC替换自己的`tabBar`
        let tabBar = LDDTabBar()
        tabBar.tabBarDelegate = self
        setValue(tabBar, forKeyPath: "tabBar")

        // 3.自定义了`TabBar`
        addChild("首页",
                 "tab_home_unselected",
                 "tab_home_selected", HomeViewController.self)
//
//        addChild("运动",
//                 "tab_sport_unselected",
//                 "tab_sport_selected", LDDSportMainVC.self)
//
        addChild("我的",
                 "tab_me_unselected",
                 "tab_me_selected", MeViewController.self)

//        LDDNotification.addObserver(self, selector: #selector(getChooseToVC(_:)), name: Self.NTabBarToNotification, object: nil)
//        LDDNotification.addObserver(self, selector: #selector(changeCabAction(_:)), name: NSPanCabinetNotification, object: nil)
    }

    @objc func changeCabAction(_ click: NSNotification) {
        if !isHaveTempLocker {
            return
        }
        if let temp = click.userInfo?["isHidden"] as? Bool {
            cabinetBtn.isHidden = temp
        }
    }

    /// 初始化并添加一个子控制器
    ///
    /// - Parameters:
    ///   - title: 标题
    ///   - image: 图标
    ///   - selectedImage: 选中时的图标
    ///   - type: 控制器
    func addChild(_ title: String,
                  _ image: String,
                  _ selectedImage: String,
                  _ type: UIViewController.Type)
    {
        let vc = LDDNavigationController(rootViewController: type.init())
        vc.title = title
        vc.tabBarItem.image = UIImage(named: image)
        vc.tabBarItem.selectedImage = UIImage(named: selectedImage)
        vc.tabBarItem.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        addChild(vc)
    }

    /// 主动改变选中某个控制器
    @objc private func getChooseToVC(_ not: Notification) {
        guard let index = not.userInfo?[Self.Index] as? Int else { return }

        if index < 0 { return }
        if index >= children.count { return }

        selectedIndex = index
        (tabBar as? LDDTabBar)?.gotoIndex(index)
    }

    override var childForStatusBarHidden: UIViewController? {
        presentedViewController ?? selectedViewController
    }

    override var childForStatusBarStyle: UIViewController? {
        presentedViewController ?? selectedViewController
    }

    override var preferredStatusBarStyle: UIStatusBarStyle { .default }

    override var prefersStatusBarHidden: Bool { false }
}

// MARK: - LDDTabBarController

extension LDDTabBarController: LDDTabBarDelegate {
    /// 单击某个item的代理回调
    ///
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func singleTap(tabBar: LDDTabBar, index: Int) {
        if isHaveTempLocker {
            cabinetBtn.isHidden = index == 1
        }
        selectedIndex = index
    }

    /// 双击某个item的代理回调
    ///
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func doubleTap(tabBar: LDDTabBar, index: Int) {
        // 通知刷新数据，eg: 圈子，我的
        NotificationCenter.default.post(name: NDoubleTapTabBarNotification, object: nil)
    }
}
