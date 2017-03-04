//
//  ChatViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 21.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class ChatViewModel: DialogViewModel {
    
    required init(model: Any, services: VMServicesProtocol) {
        super.init(model: model, services: services)
        
        guard let chat = model as? ChatModel else {
            return
        }
        self.model = chat
        if let imgUrl = chat.photo_100 {
            dialogImageUrl = URL(string: imgUrl)
        }
        
        isChat = true
        titleImageName = "chat"
        title = chat.title
        onlineImgName = nil
        
        if let group = chat.profile as? VKGroup {
            innerImageUrl = URL(string: group.photo_100)
        } else if let user = chat.profile as? VKUser {
            innerImageUrl = URL(string: user.photo_100)
        }
    }
}
