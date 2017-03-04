//
//  VkViewModelServicesImpl.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 15.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk

class ViewModelServices {
    
    var navController: UINavigationController!
    
    required init(_ navController: UINavigationController) {
        self.navController = navController
    }
    
}

extension ViewModelServices: VMServicesProtocol {
    
    var SCOPE: [String] {
        return [VK_PER_PHOTOS, VK_PER_VIDEO, VK_PER_AUDIO, VK_PER_DOCS, VK_PER_MESSAGES, VK_PER_OFFLINE, VK_PER_NOTIFICATIONS]
    }
    
    
    var networkManager: NetworkManager! {
        return NetworkManager.sharedInstance
    }
    
    func pushViewModel(_ viewModel: Any, animated: Bool) {
        if viewModel is LoginViewModel {
            let vc = LoginViewController(viewModel: viewModel)
            navController.pushViewController(vc, animated: animated)
        } else if viewModel is DialogsViewModel {
            let vc = DialogsViewController(viewModel: viewModel)
            navController.pushViewController(vc, animated: animated)
        } else if viewModel is MessagesViewModel {
            let vc = MessagesController(viewModel: viewModel)
            navController.pushViewController(vc, animated: animated)
        }
    }
    
    func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "OK", style: .destructive, handler: nil)
        alert.addAction(cancelAction)
        
        navController.topViewController?.present(alert, animated: true, completion: nil)
    }
    
    
    
    func loadDialogs(offSet: Int) -> [Any] {
        return Array<Any>()
    }
}
