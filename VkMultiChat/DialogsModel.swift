//
//  DialogsModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk
import SwiftyJSON

class DialogsModel {
    
    var count: Int!
    var unreadDialogs: Int?
    var conversations = [ConversationModelProtocol]()
    
    private var usersIds = Set<Int>()
    private var groupsIds = Set<Int>()
//    private var groupsId = [Int]()
//    private var usersId = [Int]()
    private var profiles = [Int : VKApiObject]()
    
    init(response: [String : Any]?, complition: @escaping (DialogsModel) -> (), faild: @escaping (Error?) -> ()) {
        
        guard let json = response else {
            faild(nil)
            return
        }
        count = json["count"] as! Int
        unreadDialogs = json["unread_dialogs"] as? Int
        
        if let items = json["items"] as? [[String : Any]] {
            items.forEach({ (dict) in
                let id = JSON(dict)["message"]["user_id"].intValue
                _ = id > 0 ? self.usersIds.insert(id) : self.groupsIds.insert(+id)
            })
            
            NetworkManager.sharedInstance.loadUsersAndGroups(usersId: Array(usersIds), groupsId: Array(groupsIds), success: { (profiles) in
                self.profiles = profiles
                self.initializeModelsWith(items)
                complition(self)
            }, failure: { (error) in
                faild(error)
            })
        }
    }
    
    private func initializeModelsWith (_ items: [[String : Any]]) {
        //FIXME: - Also configure coredata models
        
        conversations = items.map({ (dict) -> ConversationModelProtocol in
            if JSON(dict)["message"]["chat_id"].int != nil {
                return ChatModel(response: dict, profiles: profiles)
            }
            return DialogModel(response: dict, profiles: profiles)
        })
        
        
    }
}
