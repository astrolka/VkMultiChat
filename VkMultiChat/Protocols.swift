//
//  Protocols.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 15.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit
import VK_ios_sdk

protocol VMServicesProtocol: class {
    
    var networkManager: NetworkManager! {get}
    var SCOPE: [String] {get}
    
    init(_ navController: UINavigationController)
    
    func pushViewModel(_ viewModel: Any, animated: Bool)
    
    func presentErrorAlert(message: String)
    
}

protocol ModelProtocol {
    init(response: [String : Any]?)
}

protocol ConversationModelProtocol {
    init(response: [String : Any]?, profiles: [Int : VKApiObject])
}

protocol ControllerNodeVMProtocol {
    init(_ services: VMServicesProtocol)
}

protocol CellNodeVMProtocol {
    init(model: Any, services: VMServicesProtocol)
    func getCellNode () -> ASCellNode
    func openMessages()
}

protocol NodeProtocol {
    init(viewModel: Any)
}

protocol CellNodeProtocol: NodeProtocol {
    func performSelection()
}
