//
//  RequestModelBeautifier.swift
//  Wormholy-iOS
//
//  Created by Paolo Musolino on 18/04/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import UIKit

class RequestModelBeautifier: NSObject {
    
    static func overview(request: RequestModel) -> NSMutableAttributedString{
        let url = NSMutableAttributedString().bold("URL ").normal(request.url + "\n")
        let method = NSMutableAttributedString().bold("Method ").normal(request.method + "\n")
        let responseCode = NSMutableAttributedString().bold("Response Code ").normal((request.code != 0 ? "\(request.code)" : "-") + "\n")
//        let requestStartTime = NSMutableAttributedString().bold("Request Start Time ").normal((request.date.stringWithFormat(dateFormat: "MMM d yyyy - HH:mm:ss") ?? "-") + "\n")
//        let duration = NSMutableAttributedString().bold("Duration ").normal(request.duration?.formattedMilliseconds() ?? "-")
        let final = NSMutableAttributedString()
        for attr in [url, method, responseCode]{
            final.append(attr)
        }
        return final
    }
    
    static func time(request: RequestModel) -> NSMutableAttributedString{
        let requestStartTime = NSMutableAttributedString().bold("Request Start Time ").normal((request.date.stringWithFormat(dateFormat: "MMM d yyyy - HH:mm:ss") ?? "-") + "\n")
        let responseTime = NSMutableAttributedString().bold("Response Time ").normal((request.responseDate?.stringWithFormat(dateFormat: "MMM d yyyy - HH:mm:ss") ?? "-") + "\n")
        let duration = NSMutableAttributedString().bold("Duration ").normal(request.duration?.formattedMilliseconds() ?? "-")
        let final = NSMutableAttributedString()
        for attr in [requestStartTime, responseTime, duration]{
            final.append(attr)
        }
        return final
    }
    
    
    static func size(request: RequestModel) -> NSMutableAttributedString{
        let byteFormatter:ByteCountFormatter = ByteCountFormatter()
        byteFormatter.allowedUnits = [.useAll]
        let reqSize = Int64(request.httpBody?.count ?? 10000000)
        let requestSize = NSMutableAttributedString().bold("Request size ").normal((byteFormatter.string(fromByteCount: reqSize)) + "\n")
        let resSize = Int64(request.dataResponse?.count ?? 10000)
        let responseSize = NSMutableAttributedString().bold("Response Time ").normal((byteFormatter.string(fromByteCount: resSize)) + "\n")
        let totalSize = NSMutableAttributedString().bold("Total size ").normal((byteFormatter.string(fromByteCount: resSize + reqSize)) + "\n")
      
        let final = NSMutableAttributedString()
        for attr in [requestSize, responseSize, totalSize]{
            final.append(attr)
        }
        return final
    }
    
    static func header(_ headers: [String: String]?) -> NSMutableAttributedString{
        guard let headerDictionary = headers else {
            return NSMutableAttributedString(string: "-")
        }
        let final = NSMutableAttributedString()
        for (key, value) in headerDictionary {
            final.append(NSMutableAttributedString().bold(key).normal(" " + value + "\n"))
        }
        return final
    }
    
    static func body(_ body: Data?, splitLength: Int? = nil, completion: @escaping (String) -> Void){
        DispatchQueue.global().async {
            completion(RequestModelBeautifier.body(body, splitLength: splitLength))
            return
        }
    }
    
    static func body(_ body: Data?, splitLength: Int? = nil) -> String{
        guard body != nil else {
            return "-"
        }
        
        if let data = splitLength != nil ? String(data: body!, encoding: .utf8)?.characters(n: splitLength!) : String(data: body!, encoding: .utf8){
            return data.prettyPrintedJSON ?? data
        }
        
        return "-"
    }
    
    static func txtExport(request: RequestModel) -> String{
        
        var txt: String = ""
        txt.append("*** Overview *** \n")
        txt.append(overview(request: request).string + "\n\n")
        txt.append("*** Request Header *** \n")
        txt.append(header(request.headers).string + "\n\n")
        txt.append("*** Request Body *** \n")
        txt.append(body(request.httpBody) + "\n\n")
        txt.append("*** Response Header *** \n")
        txt.append(header(request.responseHeaders).string + "\n\n")
        txt.append("*** Response Body *** \n")
        txt.append(body(request.dataResponse) + "\n\n")
        txt.append("------------------------------------------------------------------------\n")
        txt.append("------------------------------------------------------------------------\n")
        txt.append("------------------------------------------------------------------------\n\n\n\n")
        return txt
    }
    
    static func curlExport(request: RequestModel) -> String{
        
        var txt: String = ""
        txt.append("*** Overview *** \n")
        txt.append(overview(request: request).string + "\n\n")
        txt.append("*** curl Request *** \n")
        txt.append(request.curlRequest + "\n\n")
        txt.append("*** Response Header *** \n")
        txt.append(header(request.responseHeaders).string + "\n\n")
        txt.append("*** Response Body *** \n")
        txt.append(body(request.dataResponse) + "\n\n")
        txt.append("------------------------------------------------------------------------\n")
        txt.append("------------------------------------------------------------------------\n")
        txt.append("------------------------------------------------------------------------\n\n\n\n")
        return txt
    }
}

extension NSMutableAttributedString {
    @discardableResult func bold(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string:text, attributes: attrs)
        append(boldString)
        return self
    }
    
    @discardableResult func normal(_ text: String) -> NSMutableAttributedString {
        let attrs: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 14)]
        let normal = NSMutableAttributedString(string:text, attributes: attrs)
        append(normal)
        return self
    }
    
    func chageTextColor(to color: UIColor) -> NSMutableAttributedString {
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color , range: NSRange(location: 0,length: string.count))
        return self
    }
}

extension Dictionary {
    var prettyPrintedJSON: String? {
        do {
            let data: Data = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return String(data: data, encoding: .utf8)
        } catch _ {
            return nil
        }
    }
}

extension String {
    var prettyPrintedJSON: String? {
        guard let stringData = self.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: stringData, options: []),
            let jsonData = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
            let formattedJSON = String(data: jsonData, encoding: .utf8) else { return nil }

        return formattedJSON.replacingOccurrences(of: "\\/", with: "/")
    }
    
    func javaScriptEscapedString() -> String {
        
            // Because JSON is not a subset of JavaScript, the LINE_SEPARATOR and PARAGRAPH_SEPARATOR unicode
        // characters embedded in (valid) JSON will cause the webview's JavaScript parser to error. So we
        // must encode them first. See here: http://timelessrepo.com/json-isnt-a-javascript-subset
        // Also here: http://media.giphy.com/media/wloGlwOXKijy8/giphy.gif
        
        var str = self.replacingOccurrences(of: "\n", with: "<br>")
         str = str.replacingOccurrences(of: "\u{2028}", with: "\\u2028")
        str = str.replacingOccurrences(of: "\u{2029}", with: "\\u2029")
                
        //        oldText.replace(/(<br\s*\/?>){3,}/gi, '<br>');
        
        //            self.stringByReplacingOccurrencesOfString("\u{2028}", withString: "\\u2028")
        //.stringByReplacingOccurrencesOfString("\u{2029}", withString: "\\u2029")
        // Because escaping JavaScript is a non-trivial task (https://github.com/johnezang/JSONKit/blob/master/JSONKit.m#L1423)
        // we proceed to hax instead:
        let data = try! JSONSerialization.data(withJSONObject: [str], options: [])
        let encodedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue)!
        return encodedString.substring(with: NSMakeRange(1, encodedString.length - 2))
    }
}
