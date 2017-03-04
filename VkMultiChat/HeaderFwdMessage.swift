//
//  HeaderFwdMessage.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 24.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit

class HeaderFwdMessage: ASDisplayNode {
    
    var viewModel: MessageViewModel!
    
    var imgNode: ASNetworkImageNode!
    var titleNode: ASTextNode!
    var dateNode: ASTextNode!
    
    init(viewModel: MessageViewModel) {
        super.init()
        self.viewModel = viewModel
        initialize()
    }
    
    fileprivate func initialize () {
        let imgSize: CGFloat = Util.isIpad() ? 40 : 20
        imgNode = ASNetworkImageNode.createWith(size: imgSize)
        imgNode.url = viewModel.avatarImageUrl
        imgNode.delegate = self
        addSubnode(imgNode)
        
        titleNode = ASTextNode()
        titleNode.attributedText = NSAttributedString.forFwdMessageTitle(text: viewModel.title)
        titleNode.style.flexGrow = 1
        titleNode.style.flexShrink = 1
        titleNode.truncationMode = .byTruncatingTail
        titleNode.maximumNumberOfLines = 1
        addSubnode(titleNode)
        
        dateNode = ASTextNode()
        dateNode.attributedText = NSAttributedString.forDate(date: viewModel.date)
        dateNode.maximumNumberOfLines = 1
        addSubnode(dateNode)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let verticalStackSpec = ASStackLayoutSpec(direction: .vertical, spacing: 4, justifyContent: .start, alignItems: .start, children: [titleNode, dateNode])
        
        return ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .start, alignItems: .center, children: [imgNode, verticalStackSpec])
    }

}

extension HeaderFwdMessage: ASNetworkImageNodeDelegate {
    
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        setNeedsLayout()
    }
    
}
