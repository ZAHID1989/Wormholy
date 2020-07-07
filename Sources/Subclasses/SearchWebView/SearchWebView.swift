//
//  SearchWebView.swift
//  Wormholy-iOS
//
//  Created by Mirzohidbek on 7/1/20.
//  Copyright © 2020 Wormholy. All rights reserved.
//

import UIKit
import WebKit

class SearchWebView: WKWebView {

    private (set) var  currenHighlightIndex:Int = 0
    private (set) var  totalHighlightCount:Int = 0
    
    func highlightAllOccurencesOf(key:String)->Int {
        
        return 0
    }
    
    func removeAllHighlights() {
        
    }
    
    func scrollToIndex(index:Int) {
        if index < 0 || index > totalHighlightCount {
            return
        }
        currenHighlightIndex = index
    }
    
    func scrollToNext() {
        scrollToIndex(index: currenHighlightIndex + 1)
    }
    
    func scrollToPrev() {
        scrollToIndex(index: currenHighlightIndex - 1)
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
