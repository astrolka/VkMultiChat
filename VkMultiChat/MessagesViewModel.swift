//
//  MessagesViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 21.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class MessagesViewModel {
    
    private weak var services: VMServicesProtocol!
    var messages = [MessageViewModel]()
    var dialogViewModel: DialogViewModel!
    
    init(_ services: VMServicesProtocol, dialogViewModel: DialogViewModel) {
        self.dialogViewModel = dialogViewModel
        self.services = services
    }
    
    func loadMessages(complition: @escaping ([MessageViewModel]) -> (), faild: @escaping (Error?) -> ()) {
        var dictParams = [String : Any]()
        dictParams[VK_API_OFFSET] = messages.count
        dictParams[VK_API_COUNT] = 50
        
        if dialogViewModel.isChat {
            dictParams["peer_id"] = 2000000000 + dialogViewModel.model.chatId
        } else {
            if let user = dialogViewModel.model.profile as? VKUser {
                dictParams["peer_id"] = user.id.intValue
            } else if let group = dialogViewModel.model.profile as? VKGroup {
                dictParams["peer_id"] = -group.id.intValue
            }
        }
        
        services.networkManager.loadMessages(parameters: dictParams, success: { (messagesModel) in
            var messageViewModels = [MessageViewModel]()
            for messageModel in messagesModel.models {
                messageViewModels.append(MessageViewModel(model: messageModel, services: self.services))
            }
            complition(messageViewModels)
        }) { (error) in
            faild(error)
        }
    }
    
}

