//
//  VerticalDeterminator.swift
//  VkMultiChat
//
//  Created by Александр Смоленский on 24.02.17.
//  Copyright © 2017 Александр Смоленский. All rights reserved.
//

import AsyncDisplayKit

class VerticalDeterminator: ASDisplayNode {
    override init() {
        super.init()
        let width: CGFloat = Util.isIpad() ? 3 : 1.5
        style.width = ASDimensionMakeWithPoints(width)
        style.flexGrow = 1
        backgroundColor = .gray
    }
}
