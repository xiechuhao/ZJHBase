//
//  LDDTabBar.swift
//  Created by HouWan
//

import UIKit
import ZJHCommon

// =============================================================================
// MARK: - 点击`DTabBar`事件代理回调
// =============================================================================
@objc protocol LDDTabBarDelegate: NSObjectProtocol {

    /// 单击某个item的代理回调
    ///
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc func singleTap(tabBar: LDDTabBar, index: Int)

    /// 双击某个item的代理回调
    ///
    /// - Parameters:
    ///   - tabBar: DTabBar对象
    ///   - index: 点击Item的索引
    @objc optional func doubleTap(tabBar: LDDTabBar, index: Int)
}

// =============================================================================
// MARK: - 自定义`UITabBar`
// =============================================================================
class LDDTabBar: UITabBar {

    /// 当前选中的Item
    private var currentItem: LDDTabBar_Item?
    /// 代理
    weak var tabBarDelegate: LDDTabBarDelegate?
    /// 是否加载过UI，发现在某些时候，系统会多次调用`setItem`
    private var isReload: Bool = false
    /// 所有的`LDDTabBar_Item`
    private var itemArray: [LDDTabBar_Item] = []

    ///=============================================================================
    /// - Note: Initialization
    ///=============================================================================

    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configUI()
    }

    private func configUI() {
        isTranslucent = false
        backgroundColor = .white

        // 异步去掉黑线
        let s = UIScreen.main.scale
        DispatchQueue.global().async { [self] in
            let si = UIImage.ldd_imageWith(UIColor(0xEEEEEE), size: CGSize(kScreenWidth, 1), scale: s)
            let bi = UIImage.ldd_imageWith(.white, size: CGSize(kScreenWidth, self.getkTabBarHeight()), scale: s)
            DispatchQueue.main.async {
                if #available(iOS 13.0, *) {
                    self.standardAppearance.shadowImage = si
                    self.standardAppearance.backgroundImage = bi
                } else {
                    self.shadowImage = si
                    self.backgroundImage = bi
                }
            }
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
//        pprint("开始删除线")
//        xxLine(self)
    }

    private func xxLine(_ v: UIView) {
        for cell in v.subviews {
            if cell.subviews.count >= 1 {
                xxLine(cell)
            } else {
                if cell.height < 2 && (cell is UIImageView) {
                    cell.isHidden = true
                }
            }
        }
    }

    func getkTabBarHeight() -> CGFloat {
        var height: CGFloat = 0
        var safeAreaInsets: UIEdgeInsets = .zero
        if #available(iOS 11.0, *) {
            safeAreaInsets = window!.safeAreaInsets
        }
        height = safeAreaInsets.bottom + 49.0
        return height
    }
}

// MARK: - TouchAction
extension LDDTabBar {
    /// 点击
    @objc func singleTap(tap: UITapGestureRecognizer) {
        let item = tap.view as! LDDTabBar_Item
        guard item != currentItem else { return }

        currentItem?.selected = false
        item.selected = true
        currentItem = item

        animation(item: item)

        guard let d = tabBarDelegate else { return }

        if d.responds(to: #selector(d.singleTap(tabBar:index:))) {
            d.singleTap(tabBar: self, index: item.index)
        }
    }

    /// 双击
    @objc func doubleTap(tap: UITapGestureRecognizer) {
        let item = tap.view as! LDDTabBar_Item

        // 如果没有正在显示，按单击处理
        guard currentItem == item else {
            singleTap(tap: tap)
            return
        }

        guard let d = tabBarDelegate else { return }

        if d.responds(to: #selector(d.doubleTap(tabBar:index:))) {
            d.doubleTap?(tabBar: self, index: item.index)
        }
    }

    /// 主动选中到某个索引位置，没有代理回调
    func gotoIndex(_ index: Int) {
        if index < 0 { return }
        if index >= itemArray.count { return }

        self.currentItem?.selected = false
        itemArray[index].selected = true
        self.currentItem = itemArray[index]
    }

    /// 动画一下
    private func animation(item: LDDTabBar_Item) {
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulse.duration = 0.2
        pulse.autoreverses = true
        pulse.fromValue = 0.9
        pulse.toValue = 1.1
        item.iconView.layer.add(pulse, forKey: nil)
    }
}

// MARK: - Override
extension LDDTabBar {
    // -------------------彻底移除系统items-------------------
    // swiftlint:disable unused_setter_value
    override var items: [UITabBarItem]? {
        get { return [] }
        set {}
    }
    // swiftlint:enable unused_setter_value

    override func setItems(_ items: [UITabBarItem]?, animated: Bool) {
        guard let list = items else { return }

        if isReload { return }
        isReload = true

        let w: CGFloat = ceilf(Float(kScreenWidth / list.count.cgFloat)).cgFloat

        for (index, data) in list.enumerated() {
            let item = LDDTabBar_Item(model: data)
            item.frame = CGRect(x: CGFloat(index) * w, y: 0.0, width: w, height: getkTabBarHeight())
            addSubview(item)
            itemArray.append(item)

            item.index = index
            item.selected = index == 0

            if index == 0 { currentItem = item }

            let singleTap = UITapGestureRecognizer(target: self, action: #selector(singleTap(tap:)))
            singleTap.numberOfTouchesRequired = 1
            singleTap.numberOfTapsRequired = 1
            item.addGestureRecognizer(singleTap)

            let doubleTap = UITapGestureRecognizer(target: self, action: #selector(doubleTap(tap:)))
            doubleTap.numberOfTouchesRequired = 1
            doubleTap.numberOfTapsRequired = 2
            item.addGestureRecognizer(doubleTap)
        }
    }
    // ----------------------------------------------------
}

// =============================================================================
// MARK: - 自定义`UITabBar`的按钮
// =============================================================================
private class LDDTabBar_Item: UIView {

    var model: UITabBarItem
    var index: Int = -1

    /// change UI style
    var selected: Bool = false {
        didSet {
            if selected {
                iconView.image = model.selectedImage
                titleView.textColor = UIColor(0x2D2D2D)
            } else {
                iconView.image = model.image
                titleView.textColor = UIColor(0xB0B0B0)
            }
        }
    }

    lazy var iconView: UIImageView = {
        let iconView = UIImageView()
        iconView.contentMode =  .bottom
        return iconView
    }()

    lazy var titleView: UILabel = {
        UILabel(font: MediumFont(11), color: .green, align: .center)
    }()

    ///=============================================================================
    /// - Note: Initialization
    ///=============================================================================

    init(model: UITabBarItem) {
        self.model = model
        super.init(frame: .zero)
        createUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func createUI() {
        backgroundColor = .white
        isExclusiveTouch = true
        addSubview(iconView)
        addSubview(titleView)

        titleView.text = model.title
        iconView.image = model.image
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 0, y: 0, width: width, height: 28)
        let y = iconView.maxY + 3
        titleView.frame = CGRect(x: 0, y: y, width: width, height: 12)
    }
}

// =============================================================================
// MARK: - LDDTabBarItemModel模型
// =============================================================================

/// 一个·TabBarItem·展示所需的全部数据
private struct LDDTabBarItemModel {
    var title: String
    var image: String
    var selectedImage: String

    /// Initialization
    ///
    /// - Parameters:
    ///   - t: title
    ///   - i: image name
    ///   - s: selectedImage name
    init(t: String, i: String, s: String) {
        title = t
        image = i
        selectedImage = s
    }
}
