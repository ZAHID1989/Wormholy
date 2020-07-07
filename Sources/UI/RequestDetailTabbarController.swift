//
//  RequestDetailTabbarController.swift
//  Wormholy
//
//  Created by Mirzohidbek on 6/29/20.
//  Copyright © 2020 Wormholy. All rights reserved.
//

import UIKit

class RequestDetailTabbarController: UITabBarController {

    private var request:RequestModel
    init(request:RequestModel) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    private func commonInit() {
        let storyboard = UIStoryboard(name: "Flow", bundle: WHBundle.getBundle())
        guard let overviewCtrl = storyboard.instantiateViewController(withIdentifier: "RequestOverviewViewController") as? RequestOverviewViewController else {
            return
        }
        overviewCtrl.request = request
        
//        let storyboard = UIStoryboard(name: "Flow", bundle: WHBundle.getBundle())
//        if let requestDetailVC = storyboard.instantiateViewController(withIdentifier: "BodyDetailViewController") as? BodyDetailViewController{
//            requestDetailVC.title = title
//            requestDetailVC.data = body
//            self.show(requestDetailVC, sender: self)
//        }
        guard let requestCtrl = storyboard.instantiateViewController(withIdentifier: "BodyDetailViewController") as? BodyDetailViewController else {
            return
        }
        requestCtrl.data = request.httpBody
        requestCtrl.header = RequestModelBeautifier.header(request.headers).chageTextColor(to: labelTextColor)
//        responseCtrl.request = request
//        requestCtrl.title = "Request"
        
        guard let responseCtrl = storyboard.instantiateViewController(withIdentifier: "BodyDetailViewController") as? BodyDetailViewController else {
            return
        }
        responseCtrl.data = request.dataResponse
        responseCtrl.header = RequestModelBeautifier.header(request.responseHeaders).chageTextColor(to: labelTextColor)
//        responseCtrl.isRequest = false
//                responseCtrl.title = "Response"
        
//        let responseCtrl = RequestResponseDetailViewController()
//        responseCtrl.requestModel = request
        
//        responseCtrl.request = request
        setViewControllers([UINavigationController(rootViewController: overviewCtrl), UINavigationController(rootViewController: requestCtrl), UINavigationController(rootViewController: responseCtrl)], animated: false)
        let names = ["Overview", "Request", "Response"]
        for (ind, value) in (tabBar.items?.enumerated())! {
            let tabBarItem:UITabBarItem = value as UITabBarItem
            tabBarItem.title = names[ind]
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .normal)
            tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], for: .selected)
            tabBarItem.titlePositionAdjustment = .init(horizontal: 0, vertical: -13)
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
