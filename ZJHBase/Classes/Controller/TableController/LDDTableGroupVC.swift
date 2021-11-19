//
//  LDDTableGroupVC.swift
//  Created by HouWan
//

import UIKit

let kScreenWidth = UIScreen.main.bounds.size.w
class LDDTableGroupVC: LDDBaseVC, UITableViewDelegate, UITableViewDataSource {

    /// UITableView
    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initTableView()
    }

    private func initTableView() {
        // Table views can have one of two styles, UITableViewStylePlain and UITableViewStyleGrouped.
        // When you create a UITableView instance you must specify a table style, and this style cannot be changed.
        // ⚠️You need to implement the frame for tableView
        tableView = UITableView(frame: .zero, style: .grouped)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: LDD_CELL_IDF)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: LDD_HF_IDF)
        view.addSubview(tableView)

        if #available(iOS 11.0, *) {
            tableView.estimatedRowHeight = 0
            tableView.estimatedSectionHeaderHeight = 0
            tableView.estimatedSectionFooterHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }

        // 去掉 UITableViewStyleGrouped 模式下多余的空白
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.1))
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 0.1))
        tableView.contentInset = .zero
    }

    // MARK: - UITableViewDelegate

    dynamic func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    dynamic func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: LDD_CELL_IDF, for: indexPath)
    }
}
