//
//  MessageNode.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 22.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import NMessenger
import AsyncDisplayKit

extension MessageGroup: ASNetworkImageNodeDelegate {
    public func imageNode(_ imageNode: ASNetworkImageNode, didLoad image: UIImage) {
        setNeedsLayout()
    }
}
