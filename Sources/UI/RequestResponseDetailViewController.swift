//
//  RequestResponseDetailViewController.swift
//  Wormholy-iOS
//
//  Created by Mirzohidbek on 7/1/20.
//  Copyright © 2020 Wormholy. All rights reserved.
//

import UIKit
import WebKit

class RequestResponseDetailViewController: WHBaseViewController {
    
    private var webView:SearchWebView!
    var requestModel:RequestModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let jScript =
        """
                           var meta = document.createElement('meta');
                           meta.setAttribute('name', 'viewport');
                           meta.setAttribute('content', 'width=device-width');
                           meta.setAttribute('initial-scale', '1.0');
                           meta.setAttribute('maximum-scale', '1.0');
                           meta.setAttribute('minimum-scale', '1.0');
                           meta.setAttribute('user-scalable', 'no');
                           document.getElementsByTagName('head')[0].appendChild(meta);
                       """
        let wkUScript = WKUserScript(source: jScript, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let wkUController = WKUserContentController()
        wkUController.addUserScript(wkUScript)
        
        let wkWebConfig = WKWebViewConfiguration()
        wkWebConfig.userContentController = wkUController
        
        webView = SearchWebView(frame: .zero, configuration: wkWebConfig)
        view.addSubview(webView)
        webView.allowsLinkPreview = true
        let uiweb = UIWebView()
        uiweb.dataDetectorTypes = .link
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        webView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        webView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        webView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        webView.navigationDelegate = self
        if let htmlFilePath = WHBundle.getBundle().path(forResource: "BodyInfo", ofType: "html") {
            do {
                let htmlString:String = try String(contentsOfFile: htmlFilePath)
                webView.loadHTMLString(htmlString, baseURL: Bundle.main.bundleURL)
            } catch  {
                print("error load file")
            }
        }
        // Do any additional setup after loading the view.
    }
}

extension RequestResponseDetailViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let requestModel = requestModel {
            
            let header = RequestModelBeautifier.header(requestModel.headers).string
            var body = "-"
            if let data = requestModel.dataResponse, let jsonStr = try? String(data: data , encoding: .utf8) {
                body = jsonStr//jsonStr.prettyPrintedJSON ?? jsonStr
            }
            let func2 = "changeContent(\(header.javaScriptEscapedString()), \(body))"
//            let func2 = "resizeText(\(0.5)"
            webView.evaluateJavaScript(func2) { (result, error) in
                print("result ", result ?? error)
            }
        }
    }
}


