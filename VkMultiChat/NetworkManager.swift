//
//  NetworkManager.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import VK_ios_sdk


class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    private init() {}
    
    func loadDialogs(offset: Int, success: @escaping (DialogsModel?) -> (), failure: @escaping (Error?) -> ()) {
        let request = VKRequest(method: "messages.getDialogs", parameters: ["offset" : offset, "count" : 50])
        
        request?.execute(resultBlock: { (vkResponse) in
            let _ = DialogsModel(response: vkResponse?.json as? [String : Any], complition: success, faild: failure)
        }, errorBlock: { (error) in
            failure(error)
        })
    }
    
    func loadUsersAndGroups(usersId: [Int], groupsId: [Int], success: @escaping ([Int : VKApiObject]) -> (), failure: @escaping (Error?) -> ()) {
        var requests = [VKRequest]()
        if usersId.count > 0 {
            let usersRequest = VKRequest(method: "users.get", parameters: [VK_API_USER_IDS : usersId, VK_API_NAME_CASE : "Nom",
                                                                           VK_API_FIELDS : "photo_100,online,last_seen"])
            requests.append(usersRequest!)
        }
        if groupsId.count > 0 {
            let groupsRequest = VKRequest(method: "groups.getById", parameters: [VK_API_GROUP_IDS : groupsId, VK_API_FIELDS : "description"])
            requests.append(groupsRequest!)
        }
        
        
        let batchRequest = VKBatchRequest(requestsArray: requests)
        
        batchRequest?.execute(resultBlock: { (response) in
            var profiles = [Int : VKApiObject]()
            
            if (response?.count)! > 0 {
                if let usersDict = (response?[0] as? VKResponse)?.json as? [[String : Any]] {
                    let users = VKUsersArray(array: usersDict)
                    if let temp = users?.items, let usersArr = temp as NSArray as? [VKUser] {
                        profiles.addObjectsFromArray(usersArr) { [$0.id.intValue : $0] }
                    }
                }
            }
            if (response?.count)! > 1 {
                if let groupsDict = (response?[1] as? VKResponse)?.json as? [[String : Any]] {
                    let groups = VKGroups(array: groupsDict)
                    if let temp = groups?.items, let groupsArr = temp as NSArray as? [VKGroup] {
                        profiles.addObjectsFromArray(groupsArr) { [-$0.id.intValue : $0] }
                    }
                    
                }
            }
            success(profiles)
        }, errorBlock: { (error) in
            failure(error)
        })
    }
    
    func loadMessages(parameters: [String : Any], success: @escaping (MessagesModel) -> (), faild: @escaping (Error?) -> ()) {
        let request = VKRequest(method: "messages.getHistory", parameters: parameters)
        
        request?.execute(resultBlock: { (vkResponse) in
            let _ = MessagesModel(response: vkResponse?.json as? [String : Any], succeed: success, faild: faild)
        }, errorBlock: { (error) in
            faild(error)
        })
    }
    
//    func loadUsersInfo(ids: [Int], success: @escaping (VKUsersArray) -> ()) {
//        
//        let request = VKRequest(method: "users.get", parameters: [VK_API_USER_IDS : ids, VK_API_NAME_CASE : "Nom",
//                                                                  VK_API_FIELDS : "photo_100,online,last_seen"])
//        
//        request?.execute(resultBlock: { (response) in
//            DispatchQueue.global().async {
//                guard let json = response?.json as? [Any] else {
//                    return
//                }
//                success(VKUsersArray(array: json))
//            }
//        }, errorBlock: { (error) in
//        })
//        
//        
//        
//    }
//    
//    func loadGroupsInfo(ids: [Int], success: @escaping (VKGroups) -> ()) {
//        let request = VKApi.groups().getById([VK_API_GROUP_ID : ids, VK_API_FIELDS : "description"])
//        
//        request?.execute(resultBlock: { (response) in
//            DispatchQueue.global().async {
//                guard let json = response?.json as? [Any] else {
//                    return
//                }
//                success(VKGroups(array: json))
//            }
//        }, errorBlock: { (error) in
//        })
//    }

    
}
