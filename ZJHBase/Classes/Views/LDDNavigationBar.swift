//
//  LDDNavigationBar.swift
//  Created by HouWan
//

import UIKit
import ZJHCommon

/// ## `LDDNavigationBar`的用法:
///
/// ### 1.初始化
/// 两个初始化方法，直接初始化和传入`title`，并且都已经设置过`frame`
/// ```
/// LDDNavigationBar()
/// LDDNavigationBar("标题")
/// ```
///
/// ### 2.Title
/// `titleLabel`和`titleView`已对外暴露，可以直接设置即可，使用`titleView`需要有`size`属性
///
/// ### 3.左右Item
/// 2个添加Item的方法，暂时定为左右只能添加一个(后续看看业务再说)，3种Item类型(Text/Icon/View):
/// ```
/// addLeftItem(_ item: LDDNavigationBarItem)
/// addRightItem(_ item: LDDNavigationBarItem)
/// ```
///
/// ### 4.可以删除，或者隐藏itme
/// ```
/// removeLeftItem()
/// removeRightItem()
/// leftItemsTo(_ hidden: Bool)
/// rightItemsTo(_ hidden: Bool)
/// ```
///
/// ### 5.分隔线(默认隐藏)
/// bar.lineLayer.isHidden = false

class LDDNavigationBar: UIView {

    ///=============================================================================
    /// - Note: Propertys
    ///=============================================================================

    struct NConstants {
        /// 未实现...按钮之间的间距
        static var itemMargin: CGFloat = 12
        /// Item距离左右屏幕两边的间距
        static var leftSpace: CGFloat = 15
        /// Item距离左右屏幕两边的间距
        static var rightSpace: CGFloat = 15
        /// Item增加的宽度，比如当是一个箭头时，非常窄，故意增加一点控件的宽度
        static var addSpace: CGFloat = 2
        /// 导航栏高度其实是固定的44
        static var navigationHeight: CGFloat = 44
    }

    lazy var leftArray: [UIView] = []
    lazy var rightArray: [UIView] = []

    /// TitleLabel.text. Maybe nil.
    var title: String? {
        get { titleLabel?.text }
        set { titleLabel?.text = newValue }
    }

    // =============================================================================
    // MARK: - Views
    // =============================================================================

    /// TitleLabel
    var titleLabel: UILabel?

    /// Custom view to use in lieu of a title. May be sized horizontally. default nil.
    /// - Note: 一定要有`Size`用于Layout
    var titleView: UIView? = nil {
        didSet {
            oldValue?.removeFromSuperview()

            if let tv = titleView {
                addSubview(tv)
                titleLabel?.isHidden = true
            } else {
                titleLabel?.isHidden = false
            }

            layout4Title()
        }
    }

    /// Dividers of the navigation bar, default color: 0xF4F4F4 & hidden
    lazy var lineLayer: CALayer = {
        let line = CALayer()
        line.isHidden = true
        line.backgroundColor = UIColor(0xF4F4F4).cgColor
        return line
    }()

    /// 充当拦截点击事件层
    private lazy var hitBgButton: UIButton = {
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = .clear
        btn.addTarget(self, action: #selector(clickBgEvents), for: .touchUpInside)
        return btn
    }()

    // =============================================================================
    // MARK: - Initialization
    // =============================================================================

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        createUI()
    }

    convenience init(_ title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 100))
        createUI()
        self.title = title
    }

    func createUI() {
        backgroundColor = .white
        clipsToBounds = true

        addSubview(hitBgButton)
        createTitleLabel()
        layer.addSublayer(lineLayer)
    }

    // =============================================================================
    // MARK: - Layout
    // =============================================================================

    override func layoutSubviews() {
        super.layoutSubviews()
        hitBgButton.frame = bounds
        layout4Title()

        let h = CGFloat(Float(1.0 / UIScreen.main.scale).align)
        lineLayer.frame = CGRect(x: 0, y: getKNavigationHeight() - h, width: kScreenWidth, height: h)
    }

    func layout4Title() {
        guard let tv = titleView else {
            let x: CGFloat = 79
            let w = kScreenWidth - x * 2.0
            let h = NConstants.navigationHeight
            let y = self.height - NConstants.navigationHeight
            titleLabel?.frame = CGRect(x: x, y: y, width: w, height: h)
            return
        }

        let tempTop = self.height - NConstants.navigationHeight
        let s = tv.size
        let y = (NConstants.navigationHeight - s.height) * 0.5 + tempTop
        let x = (kScreenWidth - s.width) * 0.5
        tv.frame = CGRect(x: x, y: y, width: s.width, height: s.height)
    }

    ///=============================================================================
    /// - Note: Others
    ///=============================================================================

    /// 空方法，为了拦截点击事件，不让事件穿透
    @objc func clickBgEvents() {}

    /// 创建并添加`TitleLabel`，当然如果已经创建了，不会重复创建
    private func createTitleLabel() {
        if let label = titleLabel {
            label.isHidden = false
            return
        }
        titleLabel = UILabel()
        titleLabel!.textAlignment = .center
        titleLabel!.textColor = UIColor(0x0C0C0C)
        titleLabel!.font = MediumFont(17)
        addSubview(titleLabel!)
    }
}

