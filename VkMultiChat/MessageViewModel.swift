//
//  MessageViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 22.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class MessageViewModel {
    
    var isInChat = false
    var isIncomingMessage = false
    var avatarImageUrl: URL?
    var text: String!
    var model: MessageModel!
    private var services: VMServicesProtocol!
    
    var title: String!
    var date: String!
    
    var fwdMessages = [MessageViewModel]()
    
    init(model: MessageModel, services: VMServicesProtocol) {
        self.services = services
        if model.chatId != nil {
            isInChat = true
        }
        if model.isOutMessage != nil {
            isIncomingMessage = !model.isOutMessage
        }
        if let user = model.owner as? VKUser {
            avatarImageUrl = URL(string: user.photo_100)
            title = "\(user.first_name ?? "") \(user.last_name ?? "")"
        } else if let group = model.owner as? VKGroup {
            avatarImageUrl = URL(string: group.photo_100)
            title = group.name
        }
        date = Util.formatedDateForMessages(interval: model.dateInterval)
        text = model.text
        self.model = model
        
        for fwdMsgModel in model.fwdMessages {
            fwdMessages.append(MessageViewModel(model: fwdMsgModel, services: services))
        }
        
    }
    
}
