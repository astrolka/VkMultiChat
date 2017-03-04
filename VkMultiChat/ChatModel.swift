//
//  ChatModle.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 20.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import SwiftyJSON
import VK_ios_sdk

class ChatModel: DialogModel {
    
    var usersCount: Int!
    var photo_100: String?
    var adminId: Int?
    var title: String!
    
    required init(response: [String : Any]?, profiles: [Int : VKApiObject]) {
        super.init(response: response, profiles: profiles)
        guard let json = response else {
            return
        }
                
        let data = JSON(json)
        title = data["message"]["title"].string
        chatId = message.chatId
        usersCount = data["message"]["users_count"].int
        adminId = data["message"]["admin_id"].int
        photo_100 = data["message"]["photo_100"].string
        
    }
    
}
