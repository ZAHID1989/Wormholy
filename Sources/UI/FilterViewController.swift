//
//  FilterViewController.swift
//  Wormholy-iOS
//
//  Created by Mirzohidbek on 7/10/20.
//  Copyright © 2020 Wormholy. All rights reserved.
//

import UIKit

class FilterViewController: WHBaseViewController {
    private var tableView:WHTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView = WHTableView(frame: .zero, style: .grouped)
        view.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
