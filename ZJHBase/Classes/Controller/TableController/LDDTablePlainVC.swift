//
//  LDDTablePlainVC.swift
//  Created by HouWan
//

import UIKit

let LDD_CELL_IDF = "cellIdentifier"
let LDD_HF_IDF = "tableHederIdentifer"
class LDDTablePlainVC: LDDBaseVC, UITableViewDelegate, UITableViewDataSource {

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
        tableView = UITableView(frame: .zero, style: .plain)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: LDD_CELL_IDF)
        tableView.register(UITableViewHeaderFooterView.self, forHeaderFooterViewReuseIdentifier: LDD_HF_IDF)
        view.addSubview(tableView)

        if #available(iOS 11.0, *) {
            tableView.estimatedRowHeight = 0
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
    }

    // MARK: - UITableViewDelegate

    dynamic func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }

    dynamic func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        tableView.dequeueReusableCell(withIdentifier: LDD_CELL_IDF, for: indexPath)
    }
}
