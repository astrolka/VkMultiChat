//
//  LoginViewModel.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 16.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class LoginViewModel: NSObject {
    
    weak var services: VMServicesProtocol!
    
    required init(_ services: VMServicesProtocol) {
        self.services = services
    }
}

extension LoginViewModel: ControllerNodeVMProtocol {
}

extension LoginViewModel: VKSdkDelegate {
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if result.error != nil {
            services.presentErrorAlert(message: "Something gone wrong, please try again")
            return
        }
        let dialogsVM = DialogsViewModel(services)
        services.pushViewModel(dialogsVM, animated: true)
    }
    
    func vkSdkUserAuthorizationFailed() {
        services.presentErrorAlert(message: "Something gone wrong, please try again")
    }
}
