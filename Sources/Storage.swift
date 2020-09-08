//
//  Storage.swift
//  Wormholy-SDK-iOS
//
//  Created by Paolo Musolino on 04/02/18.
//  Copyright © 2018 Wormholy. All rights reserved.
//

import Foundation

open class Storage: NSObject {

    public static let shared: Storage = Storage()
    
    override init() {
        super.init()
        
    }
    
    open var requests: [RequestModel] = []
    
    func saveRequest(request: RequestModel?){
        guard request != nil else {
            return
        }
        
        if let index = requests.firstIndex(where: { (req) -> Bool in
            return request?.id == req.id ? true : false
        }){
            requests[index] = request!
        }else{
            requests.insert(request!, at: 0)
        }
        NotificationCenter.default.post(name: newRequestNotification, object: nil)
    }

    func clearRequests() {
        requests.removeAll()
    }
}
private let kKey = "savedRequests";
class RequestModelList: Codable {
    let requests: [RequestModel]?
    
    
    func save() {
        do {
            let encoded = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encoded, forKey: kKey)
            UserDefaults.standard.synchronize()
//            UserDefaults.setObject(object: encoded, forKey: kKey)
        } catch {
            print("Error save User info: \(error)")
        }
    }
    
    class func load()->[RequestModel]? {
        if let data = UserDefaults.standard.value(forKey: kKey) as? Data {
            do {
                let requests = try JSONDecoder().decode([RequestModel].self, from: data)
                return requests
            } catch {
                print("Error loading User info: \(error)")
                return nil
            }
        }
        return nil
    }
}