/// Manager `LDDNavigationBarItem`
extension LDDNavigationBar {

    /// 左边👈添加一个`LDDNavigationBarItem`
    func addLeftItem(_ item: LDDNavigationBarItem) {
        removeLeftItem()
        _addItem(item, isLeft: true)
    }

    /// 右边👉添加一个`LDDNavigationBarItem`
    func addRightItem(_ item: LDDNavigationBarItem) {
        removeRightItem()
        _addItem(item, isLeft: false)
    }

    /// 删除左边👈的`LDDNavigationBarItem`
    func removeLeftItem() {
        leftArray.forEach { $0.removeFromSuperview() }
        leftArray.removeAll()
    }

    /// 删除右边👉的`LDDNavigationBarItem`
    func removeRightItem() {
        rightArray.forEach { $0.removeFromSuperview() }
        rightArray.removeAll()
    }

    /// Whether to hide the items on the left? (Usually to hide clicks while loading)
    /// - Parameter hidden: YES:hidden  NO:display
    func leftItemsTo(_ hidden: Bool) {
        leftArray.forEach { $0.isHidden = hidden }
    }

    /// Whether to hide the items on the right? (Usually to hide clicks while loading)
    /// - Parameter hidden: YES:hidden  NO:display
    func rightItemsTo(_ hidden: Bool) {
        rightArray.forEach { $0.isHidden = hidden }
    }

    /// 添加一个`LDDNavigationBarItem`
    /// - Parameter isLeft: 是否是左边的Item  true左边  false右边
    private func _addItem(_ item: LDDNavigationBarItem, isLeft: Bool) {

        // 1.自定义View类型
        if let customItem = item as? LDDNavigationCustomItem {
            _addCustomItem(customItem, isLeft: isLeft)
            return
        }

        let btn = UIButton(type: .custom)

        // 2.icon类型
        if let iconItem = item as? LDDNavigationIconItem, let icon = iconItem.iconImage {
            let w = icon.size.width + NConstants.addSpace
            let h = NConstants.navigationHeight
            btn.frame = frameWith(w, h: h, isLeft: isLeft)
            btn.setImage(icon, for: .normal)
            btn.imageView?.contentMode = .center
//            btn.oc_hitEdgeInsets = iconItem.hitEdgeInsets
            if let target = iconItem.target, let action = iconItem.action {
                btn.addTarget(target, action: action, for: .touchUpInside)
            }
        }

        // 3.文本类型
        if let textItem = item as? LDDNavigationTextItem {
            let w = textItem.title.ldd_widthForFont(textItem.titleFont) + NConstants.addSpace
            let h = NConstants.navigationHeight
            btn.frame = frameWith(w, h: h, isLeft: isLeft)
            btn.titleLabel?.font = textItem.titleFont
            btn.titleNormal(textItem.title, textItem.titleColor)
//            btn.oc_hitEdgeInsets = textItem.hitEdgeInsets
            if let target = textItem.target, let action = textItem.action {
                btn.ldd_addTarget(target, action: action)
            }
        }

        addSubview(btn)
        if isLeft {
            leftArray.append(btn)
        } else {
            rightArray.append(btn)
        }
    }

    /// 添加一个`LDDNavigationBarItem`，仅限`LDDNavigationCustomItem`类型
    private func _addCustomItem(_ item: LDDNavigationCustomItem, isLeft: Bool) {
        let w = item.itemView.width < 0 ? 20 : item.itemView.width
        let h = item.itemView.height < 0 ? 20 : item.itemView.height
        let x = isLeft ? NConstants.leftSpace : (kScreenWidth - w - NConstants.rightSpace)

        let tempTop = self.height - NConstants.navigationHeight
        let y = (NConstants.navigationHeight - h) * 0.5 + tempTop

        item.itemView.frame = CGRect(x: x, y: y, width: w, height: h)
        addSubview(item.itemView)

        if isLeft {
            leftArray.append(item.itemView)
        } else {
            rightArray.append(item.itemView)
        }
    }

    /// 根据左右Item，返回这个Item的frame
    private func frameWith(_ w: CGFloat, h: CGFloat, isLeft: Bool) -> CGRect {
        let x = isLeft ? NConstants.leftSpace : (kScreenWidth - w - NConstants.rightSpace)

        let tempTop = self.height - NConstants.navigationHeight
        let y = (NConstants.navigationHeight - h) * 0.5 + tempTop
        return CGRect(x: x, y: y, width: w, height: h)
    }

    func getKNavigationHeight() -> CGFloat {
        var height: CGFloat = 0
        var statusHeight: CGFloat = 0
        if #available(iOS 13.0, *) {
            statusHeight = CGFloat(self.window!.windowScene?.statusBarManager?.statusBarFrame.height ?? 0)
        } else {
            statusHeight = CGFloat(UIApplication.shared.statusBarFrame.height)
        }
        height = statusHeight + 44.0
        return height
    }
}
