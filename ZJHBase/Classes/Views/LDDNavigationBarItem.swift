//
//  LDDNavigationBarItem.swift
//  Created by HouWan
//

import UIKit
import ZJHCommon

/// 基类，用于类型约束的。
public class LDDNavigationBarItem: NSObject {}

// =============================================================================
// MARK: - TextItem
// =============================================================================

/// 文本形式的`Item`
public class LDDNavigationTextItem: LDDNavigationBarItem {
    /// Item text color, default black color (0x2D2D2D)
    lazy var titleColor = UIColor(0x2D2D2D)
    /// Font of item text, default : [UIFont systemFontOfSize:16 weight:(UIFontWeightMedium)];
    lazy var titleFont = SystemFont(16)
    /// Item text, Its value comes from the initialization method.
    var title: String

    var target: Any?
    var action: Selector?

    /// 扩大/减小点击区域，鉴于函数`UIEdgeInsetsInsetRect(,)`的实现方式，所以如果是扩大点击区域的话，Edge的
    /// 4个值应该都是负数，负数才是向外扩大.正数是向内减少点击区域. default:`UIEdgeInsetsZero`
    /// eg: UIEdgeInsetsMake(top, left, bottom, right);
    /// eg: 四周扩大10pt:  button.hw_hitEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    /// @see https://www.jianshu.com/p/7b89ea74999f
    /// @see UIEdgeInsetsInsetRect: https://www.jianshu.top: comleft: /p/22bottom: 21dright: e5efc50
    lazy var hitEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -12, bottom: 0, right: -12)

    /// Initialization, using Target-Action callback.
    ///
    /// - Parameters:
    ///   - title: The title of the display.
    ///   - target: Callback target.
    ///   - action: the action cannot be NULL. Note that the target is not retained.
    init(title: String, target: Any? = nil, action: Selector? = nil) {
        self.title = title
        self.target = target
        self.action = action
        super.init()
    }

    private override init() {
        fatalError("init() has not been implemented")
    }

    deinit {
        target = nil
    }
}

// =============================================================================
// MARK: - IconItem
// =============================================================================

/// 图标形式的`Item`
public class LDDNavigationIconItem: LDDNavigationBarItem {
    /// Item icon,  Its value comes from the initialization method.
    private var iconName: String?
    /// Item icon,  Its value comes from the initialization method.
    private var icon: UIImage?

    /// 对外统一调用此属性即可
    var iconImage: UIImage? {
        if let iconImg = icon { return iconImg }
        return UIImage(named: iconName!)
    }

    /// 扩大/减小点击区域，鉴于函数`UIEdgeInsetsInsetRect(,)`的实现方式，所以如果是扩大点击区域的话，Edge的
    /// 4个值应该都是负数，负数才是向外扩大.正数是向内减少点击区域. default:`UIEdgeInsetsZero`
    /// eg: UIEdgeInsetsMake(top, left, bottom, right);
    /// eg: 四周扩大10pt:  button.hw_hitEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
    /// @see https://www.jianshu.com/p/7b89ea74999f
    /// @see UIEdgeInsetsInsetRect: https://www.jianshu.com/p/2221de5efc50
    lazy var hitEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: -15, bottom: 0, right: -15)

    var target: Any?
    var action: Selector?

    /// Initialization, using Target-Action callback.
    ///
    /// - Parameters:
    ///   - iconName: The item icon of the display.
    ///   - target: Callback target.
    ///   - action: the action cannot be NULL. Note that the target is not retained.
    init(iconName: String, target: Any? = nil, action: Selector? = nil) {
        self.iconName = iconName
        self.target = target
        self.action = action
        super.init()
    }

    /// Initialization
    init(icon: UIImage?, target: Any? = nil, action: Selector? = nil) {
        self.icon = icon
        self.target = target
        self.action = action
        super.init()
    }

    private override init() {}

    deinit {
        target = nil
    }
}

// =============================================================================
// MARK: - CustomItem
// =============================================================================

/// 自定义`Item`，注意，必须给View的`Size`，不然不知道如何Layout
public class LDDNavigationCustomItem: LDDNavigationBarItem {
    /// Custom view, 必须给`Size`，不然不知道如何Layout
    var itemView: UIView

    /// Initialization, using Target-Action callback.
    ///
    /// - Parameter itemView: The Custom view.
    ///
    /// - note: `itemView` must have a frame
    ///
    init(itemView: UIView) {
        self.itemView = itemView
        super.init()
    }
}
