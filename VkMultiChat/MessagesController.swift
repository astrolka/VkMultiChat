//
//  MessagesController.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 21.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import NMessenger
import AsyncDisplayKit

class MessagesController: NMessengerViewController {
    
    var viewModel: MessagesViewModel!
    
    private var shouldLoad = true
    
    init(viewModel: Any) {
        super.init()
        self.viewModel = viewModel as! MessagesViewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadNewMessages()
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func loadNewMessages() {
        shouldLoad = false
        weak var weakSelf = self
        viewModel.loadMessages(complition: { (messages) in
            weakSelf?.insertNewMessages(messages: messages)
            self.shouldLoad = true
        }) { (error) in
            self.shouldLoad = true
        }
    }
    
    fileprivate func insertNewMessages (messages: [MessageViewModel]) {
        var mesageGroups = [MessageGroup]()
        var lastGroup: MessageGroup!
        var previousVM: MessageViewModel!
        for messageVM in messages.reversed() {
            let content = MessageContentNode(viewModel: messageVM, bubbleConfiguration: sharedBubbleConfiguration)
            let message = MessageNode(content: content)
            message.cellPadding = messagePadding
            message.currentViewController = self
            if lastGroup == nil || previousVM.model.userId != messageVM.model.userId || lastGroup.isIncomingMessage != messageVM.isIncomingMessage {
                let newGroup = createMessageGroupFor(message: messageVM)
                newGroup.isIncomingMessage = messageVM.isIncomingMessage
                newGroup.addMessageToGroup(message, completion: nil)
                mesageGroups.append(newGroup)
                lastGroup = newGroup
            } else {
                lastGroup.addMessageToGroup(message, completion: nil)
            }
            previousVM = messageVM
        }
        self.messengerView.addMessages(mesageGroups, scrollsToMessage: false)
        self.messengerView.scrollToLastMessage(animated: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Private methods
    
    private func createMessageGroupFor (message: MessageViewModel) -> MessageGroup {
        let group = MessageGroup()
        group.currentViewController = self
        group.cellPadding = messagePadding
        if message.isInChat && message.isIncomingMessage {
            group.avatarNode = createAvatarNode(url: message.avatarImageUrl, group: group)
        }
        group.messageOffset = 3
        return group
    }
    
    private func createAvatarNode (url: URL?, group: MessageGroup) -> ASNetworkImageNode {
        let imgSize: CGFloat = Util.isIpad() ? 20 : 40
        let img = ASNetworkImageNode.createWith(size: imgSize)
        img.url = url
        img.delegate = group
        return img
    }
    
    func batchFetchContent() {
        
    }
    
    deinit {
        print("MessagesController deinitialized")
    }
}
