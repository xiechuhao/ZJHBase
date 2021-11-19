//
//  LDDBaseView.swift
//  Created by HouWan
//

import UIKit

/// 所有的View都可以继承此view
/// 在子view里面，只需要直接覆写`createAndConfigUI`方法即可
class LDDBaseView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        createAndConfigUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createAndConfigUI()
    }

    func createAndConfigUI() {
        isExclusiveTouch = true
    }
}
