//
//  NestedMessageContentNode.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 23.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import NMessenger
import AsyncDisplayKit

class NestedMessageContentNode: ASDisplayNode {
    
    private var numberOfVLines: Int!
    private var isFwdMessage = false
    private var viewModel: MessageViewModel!
    
    var vLines = [ASLayoutElement]()
    var header: HeaderFwdMessage?
    var textContent: TextContentNode?
    var textNode: ASTextNode?
    
    init(viewModel: MessageViewModel, numberOfVLines: Int) {
        super.init()
        self.viewModel = viewModel
        self.numberOfVLines = numberOfVLines
        self.isFwdMessage = numberOfVLines > 0 ? true : false
        initializeNodes()
    }
    
    func initializeNodes () {
        for _ in 0..<numberOfVLines {
            let vLine = VerticalDeterminator()
            vLines.append(vLine)
            addSubnode(vLine)
        }
        if isFwdMessage {
            header = HeaderFwdMessage(viewModel: viewModel)
            addSubnode(header!)
        }
        if viewModel.text.characters.count > 0 {
            textContent = TextContentNode(textMessageString: viewModel.text, bubbleConfiguration: nil)
            textContent?.backgroundBubble = nil
            textContent?.isIncomingMessage = viewModel.isIncomingMessage
            textContent?.insets = UIEdgeInsets.zero
            addSubnode(textContent!)
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        var stackElements = [ASLayoutElement]()
        if let node = header {
            stackElements.append(node)
        }
        if let node = textContent {
            stackElements.append(node)
        }
        let verticalStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .start, alignItems: .start, children: stackElements)
        verticalStack.style.flexShrink = 1
        
        if vLines.count > 0 {
            stackElements.removeAll()
            stackElements.append(contentsOf: vLines)
            stackElements.append(verticalStack)
            let spacing: CGFloat = Util.isIpad() ? 3 : 5
            let horizontalStack = ASStackLayoutSpec(direction: .horizontal, spacing: spacing, justifyContent: .start, alignItems: .stretch, children: stackElements)
            return horizontalStack
        } else {
            return verticalStack
        }
    }
    
}
