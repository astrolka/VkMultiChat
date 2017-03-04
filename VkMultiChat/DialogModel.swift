//
//  DialogModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import SwiftyJSON
import VK_ios_sdk

class DialogModel {
    
    var unread: Int?
    var message: MessageModel!
    var in_read: Int!
    var out_read: Int!
    var profile: VKApiObject!
    var chatId: Int!
    
    required init(response: [String : Any]?, profiles: [Int : VKApiObject]) {
        
        guard let json = response else {
            return
        }
        
        unread = json["unread"] as? Int
        in_read = json["in_read"] as! Int
        out_read = json["out_read"] as! Int
        
        let userId = JSON(json)["message"]["user_id"].intValue
        profile = profiles[userId]
        
        message = MessageModel(response: json["message"] as? [String : Any], profiles: profiles)
        
    }
}

extension DialogModel: ConversationModelProtocol {
}
