//
//  LDDBaseTableCell.swift
//  Created by HouWan
//

import UIKit

/// 所有的Cell都可以继承此Cell
/// 在子Cell里面，只需要直接覆写`createAndConfigUI`方法即可
public class LDDBaseTableCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        createAndConfigUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        createAndConfigUI()
    }

    func createAndConfigUI() {
        selectionStyle = .none
        contentView.isExclusiveTouch = true
    }

}
