//
//  DialogsViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 16.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit
import VK_ios_sdk

class DialogsViewModel {
    private weak var services: VMServicesProtocol!
    var conversations = [DialogViewModel]()
        
    required init(_ services: VMServicesProtocol) {
        self.services = services
    }
    
    func loadDialogs(complition: @escaping ([IndexPath]) -> (), faild: @escaping (Error?) -> ()) {
        services.networkManager.loadDialogs(offset: conversations.count, success: { (model) in
            
            guard let dialogsModel = model else {
                faild(nil)
                return
            }
            
            var indexPathsToInsert = [IndexPath]()
            for i in self.conversations.count ..< self.conversations.count + dialogsModel.conversations.count {
                indexPathsToInsert.append(IndexPath(row: i, section: 0))
            }
            
            self.conversations.append(contentsOf: self.configureViewModelsWith(dialogsModel))
            complition(indexPathsToInsert)
            
        }) { (error) in
            faild(error)
        }
    }
    
    func refreshDialogs(complition: @escaping ([IndexPath], [IndexPath]) -> (), faild: @escaping (Error?) -> ()) {
        services.networkManager.loadDialogs(offset: 0, success: { (model) in
            
            guard let dialogsModel = model else {
                faild(nil)
                return
            }
            
            var indexPathsToDelete = [IndexPath]()
            if dialogsModel.conversations.count < self.conversations.count {
                let range = dialogsModel.conversations.count ..< self.conversations.count
                for i in range {
                    indexPathsToDelete.append(IndexPath(row: i, section: 0))
                }
                self.conversations.removeSubrange(range)
            }
            
            var indexPathsToUpdate = [IndexPath]()
            
            for (index, value) in self.configureViewModelsWith(dialogsModel).enumerated() {
                if value != self.conversations[index] {
                    indexPathsToUpdate.append(IndexPath(row: index, section: 0))
                    self.conversations[index] = value
                }
            }
            complition(indexPathsToUpdate, indexPathsToDelete)
            
        }) { (error) in
            faild(error)
        }
    }
    
    private func configureViewModelsWith (_ dialogsModel: DialogsModel) -> [DialogViewModel] {
        var viewModels = [DialogViewModel]()
        dialogsModel.conversations.forEach({ (conversation) in
            if let chat = conversation as? ChatModel {
                viewModels.append(ChatViewModel(model: chat, services: self.services))
            } else if let dialog = conversation as? DialogModel {
                viewModels.append(DialogViewModel(model: dialog, services: self.services))
            }
        })
        return viewModels
    }
}

extension DialogsViewModel: ControllerNodeVMProtocol {
}
