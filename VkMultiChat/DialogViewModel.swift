//
//  DialogViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit
import VK_ios_sdk

class DialogViewModel {
    
    var title = ""
    var message: String!
    var date: String!
    var dialogImageUrl: URL!
    var isOutMessage: Bool!
    var isRead: Bool!
    var isChat = false
    var innerImageUrl: URL?
    var titleImageName: String?
    var messageImageName: String?
    var onlineImgName: String?
    
    private weak var services: VMServicesProtocol!
    weak var cellNode: DialogCellNode!
    var model: DialogModel!
    
    required init(model: Any, services: VMServicesProtocol) {
        self.services = services
        if let dialog = model as? DialogModel {
            self.model = dialog
        }
        initialize()
    }
    
    //MARK: - Private Methods
    
    private func initialize () {
        
        if let user = model.profile as? VKUser {
            if let firstName = user.first_name {
                title += firstName
            }
            if let lastName = user.last_name {
                title += " " + lastName
            }

            if let onlineNumb = user.online_mobile {
                onlineImgName = onlineNumb.boolValue ? "online_mobile" : onlineNumb.boolValue ? "online_pc" : nil
            }
            dialogImageUrl = URL(string: user.photo_100)
        } else if let group = model.profile as? VKGroup {
            title = group.name
            dialogImageUrl = URL(string: group.photo_100)
        }
        messageImageName = model.message.previewImgName
        isRead = model.message.isRead
        date = Util.formatedDateForMessages(interval: model.message.dateInterval)
        isOutMessage = model.message.isOutMessage
        message = model.message.text
        if isOutMessage! {
            if let strImgUrl = VKSdk.accessToken().localUser.photo_100 {
                innerImageUrl = URL(string: strImgUrl)
            }
        }
    }
    
    static func !=(st: DialogViewModel, nd: DialogViewModel) -> Bool {
        return st.title != nd.title ||
            st.message != nd.message ||
            st.dialogImageUrl != nd.dialogImageUrl ||
            st.isRead != nd.isRead ||
            st.innerImageUrl != nd.innerImageUrl ||
            st.onlineImgName != nd.onlineImgName
    }
    
    func openMessages() {
        let vm = MessagesViewModel(services, dialogViewModel: self)
        services.pushViewModel(vm, animated: true)
    }
}

extension DialogViewModel: CellNodeVMProtocol {
    
    internal func getCellNode() -> ASCellNode {
        return DialogCellNode(viewModel: self)
    }
    
}
