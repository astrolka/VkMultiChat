//
//  DialogCellNode.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 17.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit

class DialogCellNode: ASCellNode {
    
    weak var viewModel: DialogViewModel!
    
    //MARK: - Properties
    
    private var imgSize: CGFloat = {
        return Util.isIpad() ? 140 : 72
    }()
    
    private var chatImgIdentificator: ASImageNode?
    private var messageImgIdentificator: ASImageNode?
    private var onlineIndicator: ASImageNode?
    private var dialogImg = ASNetworkImageNode()
    private var avatarImg: ASNetworkImageNode?
    private var titleNode = ASTextNode()
    private var messageNode = ASTextNode()
    private var dateNode = ASTextNode()
    
    //MARK: - Initialize
    
    required init(viewModel: Any) {
        super.init()
        backgroundColor = .white
        self.viewModel = viewModel as! DialogViewModel
        self.viewModel.cellNode = self
        setupNodes()
    }
    
    private func setupNodes() {
        
        if !viewModel.isRead && !viewModel.isOutMessage {
            backgroundColor = UIColor(red: 190 / 255, green: 205 / 255, blue: 235 / 255, alpha: 0.3)
        }
        
        dialogImg = ASNetworkImageNode.createWith(size: imgSize)
        dialogImg.delegate = self
        dialogImg.url = viewModel.dialogImageUrl
        addSubnode(dialogImg)
        
        titleNode.attributedText = NSAttributedString.forDialogTitle(text: viewModel.title)
        titleNode.truncationMode = .byTruncatingTail
        titleNode.maximumNumberOfLines = 1
        titleNode.style.flexShrink = 1
        addSubnode(titleNode)
        
        messageNode.attributedText = NSAttributedString.forMessagePreview(text: viewModel.message)
        messageNode.maximumNumberOfLines = self.viewModel.isOutMessage! ? 1 : 2
        messageNode.truncationMode = .byTruncatingTail
        messageNode.style.flexShrink = 1
        messageNode.style.flexGrow = 1
        if !viewModel.isRead && viewModel.isOutMessage {
            messageNode.clipsToBounds = true
            if Util.isIpad() {
                messageNode.cornerRadius = 8
                messageNode.textContainerInset = UIEdgeInsetsMake(8, 8, 8, 8)
            } else {
                messageNode.cornerRadius = 4
                messageNode.textContainerInset = UIEdgeInsetsMake(4, 4, 4, 4)
            }
            messageNode.backgroundColor = UIColor(red: 190 / 255, green: 205 / 255, blue: 235 / 255, alpha: 0.3)
        }
        addSubnode(messageNode)
        
        dateNode.attributedText = NSAttributedString.forDate(date: viewModel.date)
        dateNode.maximumNumberOfLines = 1
        addSubnode(dateNode)
        
        if viewModel.innerImageUrl != nil {
            avatarImg = ASNetworkImageNode.createWith(size: imgSize/2)
            avatarImg?.delegate = self
            avatarImg?.url = viewModel.innerImageUrl
            addSubnode(avatarImg!)
        }
        
        if let imgName = viewModel.titleImageName {
            chatImgIdentificator = ASImageNode()
            chatImgIdentificator?.image = UIImage(named: imgName)
            addSubnode(chatImgIdentificator!)
        }
        
        if let imgName = viewModel.messageImageName {
            messageImgIdentificator = ASImageNode()
            messageImgIdentificator?.image = UIImage(named: imgName)
            addSubnode(messageImgIdentificator!)
        }
        
        if let imgName = viewModel.onlineImgName {
            onlineIndicator = ASImageNode()
            onlineIndicator?.style.width = ASDimensionMakeWithPoints(10)
            onlineIndicator?.style.height = ASDimensionMakeWithPoints(10)
            onlineIndicator?.image = UIImage(named: imgName)
            addSubnode(onlineIndicator!)
        }
                
    }
    
    //MARK: - Layout
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        var topHorizontalStackNodes = [ASLayoutElement]()
        
        if chatImgIdentificator != nil {
            topHorizontalStackNodes.append(chatImgIdentificator!)
        }
        topHorizontalStackNodes.append(titleNode)
        
        if onlineIndicator != nil {
            topHorizontalStackNodes.append(onlineIndicator!)
        }
        
        let spacer1 = ASLayoutSpec()
        spacer1.style.flexGrow = 1
        topHorizontalStackNodes.append(spacer1)
        
        topHorizontalStackNodes.append(dateNode)
        
        let topHorizontalStack = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .start, alignItems: .center, children: topHorizontalStackNodes)
        topHorizontalStack.style.alignSelf = .stretch
        
        var bottomHorizontalStackNodes = [ASLayoutElement]()
        
        if avatarImg != nil {
            bottomHorizontalStackNodes.append(avatarImg!)
        }
        if messageImgIdentificator != nil {
            bottomHorizontalStackNodes.append(messageImgIdentificator!)
        }
        bottomHorizontalStackNodes.append(messageNode)
        let bottomHorizontalStack = ASStackLayoutSpec(direction: .horizontal, spacing: 4, justifyContent: .center, alignItems: .center, children: bottomHorizontalStackNodes)
        bottomHorizontalStack.style.alignSelf = .stretch
        
        let verticalRightStack = ASStackLayoutSpec(direction: .vertical, spacing: 8, justifyContent: .end, alignItems: .start, children: [topHorizontalStack, bottomHorizontalStack])
        verticalRightStack.style.flexShrink = 1
        verticalRightStack.style.flexGrow = 1
        
        let horizontalStack = ASStackLayoutSpec(direction: .horizontal, spacing: 8, justifyContent: .end, alignItems: .start, children: [dialogImg, verticalRightStack])
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(4, 8, 4, 4), child: horizontalStack)
    }
    
    override func layout() {
        super.layout()
    }
    
}

extension DialogCellNode: ASNetworkImageNodeDelegate {
    func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        setNeedsLayout()
    }
}

extension DialogCellNode: CellNodeProtocol {
    func performSelection() {
        viewModel.openMessages()
    }
}
