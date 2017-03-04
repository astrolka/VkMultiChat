//
//  MessagesModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 21.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk
import SwiftyJSON

class MessagesModel {
    var count: Int!
    var models = [MessageModel]()
    
    private var profiles: [Int : VKApiObject]!
    private var usersIds = Set<Int>()
    private var groupsIds = Set<Int>()
    
    init(response: [String : Any]?, succeed: @escaping (MessagesModel) -> (), faild: @escaping (Error?) -> ()) {
        guard let json = response, let items = json["items"] as? [[String : Any]] else {
            faild(nil)
            return
        }
        
        items.forEach { (message) in
            self.addIdsFromMessage(dict: message)
        }
        
        NetworkManager.sharedInstance.loadUsersAndGroups(usersId: Array(usersIds), groupsId: Array(groupsIds), success: { (profiles) in
            self.profiles = profiles
            for message in items {
                self.models.append(MessageModel.init(response: message, profiles: self.profiles))
            }
            succeed(self)
        }) { (error) in
            faild(error)
        }
        
        
    }
    
    func addIdsFromMessage(dict: [String : Any]) {
        let id = dict["user_id"] as! Int
        _ = id > 0 ? usersIds.insert(id) : groupsIds.insert(+id)
        if let fwdMsgs = dict["fwd_messages"] as? [[String : Any]] {
            fwdMsgs.forEach({ (msg) in
                self.addIdsFromMessage(dict: msg)
            })
        }
    }
    
}
