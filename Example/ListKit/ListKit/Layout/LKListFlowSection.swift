//
//  LKListFlowSection.swift
//  ListKit
//
//  Created by zhbhun on 2024/12/11.
//  Copyright © 2024 CocoaPods. All rights reserved.
//

import UIKit

public struct LKListFlowSection<SectionIdentifier, ItemIdentifier>
where
    SectionIdentifier: Hashable, SectionIdentifier: Sendable,
    ItemIdentifier: Hashable, ItemIdentifier: Sendable
{
    
    public let inset: LKListEdgeInsets?
    public let mainAxisSpacing: LKListFloat?
    public let crossAxisSpacing: LKListFloat?
    public let header: LKListFlowSectionHeader<SectionIdentifier>?
    public let footer: LKListFlowSectionHeader<SectionIdentifier>?
    public let item: LKListFlowItem<ItemIdentifier>
    
    public init(
        inset: LKListEdgeInsets? = nil,
        mainAxisSpacing: LKListFloat? = nil,
        crossAxisSpacing: LKListFloat? = nil,
        header: LKListFlowSectionHeader<SectionIdentifier>? = nil,
        footer: LKListFlowSectionHeader<SectionIdentifier>? = nil,
        item: LKListFlowItem<ItemIdentifier>
    ) {
        self.inset = inset
        self.mainAxisSpacing = mainAxisSpacing
        self.crossAxisSpacing = crossAxisSpacing
        self.header = header
        self.footer = footer
        self.item = item
    }
}
