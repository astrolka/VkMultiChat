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
    
    fileprivate class VLineParameters: NSObject {
        var size: CGFloat
        var count: Int
        
        init(size: CGFloat, count: Int) {
            self.size = size
            self.count = count
        }
    }
    
    private var numberOfVLines: CGFloat = 0
    private let vLineWidth: CGFloat = Util.isIpad() ? 3 : 1.5
    private var isFwdMessage = false
    private var viewModel: MessageViewModel!
    
    var header: HeaderFwdMessage?
    var textContent: TextContentNode?
    var textNode: ASTextNode?
    
    init(viewModel: MessageViewModel, numberOfVLines: Int) {
        super.init()
        self.viewModel = viewModel
        self.numberOfVLines = CGFloat(numberOfVLines)
        self.isFwdMessage = numberOfVLines > 0 ? true : false
        initializeNodes()
    }
    
    func initializeNodes () {
        backgroundColor = .clear
        isOpaque = false
        
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
        
        let leftPadding = numberOfVLines * 2 * vLineWidth
        
        return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(0, leftPadding, 0, 0), child: verticalStack)
    }
    
    override class func draw(_ bounds: CGRect, withParameters parameters: NSObjectProtocol?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {
        
        guard let vLineParams = parameters as? VLineParameters, vLineParams.count > 0, !isCancelledBlock() else {
            return
        }
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(vLineParams.size)
        context?.setStrokeColor(UIColor.lightGray.cgColor)
        context?.setLineCap(.round)
        
        var xCoord = 0.5 * vLineParams.size
        for _ in 1...vLineParams.count {
            context?.move(to: CGPoint(x: xCoord, y: bounds.minY))
            context?.addLine(to: CGPoint(x: xCoord, y: bounds.maxY))
            
            xCoord += vLineParams.size * 2
        }
        
        context?.strokePath()
    }
    
    override func drawParameters(forAsyncLayer layer: _ASDisplayLayer) -> NSObjectProtocol? {
        return VLineParameters(size: vLineWidth, count: Int(numberOfVLines))
    }
}
