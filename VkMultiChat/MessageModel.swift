//
//  MessageModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class MessageModel {
    
    var owner: VKApiObject!
    var id: Int!
    var text: String!
    var dateInterval: Int!
    var isOutMessage: Bool!
    var userId: Int!
    var fromId: Int?
    var chatId: Int?
    var isRead: Bool!
    var previewImgName: String!
    
    var fwdMessages = [MessageModel]()
    
    var images: [VKPhoto]!
    var audios: [VKAudio]!
    var documents: [VKDocs]!
    var links: [VKLink]!
    
    
    required init(response: [String : Any]?, profiles: [Int : VKApiObject]) {
        
        guard let json = response else {
            return
        }
        
        id = json["id"] as? Int
        text = json["body"] as? String
        dateInterval = json["date"] as? Int
        isOutMessage = json["out"] as? Bool
        userId = json["user_id"] as? Int
        fromId = json["from_id"] as? Int
        isRead = json["read_state"] as? Bool
        owner = profiles[userId]
        chatId = json["chat_id"] as? Int
        
        if let action = json["action"] as? String {
            switch action {
            case "chat_kick_user":
                text = "пользователь покинул беседу"
                previewImgName = "user_delete"
            default:
                text = "что-то произошло"
            }
        }
        
        if let attachments = json["attachments"] as? [[String : Any]] {
            if text.characters.count > 0 {
                text = "\(attachments.count) файлов"
            }
            previewImgName = "attachment"
        }
        
        //FIXME: - Configure attachments
        
        if let nestedMessages = json["fwd_messages"] as? [[String : Any]] {
            if text.characters.count > 0 {
                text = "\(nestedMessages.count) сообщений"
            }
            previewImgName = "message"
            nestedMessages.forEach({ (messageDict) in
                fwdMessages.append(MessageModel(response: messageDict, profiles: profiles))
            })
        }
        
    }
}

