//
//  FilterViewController.swift
//  Wormholy-iOS
//
//  Created by Mirzohidbek on 7/10/20.
//  Copyright © 2020 Wormholy. All rights reserved.
//

import UIKit

class FilterViewController: WHBaseViewController {
    @IBOutlet private var tableView:WHTableView!
    @IBOutlet private var segmentView:UISegmentedControl!
    @IBOutlet private var detailLabel:UILabel!
    
    private var filterType:RequestFilterType = Wormholy.filterType
    override func viewDidLoad() {
        super.viewDidLoad()
        Wormholy.whiteListedHosts = ["fiesta.app.com", "test.fiesta.uz", "fiesta.com.uz"]
        Wormholy.blacklistedHosts = ["facebook.com", "instabug.uz", "twitter.com"]
        title = "Filter"
        navigationItem.leftBarButtonItem = .init(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClicked))
        
        navigationItem.rightBarButtonItem = .init(title: "Apply", style: .plain, target: self, action: #selector(doneBtnClicked))
        segmentView.selectedSegmentIndex = filterType.rawValue
        segmentChanged()
    }
    
    @objc private func cancelBtnClicked() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneBtnClicked() {
        
    }
    
    @IBAction private func segmentChanged() {
        filterType = RequestFilterType(rawValue: segmentView.selectedSegmentIndex) ?? .all
        var text = ""
        switch filterType {
        case .all:
            text = "All requests \n\nwill be show."
            break
        case .onlyWhiteList:
            text = "Only Enabled requests \n\nwil be show"
            break
        case .exceptBlacklist:
            text = "Exept Disabled requests \n\nwil be show"
            break
        }
        detailLabel.text = text
        tableView.reloadData()
    }
    
    
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        switch filterType {
        case .all:
            break
        case .onlyWhiteList:
            numberOfRows = Wormholy.whiteListedHosts.count
            break
        case .exceptBlacklist:
            numberOfRows = Wormholy.blacklistedHosts.count
            break
        default:
            break
        }
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
            cell?.selectionStyle = .none
        }
        switch filterType {
        case .all:
            break
        case .onlyWhiteList:
            cell?.textLabel?.text = Wormholy.whiteListedHosts[indexPath.row]
            break
        case .exceptBlacklist:
            cell?.textLabel?.text = Wormholy.blacklistedHosts[indexPath.row]
            break
        default:
            break
        }
        return cell!
    }
}

//
//
//class FilterViewController: WHBaseViewController {
//    private var tableView:WHTableView!
//    private var headerView:FilterHeaderView!
//    private var filterType:RequestFilterType = Wormholy.filterType
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        headerView = FilterHeaderView(seletedIndex: filterType.rawValue, callback: { (index) in
//            self.filterType = RequestFilterType(rawValue: index) ?? .all
//            self.tableView.reloadData()
//        })
//        view.addSubview(headerView)
//        headerView.translatesAutoresizingMaskIntoConstraints = false
//        headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        headerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        headerView.heightAnchor.constraint(equalToConstant: 90).isActive = true
////        headerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 90)
//        tableView = WHTableView(frame: .zero, style: .grouped)
//        tableView.backgroundColor = .red
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(tableView)
//        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor).isActive = true
//        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//        tableView.tableHeaderView = headerView
//        title = "Filter"
//        navigationItem.leftBarButtonItem = .init(title: "Cancel", style: .plain, target: self, action: #selector(cancelBtnClicked))
//
//        navigationItem.rightBarButtonItem = .init(title: "Apply", style: .plain, target: self, action: #selector(doneBtnClicked))
//    }
//
//    @objc private func cancelBtnClicked() {
//        dismiss(animated: true, completion: nil)
//    }
//
//    @objc private func doneBtnClicked() {
//
//    }
//
//
//}
//
//extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 3
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return UITableViewCell()
//    }
//}
//
//typealias SegmentChangesCallback = (_ index:Int) -> Void
//
//class FilterHeaderView:WHView {
//    private var segmentControll:UISegmentedControl!
//    private var detailLabel:WHLabel!
//    private var callback:SegmentChangesCallback
//    init(seletedIndex:Int, callback:@escaping SegmentChangesCallback) {
//        self.callback = callback
//        super.init(frame: .zero)
//        commonInit()
//        segmentControll.selectedSegmentIndex = seletedIndex
//        segmentControll.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    private func commonInit() {
//        segmentControll = UISegmentedControl(items: ["All", "Only Whitelist", "Except Blacklist"])
//        addSubview(segmentControll)
//        segmentControll.translatesAutoresizingMaskIntoConstraints = false
//    }
//
//    @objc private func segmentChanged() {
//        callback(segmentControll.selectedSegmentIndex)
//
//    }
//}
