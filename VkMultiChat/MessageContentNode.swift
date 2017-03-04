//
//  MessageContentNode.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 23.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import NMessenger
import AsyncDisplayKit

class MessageContentNode: ContentNode {
    
    
    var viewModel: MessageViewModel!
    
    var nodes = [NestedMessageContentNode]()
    
    //MARK: - Initialization
    
    init(viewModel: MessageViewModel, bubbleConfiguration: BubbleConfigurationProtocol?) {
        super.init(bubbleConfiguration: bubbleConfiguration)
        self.viewModel = viewModel
        setupSubnodes(linesCount: 0, msgViewModel: viewModel)
    }
    
    fileprivate func setupSubnodes (linesCount: Int, msgViewModel: MessageViewModel) {
        let messageContentNode = NestedMessageContentNode(viewModel: msgViewModel, numberOfVLines: linesCount)
        nodes.append(messageContentNode)
        addSubnode(messageContentNode)
        for msgVM in msgViewModel.fwdMessages {
            setupSubnodes(linesCount: linesCount + 1, msgViewModel: msgVM)
        }
    }
    
    //MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 0, justifyContent: .start,
                                                  alignItems: .start, children: nodes)
        return ASInsetLayoutSpec(insets: UIEdgeInsets(top: 8, left: 10, bottom: 8, right: 10), child: verticalStackSpec)
    }
    
}
